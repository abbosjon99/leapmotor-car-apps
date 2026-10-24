# LP Companion

Companion app for a Leapmotor C01 (2025) head unit (Android 12). It puts a launcher grid of your
sideloaded apps on both screens and opens them on the passenger screen (display 3). It also has
floating AssistiveTouch-style bubbles on both screens, a Settings page, a now-playing card, a
PIN-protected child mode and overload protection, and it wakes the passenger screen when something is
opened there.

Package: `uz.carhelper.passenger`  ·  current version: 2.39 (versionCode 47, installed on the car 2026-10-24)

**Music control is not done here any more.** Steering-wheel media keys and the car's media widget moved
to the sibling app **LP Music** (`com.migu.car.music`, p1.0, folder `../LP-Music`; it was `uz.carhelper.music` before
LP Music 2.19), which is installed on the car. LP Companion only shows and drives whatever MediaSession is
active (the now-playing card) and does not handle the wheel media keys.

## What it does

**Grid** (`MainActivity`)
- Every non-system launcher app, 5 per row, as frosted tiles over a wallpaper (solid black + 11 bundled
  images; the "Change wallpaper" tile cycles them). Tap an app = open it on the passenger screen.
- Header pills: Settings, Close apps, Hide/Show bar (the car's passenger sidebar). Tiles: Child mode /
  Exit child mode, Change wallpaper. Then the now-playing card.
- Runs on both screens at once (activities are started with NEW_TASK | MULTIPLE_TASK). The main-screen
  grid always lists every app; the passenger-screen grid is filtered while child mode is on.
- The two grids follow each other live: a wallpaper change or a child-mode change on one updates the
  other straight away (a shared-preferences listener in `MainActivity`).
- "Close apps" (`CloseDialog`): on the main screen it lists the sideloaded apps that are running (since 2.26:
  every app with an active MediaSession, plus what LP Companion opened on the passenger screen or moved to the
  main screen; apps hidden from the grid and LP Music are left out), on the passenger screen only what that
  screen opened. Tap an app to close it (the row goes away and the popup stays open until the last one is
  closed), or red "Close all". Closing stops the app's media session, then kills its background process 2.5 s
  later (`Closer`). From the main screen, an app that is showing on the passenger screen is first covered with
  the LP grid there (`Swapper.grid`), because Android will not kill an app that is still on screen. Other apps'
  processes are not visible to LP Companion on this firmware (`getRunningAppProcesses` returns only its own), so
  an idle app with no media session that LP did not start is not listed.
- Tile menu (since 2.27, `TileMenu`): a tap opens the app on the passenger screen; a long press shows Open on the
  main screen / Open on the passenger screen / Add to (Remove from) Kids / Hide from the grid. Not in child mode on
  the passenger screen; "Open on the main screen" is also left out while child mode is on.
- Close apps has a blue "All but music" button when a listed app is playing: it closes everything that is not.
- Header chip (since 2.27, `Health`, `HealthTick`; shown only when Settings > Protection > "Show the RAM and temperature status on the grid" (`showStatus`, default off, since 2.33) is on): "RAM 62%  .  54 C", updated every 5 s and coloured by the same
  thresholds overload protection uses. Temperature comes from the thermal-zone files if the firmware lets apps read
  them, otherwise only Android's thermal status is shown (the C01 has no thermal zones and its thermal HAL reports one fixed "test temperature sensor", so on this car the chip says "temp OK"). Hidden for the child on the passenger screen.
- Look: the wallpaper gets only a light dim (`Theme.scrim`) and the tiles/pills are dark smoked glass
  (`Ui.glass`, `Ui.pillBg`) so the photo stays as sharp as it can be; the bundled photos are only 1280x720.
- Optional auto-close: opening an app closes the previous one (`autoClose`, plus `closeMusic`).

**Now-playing card** (`NowPlaying`)
- Rounded cover, bold title, artist, a progress bar and prev / play-pause / next for any active
  MediaSession (car radio, Bluetooth, Leapmotor media or a sideloaded player). The card is tinted with the
  cover's average colour. Tapping the cover or title opens that player on the passenger screen.
- Hidden when nothing is playing, and always hidden in child mode on the passenger screen (no controls and
  no way into the music app). Needs the notification-listener grant (below).

**Bubbles**
- Passenger screen (`BubbleService`, display 3): panel with Screen off (top), Back / Home (= the LP
  Companion grid) / Hide-Show bar, and the move arrows (bottom row). It also runs overload protection (every 30 s: low RAM,
  or load average above 7 twice in a row, or thermal status SEVERE -> close passenger apps and show a red
  warning, at most every 2 minutes; pref `overheat`), the passenger auto-open (`PassengerWatcher`) and the
  Back-service repair (`BackRepair`).
- Main screen (`MainBubbleService`, display 0): Turn off passenger screen (top), Back / LP Companion (opens
  the grid on the main screen) / child-mode button, and the two move arrows.
- Back-off rule (both bubbles): when the Back accessibility service is off, Back is dropped and LP Companion
  shifts left.
- Auto-close (since 2.25): an open panel closes itself after a few seconds without a tap (`AutoClose`
  runnable, re-armed by each tap; Settings > Bubble menu: `bubbleAuto` default on, `bubbleSecs` default 8, choices
  3/5/8/10/15 s, set with a - / value / + stepper since 2.33). The passenger panel is rebuilt each time it opens.
- Screen off = an opaque black cover over display 3; tap it to restore. Opening something on the passenger
  screen removes it (see Wake).
- Moving apps between the screens (since 2.23; bottom row of both panels, icons `ic_move_left` /
  `ic_move_right`: a rounded screen with an arrow entering it). "<-" sends the app that is on the passenger
  screen to the main screen, "->" sends the main-screen app to the passenger screen. The main bubble always has
  both; the passenger bubble has "<-" (setting `passToMain`, on by default) and "->" (`passFromMain`, off by
  default), each hidden when its setting is off. A button is grayed when there is no app to move that way, and
  tapping it says why. Only apps LP Companion itself opened on the passenger screen or moved to the main screen
  are known, so "->" on the main bubble stays gray for an app the car launcher put on the main screen. Off in
  child mode.
- How a move works (`Swapper`): a launch with NEW_TASK | RESET_TASK_IF_NEEDED and the same intent a grid tap
  uses (action MAIN, category LAUNCHER, component only), which makes Android move the app's EXISTING task to the
  other display. Then the screen the app left is covered: the passenger screen with the LP grid, the main screen
  with the car's Home. The old swap used MULTIPLE_TASK, which made a new task on every swap and left the old one
  running, so an app (Yandex Music Lite) ended up open on both screens. 2.23 still added a second activity inside
  the moved task because its intent carried `pkg=`; 2.24 fixed that. A task that is already damaged this way
  stays so until the app is force-stopped.
- Why an app moved from the passenger screen can draw under the car's bars (found on the car 2026-10-24): the bars
  are inset sources of display 0 only, and a window that is merely moved keeps the InsetsState it got on the display
  it was created on (`dumpsys activity top`, InsetsController of the app: `mDisplayFrame=(0,0-1920,720)` and no
  STATUS_BAR / NAVIGATION_BAR after the move; a fresh start on the main screen has `(0,0-2560,1440)` plus both bars).
  Stop/start, a control-target change and showing/hiding the keyboard do not refresh it.
- Settings > Passenger screen > "Restart an app when it is moved to the main screen" (`moveRestart`, since 2.39, default
  off): the move to the main screen then uses NEW_TASK | CLEAR_TASK (0x10008000) instead of RESET_TASK_IF_NEEDED, so
  Android starts the app again on display 0 and its new window gets the bars. The app begins from its first screen. Only
  toward the main screen: CLEAR_TASK ignores the requested display for any other display (an app sent to display 3 this
  way started on display 0 in the car), so a move to the passenger screen is always the plain move. Apps whose
  launcher activity forwards the intent flags to a second activity and finishes (Opera Mini's `Default` -> `MiniActivity`)
  must not be restarted twice in a row on the same display (the second launch closed Opera in the 2.38 test), which is why
  this is a single launch and not "move, then restart".
- Apps decide their own insets. The car gives every app the full display frame plus insets for its top bar
  (120 px) and bottom bar (144 px) on the main screen. Most apps respect them; a few request edge-to-edge themselves
  (YouTube ReVanced: `LAYOUT_FULLSCREEN | LAYOUT_HIDE_NAVIGATION | IMMERSIVE_STICKY`, ContraCam: `LAYOUT_FULLSCREEN`,
  Yandex Music's "В авто" player) and draw under the bars even on a fresh start; only a patch of that app helps.

**Install / uninstall apps** (since 2.30; Settings > Vehicle card, `apk` package): "Install apps from storage" is a
read-only browser (device storage of the car's user plus mounted USB drives; only folders and plain `.apk`, bundles greyed
out; `Android`, dot-folders and system folders never shown). Tapping an APK shows a warning card (what it is, new / update,
sensitive permissions, signature and self-install warnings), the "Grant all permissions (-g)" switch (off; turning it on
needs a second "I know what I am doing"), and an Install button locked for 10 s. The APK is streamed through the car's own
adb (`cmd package install -S size --install-reason 64 -r [-g]`). A Delete button removes an APK file after a warning.
"Uninstall apps" lists only the apps installed this way (private record `installed`, also in the backup) and removes one
through adb after a confirm card with a 10 s lock. Needs the All files access permission (Grant button on the page).
Source: `adbclient/src/.../apk/*.java` (compiled against `tools/android.jar`), converted by `adbclient/build-adb.ps1`.

**Permission self-repair** (since 2.29, `Heal`, `adb` package): when WRITE_SECURE_SETTINGS, "draw over other apps" or
notification access is missing (after a reboot or firmware update), the app connects from the head unit to its own wifi adb
(127.0.0.1:5555) with its own RSA key and runs only the three grant commands (`pm grant`, `appops set`, `cmd notification
allow_listener`; anything else is refused). Runs when the bubble service or the grid starts (at most every 10 minutes, with
retries while adbd is not up yet) and from Settings > Status > "Fix permissions now"; the switch "Fix missing permissions
automatically using the car's own ADB" (`healAdb`, default on) turns the automatic part off. The first time the car may ask
"Allow USB debugging?" for this app: choose Always allow. Needs wifi adb listening on the head unit and the INTERNET
permission (in the manifest). The client is Java in `adbclient/` with tests against a mock adbd; `adbclient/build-adb.ps1`
compiles it, runs the tests, converts it with D8 (`tools/r8.jar`, not in git) and writes `source/smali/.../adb/`.
Tried against the car's real adbd on 2026-10-24 (2.34): all three grants came back in under 0.1 s with no prompt; see TEST-SCENARIO.md P-1.
Since 2.31 the handshake also tries the second signature style and, if adbd asks again after the key, the other public-key
byte order (remembered in `adbkey.hint`), and says so when the car is in TLS (wireless-debugging) mode. `apk/AdbLink` checks
that adbd listens before each job and, when allowed (`healAdb` on, WRITE_SECURE_SETTINGS granted), sets `adb_enabled` to 1
again; `apk/AdbGate` greys out "Install apps from storage" and "Uninstall apps" in Settings while adbd cannot be reached.

**Languages** (since 2.28, `Lang`, `LangDialog`): Uzbek, Russian, Spanish, English, Chinese. The language is the one
picked in Settings > Language; if none was picked, the system language when it is Uzbek, Russian, Spanish or English;
otherwise English (so a Chinese system starts in English). All texts live in the code as English and go through
`Lang.t(english)`; the translations are in `translations.txt` (english||uz||ru||es||zh), turned into
`source/assets/lang/*.tsv` by `make-lang.ps1`. A text without a translation just shows in English. To add a text, see
the 2.28 entry in CHANGELOG.txt.

**Resume on wake** (since 2.27, `PassengerWatcher.resume`, setting `resumeLast`, default on): when the passenger
screen turns on, the app that was open there comes back instead of the grid (only if LP still lists it as running; in
child mode only a Kids app). Part of the "open LP Companion when the passenger screen turns on" setting.

**Backup and recovery** (since 2.27, `Backup`; needs `WRITE_SECURE_SETTINGS`)
- The settings are kept as JSON in `Settings.Secure` key `lp_companion_backup` (after Settings > Save, the tile menu
  and whenever a grid stops) and come back on the first start with empty data (`pm clear`, reinstall). Not included:
  the password, child mode on/off, and the running / lastPassenger / onMain records.
- Forgot the password: `adb shell settings put secure lp_companion_pin_reset 1`, then open LP Companion. The
  password is cleared and child mode is off; everything else stays (no more `pm clear` for this).

**Child mode** (state is shared with LP Music)
- Flag: pref `kid`, mirrored by `ChildMode.sync` to `Settings.Secure` key `lp_companion_child` ("1"/"0") so
  LP Music locks itself too. Only the passenger screen is restricted.
- While on (passenger screen): the grid shows only apps ticked "Kids" in Settings, Close apps is hidden, moving apps
  is off, Settings and leaving child mode need the PIN, and the now-playing card is hidden.
- Enter: the grid's Child mode tile (needs a PIN to exist) or the main bubble's child button (also needs a
  PIN since 2.22). Entered from the main screen it takes over the passenger screen (`ChildMode.enter` ->
  `takeOver`): an app ticked Kids that is running there is left alone (no close, no grid on top); any other
  passenger app is closed and the filtered grid opens; with no known app the grid opens.
- Leave: the "Exit child mode" tile asks for the PIN on a numeric pad (`PinDialog`, no system keyboard). Since
  2.22 the main bubble's child button also asks for it: it opens the grid on the main screen with extra
  `exitPin`, and `MainActivity` shows the pad. Leaving does nothing to the passenger screen (`ChildMode.exit` is
  empty since 2.25): open grids follow the `kid` pref live and an app in front stays.
- Forgot the PIN: since 2.27 `adb shell settings put secure lp_companion_pin_reset 1` and open LP Companion (see
  Backup and recovery). The old way, `adb shell pm clear --user 10 uz.carhelper.passenger`, resets ALL settings
  (they come back from the backup if the grant is there); then redo the one-time grants below.

**Wake** (`Wake.passenger`, since 2.20)
- After about 3 minutes without activity the car's `com.leapmotor.screensaver` covers the passenger screen:
  either a photo window ("screensaver") or "screen rest" (it writes Settings.Global `display_1_state` = 1 and
  the car blanks the screen). Starting an activity there does not clear either.
- Opening an app from the grid, tapping the now-playing cover/title, moving an app to the passenger screen and the
  child-mode takeover now: send the broadcast `com.leapmotor.system.service.DISMISS` (hides the photo),
  reset `display_1_state` and `display_2_state` to 0 if the car had put the screen to rest (needs the
  `WRITE_SECURE_SETTINGS` grant, skipped quietly without it), and remove LP Companion's own black cover.
- Verified on the car for the screensaver. The screen-rest path copies the car's own logic but has not been
  exercised. If the passenger screen ever stays blank:
  `adb shell settings put global display_1_state 0` and the same for `display_2_state`.

**Settings** (`SettingsActivity`; changes are held until Save, Cancel leaves without saving)
- Status: green/red rows for the bubble overlay, notification access, `WRITE_SECURE_SETTINGS` and the Back
  service, each with an OK/OFF chip and the ADB command that fixes it; "Re-check status" reopens the page.
  Opening the page also tries to switch the Back service on.
- Passenger screen (`autoOpen`, `passToMain`, `passFromMain`), Bubble menu (`bubbleAuto`, `bubbleSecs`), Closing apps (`autoClose`, `closeMusic`), Protection (`overheat`, `showStatus`), Child
  mode (Set password), Vehicle (Vehicle settings, Back to car UI) and the app checklist: one "shown on the
  passenger grid" tick and one "Kids" tick per sideloaded app. There is no steering-wheel section any more.

## Folder layout

```
LP-Companion/
  source/              apktool project (smali, AndroidManifest.xml, res/, apktool.yml)
  tools/               build toolchain (self-contained), NOT in git: restore it locally
    jdk/               Temurin JDK 21
    apktool.jar        apktool 3.0.3
    signer.jar         uber-apk-signer 1.3.0
    signing-key.jks    signing key   (alias + passwords in signing-key.txt)
    signing-key.txt
  build.ps1            one-shot build + sign script
  LP-Companion.apk     the last build; every release is also kept as LP-Companion-<version>.apk
  CHANGELOG.txt        full history of every car change + how to undo each
  TEST-SCENARIO.md     step-by-step test of every feature on the car, with expected results
```

The git repo ignores `*.apk`, `build/`, `source/build/` and `tools/` (see `.gitignore`); attach APKs to a
GitHub Release instead of committing them.

## Build

From inside this folder:

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

Produces `LP-Companion.apk`. Bump `versionCode` / `versionName` in `source/apktool.yml` before a release
build, and copy the result to `LP-Companion-<version>.apk` so it can be rolled back to.

## Install (over Wi-Fi ADB)

```
adb install --no-incremental --install-reason 64 -r LP-Companion.apk
```

`--install-reason 64` is what gets past the head unit's install whitelist (see CHANGELOG for the details of
that check). An update restarts the app's services and closes its open grids: open the grid on the passenger
screen again (`adb shell am start --user 10 --display 3 -f 0x18000000 -n uz.carhelper.passenger/.MainActivity`)
to restart the bubbles.

Going back to an older version: Android refuses an older versionCode over a newer one. Try the same command
with `-d` added, or `adb uninstall uz.carhelper.passenger` first, which wipes the app's settings and PIN (then
redo the grants below).

One-time grants after a fresh install (all survive restarts and `-r` updates):

```
adb shell appops set --user 10 uz.carhelper.passenger SYSTEM_ALERT_WINDOW allow
adb shell cmd notification allow_listener uz.carhelper.passenger/uz.carhelper.passenger.MediaListener 10
adb shell pm grant --user 10 uz.carhelper.passenger android.permission.WRITE_SECURE_SETTINGS
```

With `WRITE_SECURE_SETTINGS` granted the app turns its own Back accessibility service on (and back on
whenever the car drops it after a restart), mirrors child mode to `Settings.Secure`, and can reset the
car's screen-rest state when waking the passenger screen. Settings > Status shows which of the three are
missing.

## Source map (`source/smali/uz/carhelper/passenger/`)

| File | What it does |
|------|--------------|
| `MainActivity.smali`      | The grid (both screens): app tiles, header pills, tiles, now-playing card, wallpaper, child-mode rules, prefs listener (live wallpaper / child-mode sync), PIN prompt when opened by the main bubble's exit button. |
| `SettingsActivity.smali`  | Settings page (see above). Built from card helpers (`section`, `card`, `healthRow`, `navRow`, `appRow`). |
| `BubbleService.smali`     | Passenger-screen bubble + panel, Screen-off cover, overload protection, starts `PassengerWatcher` and `BackRepair`. Static `uncover()` removes the cover. |
| `MainBubbleService.smali` | Main-screen bubble + panel: turn off passenger screen, Back, open grid on main, child button (PIN to leave), move arrows. Static `uncover()`. |
| `NowPlaying.smali`        | The now-playing card (cover tint, progress bar, controls); hidden in child mode. |
| `CloseDialog.smali`       | The "Close apps" popup (rows removed one by one; `dismiss()`). |
| `AutoClose.smali`         | Runnable that closes a bubble panel after the idle time (`which` 0 = passenger, 1 = main). |
| `TileMenu.smali`          | Long-press menu of a grid tile (open on main / passenger, Kids, hide). |
| `Health.smali`, `HealthTick.smali` | RAM / load / temperature readout with the protection thresholds; the 5 s chip updater. |
| `Backup.smali`            | Settings backup to `Settings.Secure`, restore after a reset, adb PIN reset. |
| `apk/*.smali` | The file manager, install warning, delete and uninstall cards; generated from `adbclient/src/.../apk` (do not edit by hand). |
| `Heal.smali`, `HealToast.smali`, `adb/*.smali` | Permission self-repair through the car's own adbd: what is missing, the background thread, the Settings text; `adb/` is generated from `adbclient/` (do not edit by hand). |
| `Lang.smali`, `LangDialog.smali` | Interface language: `Lang.t(english)` lookup in `assets/lang/*.tsv`, the Settings language picker. |
| `Ui.smali`                | Shared look: colours, rounded/pressable backgrounds, glass cards, text and pill helpers, switch/checkbox tints, page gradient. Sizes are px (the displays run at 160 dpi). |
| `Wake.smali`              | Wakes the passenger screen (screensaver DISMISS, screen-rest reset, own cover). |
| `ChildMode.smali`         | Child-mode flag mirror (`sync`, `locked`), `lockedHere`, and the main-screen takeover (`enter`, `takeOver`, `exit`, `openGrid`). |
| `PinDialog.smali`         | Numeric PIN pad: purposes `set`, `exit`, `settings`. |
| `PassengerWatcher.smali`  | Opens the grid on the passenger screen when display 3 turns on (off -> on edge, debounced 2 s; pref `autoOpen`). |
| `Swapper.smali`           | `move(ctx, 0 or 3)` moves an app to the main / passenger screen, `canMove` says whether there is one (button gray otherwise). Off in child mode. |
| `Closer.smali`            | Two-phase close of apps (stop media session, then kill). |
| `BackService.smali`       | Accessibility service; performs the global Back action. Static `instance` tracks whether it is bound. |
| `BackRepair.smali`        | Re-adds `BackService` to `enabled_accessibility_services` (keeping other entries) when it is missing. |
| `BootReceiver.smali`      | After boot (`BOOT_COMPLETED`, an app update `MY_PACKAGE_REPLACED` (restarts things, opens no grid), the car's `com.leapmotor.action.BOOT_COMPLETED` / `com.leapmotoraction.BOOT_COMPLETED`, `QUICKBOOT_POWERON`): marks the sidebar hidden, starts both bubble services and calls `Boot.kick`. |
| `boot/ListenerGrant.smali` | Generated (2.34). Lists `MediaListener` in `enabled_notification_listeners` through WRITE_SECURE_SETTINGS when it is missing (Boot calls it every tick); Heal does the same over adb as a fallback. |
| `boot/Boot.smali`         | Generated from `adbclient/src/.../boot/Boot.java` (2.32). For 3 minutes after a boot signal, every 3 s: re-adds Back, restarts the bubble services if they stopped (display 3 not there yet), and opens the grid on the passenger screen once per boot after display 3 has been on for 20 s (setting `autoOpen`). Log tag `LPBoot`. |
| `MediaListener.smali`     | (called `WheelListener` until 2.34) Notification-listener shell: its grant is what lets `getActiveSessions` work; `onListenerConnected` is a second `Boot.kick` trigger (the system rebinds it after every process start). |
| `WheelReceiver.smali`     | Only its static session helpers are live (`getSessions`, `findTarget`, `isPlaying`, `anyCarPlaying`, `yieldToMusic`), used by `NowPlaying`, `Closer`, `OpenPlayerActivity`. The receiver itself is not registered. |
| `Theme.smali`             | System day/night helper for the PIN pad and wallpaper scrim. |
| `WallpaperFrame.smali`    | Wallpaper root view; `apply(index)` sets 0 = black, 1..11 = `wp_N`. |
| `HideView.smali`, `PanelAction.smali` | Small helpers for the bubble panels (hide/show, delayed Back / reopen steps). |
| `OpenPlayerActivity.smali`| Exported; opens the active/last sideloaded player, else the grid. Written for the old LP Music stand-in; nothing in this app starts it. |
| `MiguBridge`, `MiguCtrlReceiver`, `SteerWheelReceiver`, `KeyDedup`, `WheelGuard` | **Dead code since 2.19** (music control moved to LP Music). Kept in source; nothing registers or calls them. |
| `MainScreenActivity.smali`| **Dead code**: not in the manifest, nothing references it. |

## Preferences (SharedPreferences file `apps`)

`wheel` (unused now), `autoOpen`, `passToMain` (default on), `passFromMain` (default off), `bubbleAuto` (default on), `bubbleSecs` (default 8), `resumeLast` (default on), `healAdb` (default on), `healAt`, `healResult`, `lang` (uz / ru / es / en / zh, unset = automatic), `setup` (marker), `autoClose`, `closeMusic`, `overheat`, `kid`, `pin`, `kidApps` (set),
`hidden` (set), `barHidden`, `running` (set), `lastPassenger`, `onMain`, `wallpaper` (0 = black, 1..11).
The bubble's position is stored in the `bubble` file (`x`, `y`).

## Hooks into the car

| What | Used for |
|------|----------|
| `com.leapmotor.iqiyi.action.nav.visibility` (extra `visibility`: 8 hide, 0 show) | Hide/Show the passenger sidebar. |
| `com.leapmotor.copilotshowapp` | The car's sidebar / launcher package ("Back to car UI"). |
| `com.leapmotor.system.service.DISMISS` | Hides the car's screensaver (Wake). |
| `Settings.Global display_1_state`, `display_2_state` | The car's "screen rest" state (Wake resets them to 0). |
| `Settings.Secure lp_companion_child` | Child-mode flag read by LP Music. |
| Displays | 0 = main 2560x1440, 3 = passenger 1920x720 (SurfaceFlinger id 130; main is 129). |

Debug log tags: `LPCompanion`, `PassengerBubble`, `MainBubble`, `PassengerApps`, `PassengerApps-stop`.
(`LPWheelKeys`, `LPMigu`, `LPWheel` belong to the dead wheel code.)

## Notes

- `source/apktool.yml` keeps `resources.arsc` uncompressed (`doNotCompress: arsc`), required for Android R+.
- There is no Java source: the UI is built in code, so a style change means editing smali. Shared pieces
  live in `Ui`.
- apktool's assembler does not check that a called method or field exists. A call with the wrong return type (it
  happened with `addPill` in 2.25/2.26) only fails on the car as NoSuchMethodError. Run
  `powershell -ExecutionPolicy Bypass -File xref-check.ps1 -Dir source\smali` after every change: it checks every
  reference to the app's own classes against a definition.
- apktool's assembler does not run the verifier. Test every build on the car and watch
  `adb logcat | findstr "AndroidRuntime VerifyError"`. Two rules that bit before: a method that uses `p0`/`p1`
  in ordinary `invoke-*` calls must keep `.locals` at 14 or less (registers above v15 cannot be encoded), and a
  `long` or `double` takes a register pair that must not overlap other live registers.
- Since 2.9 the app re-enables its own Back accessibility service (`BackRepair`), because the car drops it on
  restart and has no Accessibility settings screen. It only appends its own entry and never touches other
  services. Without the `WRITE_SECURE_SETTINGS` grant it can't, and the greyed-out Back button says so.
- Full change history, firmware notes, and the undo steps for everything done to the car are in
  `CHANGELOG.txt`.
- Deliberately **not** in this source: the app is not published under any third-party package name.
