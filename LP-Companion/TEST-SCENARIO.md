# LP Companion 2.34 - test scenario for the car

One pass through everything the app does. Run the whole thing after a release, or only the section you changed.
Every test has an ID, steps, the expected result and how to check it.

- **[adb]**  something the PC can do and read back (Claude can run these for you).
- **[eye]**  something a person has to look at or touch on the car's screens.
- **✔ date**  already verified on the car on that date; **☐** not verified yet; **⚠** touches something live, read the note first.

Texts below are the English names. While the interface language is Uzbek (as it is now) they read:
Settings = *Sozlamalar*, Close apps = *Ilovalarni yopish*, Show bar = *Panelni ko'rsatish*, Child mode = *Bolalar rejimi*,
Change wallpaper = *Fon rasmini almashtirish*, Cancel = *Bekor*, Save = *Saqlash*.

## 0. Rules and setup

**Safety**
1. The car is parked for every [eye] test and for anything in sections 8, 9, 11, 12. Nothing here is meant for driving.
2. The main screen (display 0) is live. [adb] checks there are read-only (screenshots, dumpsys). Taps go to the passenger screen
   (display 3) only, and only after a screenshot confirms what is under the finger.
3. Child mode is never switched on from adb (it locks the passenger screen behind a PIN). Section 9 is by hand only.
4. Switching the car's wireless ADB off (test P-5) cuts the PC's connection too. Switch it back on in the car's backend page.
5. Fix forward, do not roll back: an older versionCode needs an uninstall that wipes the settings and the PIN.

**Shortcuts used below** (PowerShell or Git Bash, from `C:\Users\user\Downloads\platform-tools`)

```bash
A="./adb.exe -s 10.108.162.165:5555"; P=uz.carhelper.passenger
$A shell am start --user 10 --display 3 -f 0x18000000 -n $P/.MainActivity            # open the grid on the passenger screen
$A shell am broadcast --user 10 -a com.leapmotor.system.service.DISMISS               # wake it from the photo screensaver
$A exec-out screencap -d 130 -p > p3.png                                              # passenger screen (display 3)
$A exec-out screencap -d 129 -p > p0.png                                              # main screen (display 0), look only
$A logcat -d -v time -s LPBoot LPCompanion                                           # what the app did, in order
```

**Baseline before you start** (write the answers into the result sheet at the end)

```bash
$A shell dumpsys package $P | grep -E "versionName|versionCode"                      # 2.34 / 42
$A shell dumpsys package $P | grep "WRITE_SECURE_SETTINGS: granted"                   # granted=true
$A shell appops get --user 10 $P SYSTEM_ALERT_WINDOW                                  # allow
$A shell settings get secure enabled_notification_listeners | tr ':' '\n' | grep $P   # ...MediaListener
$A shell settings get secure enabled_accessibility_services | tr ':' '\n' | grep $P   # ...BackService
$A shell dumpsys window windows | grep -c "Window{[^}]*u10 uz.carhelper.passenger}"   # 2 (the two bubbles)
$A shell settings get global display_1_state                                          # 0
$A shell settings get secure lp_companion_child                                       # 0 or empty
```

Quick smoke (10 minutes): I-1, P-1, B-1, G-1, G-2, N-1, BP-1, BM-1, S-1, S-3, S-5, W-1.

## 1. Install and update

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| I-1 ✔ 2026-10-24 | `adb install --no-incremental --install-reason 64 -r LP-Companion-2.34.apk`, then `cmd package compile -m verify -f $P` | `Success` twice; no `VerifyError`, no `FATAL EXCEPTION` for the app in `logcat -b crash` | [adb] |
| I-2 ✔ 2026-10-24 | Right after I-1 touch nothing for 15 s | Log: `kick by android.intent.action.MY_PACKAGE_REPLACED (open=false)` and `kick by listener`, then both bubbles are back; the grid is NOT opened by itself | [adb] `logcat -d -s LPBoot`; window count = 2 |
| I-3 ✔ 2026-10-24 | Install the same APK again (same versionCode) | `Success`, nothing written twice, no crash | [adb] |
| I-4 ☐ | After an update, check the grid, bubbles and now-playing card are all normal | Same as before the update; settings and PIN unchanged | [eye] |

## 2. Permissions and self-repair (`Heal`, `BackRepair`, `ListenerGrant`)

Remove / restore commands (user 10):

```bash
$A shell cmd notification disallow_listener $P/$P.MediaListener 10
$A shell appops set --user 10 $P SYSTEM_ALERT_WINDOW deny
$A shell pm revoke --user 10 $P android.permission.WRITE_SECURE_SETTINGS
# by hand, if the app does not heal itself:
$A shell pm grant --user 10 $P android.permission.WRITE_SECURE_SETTINGS
$A shell appops set --user 10 $P SYSTEM_ALERT_WINDOW allow
$A shell cmd notification allow_listener $P/$P.MediaListener 10
```

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| P-1 ✔ 2026-10-24 | Remove all three, `am force-stop $P`, then send the boot broadcast: `am broadcast --user 10 --include-stopped-packages -a com.leapmotor.action.BOOT_COMPLETED -n $P/.BootReceiver` | Within seconds: log `adb self-grant: OK|pm grant ...; appops set ...; cmd notification allow_listener ...`; all three are back; no "Allow USB debugging?" box on the main screen; bubbles up; Back entry listed | [adb] baseline block; [eye] main screen has no dialog |
| P-2 ✔ 2026-10-24 | Remove only the overlay (`appops ... deny`), open Settings > Status | The "Bubble (overlay)" row is red with the adb command under it; bubbles are hidden; tap "Fix permissions now" | row turns green, bubbles return |
| P-3 ✔ 2026-10-24 | In Settings turn OFF "Fix missing permissions automatically using the car's own ADB", Save, remove WRITE_SECURE_SETTINGS, force-stop, send the boot broadcast | NOTHING is repaired by itself (log has no `adb self-grant`); Settings > Status shows red; "Fix permissions now" still repairs it. Turn the switch back ON afterwards | [adb] + [eye] |
| P-4 ✔ 2026-10-24 | Take only the Back entry out: `$A shell settings put secure enabled_accessibility_services com.aispeech.lyra.daemon/com.aispeech.unit.smartapp.model.AccessibilityActionService` | Within 60 s (10 s during the first 2 minutes after the service started) the app puts `uz.carhelper.passenger/uz.carhelper.passenger.BackService` back and keeps the aispeech entry; log `Back accessibility service re-enabled`. A force-stop (P-1) drops the entry the same way and the same code restored it. ⚠ it briefly changes the car's accessibility list, nothing else | [adb] |
| P-5 ⚠ ☐ (2.36: greyed button + auto-unlock not yet seen on the car) | First remove the overlay (`appops ... deny`) so something needs repair, open Settings on the passenger screen and scroll to "Fix permissions now". **You**: in the car's backend page switch wireless ADB OFF, then tap "Fix permissions now" | The app only tries to switch ADB on when it has something to repair (or before an install or uninstall). 2.35 expected: the toast says it keeps trying for about 2 minutes; the backend switch closes the port but leaves adb_enabled at 1 (log `adb_enabled is on but nothing listens`), so the app cannot reopen it; switch ADB on inside the 2 minutes and within ~10 s the log shows `adb self-grant: OK|appops ... allow`, the bubbles return and the Settings page turns green by itself. If it cannot (the toggle in the backend page may not be Settings.Global adb_enabled), nothing is repaired and ADB stays off until you switch it on; then repair by hand | [eye]; PC reconnects |
| P-6 ✔ 2026-10-24 | Settings > Status > "Re-check status" | The page reopens; all rows green (overlay, notification access, WRITE_SECURE_SETTINGS, Back) | [eye] |
| P-7 ⚠ ☐ | **A key the car has never seen**: do R-2 (`pm clear` deletes the app's adb key), then repeat P-1 | The app makes a new key; the car's adbd may show "Allow USB debugging?" on the MAIN screen. **You** choose "Always allow" (parked). The log then says `adb self-grant: OK|...` (or `AUTH|...` if nobody accepted in 90 s) | [eye] + [adb] |

## 3. Restart and deep sleep (`BootReceiver`, `Boot`)

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| B-1 ✔ 2026-10-24 | Send the car's own boot broadcast (P-1 command, without removing anything) while the passenger screen is on | Log `kick by com.leapmotor.action.BOOT_COMPLETED (open=true)`; ~27 s later `opening the grid on the passenger screen` exactly once; then `done` | [adb] `logcat -d -s LPBoot`; screenshot of display 3 |
| B-2 ✔ 2026-10-24 | Repeat B-1 with Settings > "Open LP Companion automatically when the passenger screen turns on" OFF | The log never says `opening the grid`; bubbles and Back are still restored | [adb] |
| B-3 ✔ 2026-10-24 | Repeat B-1 and, during the first 20 s, send the same broadcast twice more | One boot: one grid opening only | [adb] log has one `opening the grid` |
| B-4 ☐ | Only if it happens in B-5: the passenger display is really off (the car's screen rest, nobody in the seat) | No grid is forced while it is off; when it wakes the existing wake logic opens the grid, or the last app if "return to the app that was open" is on. (The bubble's "Screen off" is only a black cover, the display stays on, so it does not count) | [eye] |
| B-5 ✔ 2026-10-24 (menu restart; deep sleep not yet) | **Real restart**: restart the head unit from the car's menu (or leave the car until it deep-sleeps and wakes) | `logcat -d -s LPBoot` shows WHICH broadcast the car sent (`BOOT_COMPLETED`, `com.leapmotor.action...`, `QUICKBOOT_POWERON`...); both bubbles appear; the Back entry is back; ~20 s after the passenger screen is on the grid opens once; permissions are intact or healed (see `adb self-grant`) | [adb] + [eye] |
| B-6 ✔ 2026-10-24 | After B-5 note when the passenger display did not yet exist: log shows `started BubbleService` several seconds after the kick, not at once | The bubble is created as soon as display 3 exists (up to 6 tries) | [adb] |

## 4. Grid (`MainActivity`)

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| G-1 ✔ 2026-10-24 | Open the grid on the passenger screen (shortcut above), wake it with DISMISS | Title "LP Companion", header pills (Settings, Close apps, Show/Hide bar), now-playing card (when something plays), tiles Child mode and Change wallpaper, then the app tiles, 5 per row | [eye] / screenshot |
| G-2 ✔ 2026-10-24 | Tap an app tile (use one you do not mind, e.g. Telegram) | The app opens on the passenger screen (display 3), the screen is woken if it was resting | [adb] `dumpsys activity activities` shows it on display 3 |
| G-3 ✔ 2026-10-24 | Long-press an app tile | Menu: Open on the main screen / Open on the passenger screen / Add to Kids (or Remove) / Hide from the grid | [eye] |
| G-4 ✔ 2026-10-24 | In that menu: Hide from the grid, then Settings > app checklist | The tile disappears from the grid; its "shown on the grid" tick is off; ticking it brings the tile back | [eye] |
| G-5 ✔ 2026-10-24 | Tap Change wallpaper five times | The background cycles; the same change appears on the main-screen grid within a second | [eye] both screens |
| G-6 ☐ | Open the grid on the main screen (main bubble > LP Companion) | It lists every app, even ones hidden or filtered on the passenger screen | [eye] |
| G-7 ✔ 2026-10-24 | Tap Hide bar / Show bar | The car's passenger sidebar hides / shows; the pill text flips | [eye] |
| G-8 ✔ 2026-10-24 | With Settings > Protection > "Show the RAM and temperature status on the grid" ON, open the grid; OFF, open it again | ON: chip `RAM nn% · temp OK` (no degrees: this car has no temperature value); OFF: no chip | [eye] screenshot |

## 5. Now-playing card (`NowPlaying`, needs `MediaListener`)

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| N-1 ✔ 2026-10-24 | Play something (Yandex Music / LP Music) and open the grid | Card with cover, title, artist, progress bar, prev / pause / next; tinted by the cover | [eye] screenshot |
| N-2 ✔ 2026-10-24 | Tap pause, then play, then next, then previous | The player obeys; the card follows | [eye] |
| N-3 ✔ 2026-10-24 | Tap the cover or the title | The playing app opens on the passenger screen | [eye] |
| N-4 ☐ | Stop playback | The card disappears | [eye] |
| N-5 ✔ 2026-10-24 | Remove only the notification access (`disallow_listener`), open the grid, play something | The card cannot read the player (gone or empty), no crash in the log; after the repair (P-1) it is back with the track | [adb] + [eye] |

## 6. Bubbles

Passenger bubble (display 3): Screen off (top row); Back, Home (= the LP grid), Hide/Show bar; the move arrows at the bottom.
Main bubble (display 0): Turn off passenger screen (top); Back, LP Companion, child button; two move arrows.

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| BP-1 ✔ 2026-10-24 | Look at display 3 | The bubble is visible at its saved place | screenshot |
| BP-2 ✔ 2026-10-24 | Drag the bubble to another corner, then restart the services (I-2 or B-1) | It comes back where you left it | [eye] |
| BP-3 ✔ 2026-10-24 | Tap the bubble | The panel opens; it closes by itself after the Settings value (default 8 s), and a tap inside re-arms the timer; tapping outside closes it at once | [eye] |
| BP-4 ✔ 2026-10-24 | Panel > Back (inside an app that has a back step) | The app goes back one screen | [eye] |
| BP-5 ✔ 2026-10-24 | Panel > Home | The LP grid opens on display 3 | [eye] |
| BP-6 ✔ 2026-10-24 | Panel > Screen off, then tap the black cover | Screen goes black, the tap restores it | [eye] |
| BP-7 ☐ | Run the P-4 command, then open the panel before the repair puts the entry back | While the Back service is off the panel has no Back button and the others shift left; once it is back the button returns | [eye] |
| BM-1 ✔ 2026-10-24 | Look at display 0 | The main bubble is at its place | screenshot |
| BM-2 ☐ | Main bubble > LP Companion | The grid opens on the main screen | [eye] ⚠ live screen |
| BM-3 ☐ | Main bubble > Turn off passenger screen | The passenger screen goes black | [eye] |

## 7. Moving apps between the screens (`Swapper`)

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| M-1 ✔ 2026-10-24 (passenger -> main, Opera Mini; layout identical to a fresh launch) | Open an app on the passenger screen from the grid; passenger bubble > "<-" (needs Settings > "Passenger bubble: push its app to the main screen ←" ON, the default) | The app moves to the main screen and the passenger screen shows the LP grid | [eye] + `dumpsys activity` |
| M-2 ✔ 2026-10-24 (main -> passenger moves the app LP recorded as onMain) | Main bubble > "->" | The main-screen app goes to the passenger screen; the main screen shows the car's Home | [eye] |
| M-3 ☐ | Press a move arrow when there is nothing to move | The arrow is grey; a tap says why | [eye] |
| M-4 ☐ | Move Yandex Music Lite across and back twice | Never open on both screens at once (the old bug) | [adb] `dumpsys activity activities` one task |
| M-5 ☐ | Settings > turn "Passenger bubble: bring the main screen's app over →" ON | A "->" arrow appears on the passenger bubble | [eye] |
| M-6 ✔ 2026-10-24 (2.39, switch ON; Yandex Music moved by the user, log `flg=0x10008000` toward display 0, screenshot shows the app between the bars) | Settings > Passenger screen > "Restart an app when it is moved to the main screen" ON; open an app on the passenger screen first, then move it to the main screen | The app starts again on the main screen (first screen), its content sits between the car's top and bottom bars; a move back to the passenger screen is the plain move (`flg=0x10200000`) | [eye] + `logcat` `LPSysUI.START ... flg=0x10008000` + `dumpsys activity top` client InsetsState `(0,0-2560,1440)` with STATUS_BAR and NAVIGATION_BAR |
| M-7 ☐ | Same switch OFF | Move behaves as before 2.39 (`flg=0x10200000`; apps that were created on the passenger screen may draw under the bars) | [adb] logcat |
| M-8 ☐ | Switch ON, move Opera Mini passenger -> main, then main -> passenger, then -> main again | Opera is never closed by a move (a second CLEAR_TASK on an already moved Opera closed it in the 2.38 test) | [eye] + `dumpsys activity activities` |

## 8. Settings (`SettingsActivity`) ⚠ Save writes everything: change one thing at a time and put it back

Open it from the grid pill (Settings). Changes are held until Save; Cancel leaves without saving.

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| S-1 ✔ 2026-10-24 | Open Settings and scroll down and up | The title with Cancel / Save stays fixed at the top; only the page scrolls under it | [eye] screenshots |
| S-2 ✔ 2026-10-24 | Language row > pick Russian, then Spanish, Chinese, English, back to Uzbek | Each switch rebuilds Settings and the grid in that language; texts without a translation stay English | [eye] |
| S-3 ✔ 2026-10-24 | Bubble menu card: tap "+" and "−" | Steps 3 / 5 / 8 / 10 / 15 s; "−" greys out at 3, "+" at 15; turning the auto-close switch off dims all three (seen). The panel closed within 8 s with 5 s set (not timed to the second) | [eye] stopwatch |
| S-4 ✔ 2026-10-24 | Cancel after changing something | Nothing is saved (reopen to see the old values) | [eye] |
| S-5 ✔ 2026-10-24 | Protection card: the status switch ON, Save, open the grid; then OFF, Save | Chip appears / disappears; the grid rebuilds itself; the "Right now: RAM nn% · temp OK · n GB free · OK" line is always there | [eye] |
| S-6 ☐ | Passenger screen card: toggle "Open LP Companion automatically when the passenger screen turns on", "When it turns on, go back to the app that was open", "push its app to the main screen ←", "bring the main screen's app over →" | Each is saved (reopen); behaviours checked in B-2, W-2, M-1, M-5 | [eye] |
| S-7 ☐ | Closing apps card: "close previous app when another opens" + "also close music" | Opening app B from the grid closes app A (and a music app only if the second switch is on) | [eye] + `dumpsys` |
| S-8 ☐ | App checklist: untick one app / tick Kids on another, Save | Hidden from the passenger grid; Kids is used in child mode (section 9) | [eye] |
| S-9 ☐ | Vehicle card: Vehicle settings, Back to car UI | Each opens the car's own screen and returns | [eye] ⚠ live screen |
| S-10 ✔ 2026-10-24 | Status card rows | Overlay, notification access, "Self-repair after restart" (WRITE_SECURE_SETTINGS) and Back show green OK | [eye] |

## 9. Child mode ⚠ by hand only, never from adb

Needs a PIN. Use a PIN you will remember; forgot it: `$A shell settings put secure lp_companion_pin_reset 1`, then open LP Companion
(clears the PIN and turns child mode off, everything else stays).

| ID | Steps | Expected |
|----|-------|----------|
| K-1 ☐ | Settings > Child mode > Set password (numeric pad, no system keyboard) | PIN stored; "Child mode" tile now works |
| K-2 ☐ | Tick Kids on two apps (Settings), Save. On the passenger grid tap the Child mode tile | The passenger grid shows only those two apps; Close apps is hidden; the now-playing card is hidden; moving apps is off; the tile menu has no "Open on the main screen" |
| K-3 ☐ | Open the Settings pill in child mode | It asks for the PIN first; a wrong PIN leaves, the right one opens |
| K-4 ☐ | Enter child mode from the main bubble's child button while an app is running on the passenger screen | A Kids app is left running; any other app there is closed and the filtered grid opens |
| K-5 ☐ | Leave: "Exit child mode" tile (or the main bubble's child button) | Asks the PIN on the numeric pad; right PIN: the full grid returns on its own on both screens |
| K-6 ☐ | `settings get secure lp_companion_child` while in and out of child mode | `1` in, `0` out (LP Music reads this) |
| K-7 ☐ | Restart the services (B-1) while in child mode | Child mode stays on; the boot grid is the filtered one |

## 10. Wake and screensaver (`Wake`)

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| W-1 ✔ 2026-10-23 (2.20) | Wait ~3 min until the car's photo screensaver covers display 3 (screenshot shows a photo), then open an app from the grid | The screensaver is dismissed and the app is visible | [eye] / screenshot |
| W-2 ☐ | Open an app on the passenger screen, let the screen turn off / rest, wake it by touch | With "return to the app that was open" ON the same app comes back (not the grid); OFF: the grid | [eye] |
| W-3 ☐ | Screen rest: if the passenger screen stays black after waking, run `settings put global display_1_state 0` and the same for `display_2_state` | Screen returns (the app's own wake path for this state is not verified on the car) | [adb] |

## 11. Overload protection (`overheat` switch, off right now)

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| O-1 ☐ | Settings > Protection > turn "Overload protection" ON, Save. Open a few apps on the passenger screen | Nothing happens while RAM / CPU are fine; the "Right now" line shows the numbers | [eye] |
| O-2 ⚠ ☐ optional | Parked, 2 minutes at most: raise the load with `$A shell 'for i in 1 2 3 4 5 6 7 8 9 10; do (yes >/dev/null &); done'`; after ~90 s expect passenger apps closed + a red warning; then `$A shell pkill yes` | Closing happens at most once per 2 minutes; the warning names RAM / load; afterwards everything is normal. Turn the switch back OFF if you do not want it | [adb] `ps -A | grep yes` empty afterwards |

## 12. Install and uninstall apps from storage (`apk` package) ⚠

Settings > Vehicle. Needs wireless ADB and the "All files access" grant (Grant button on the page).

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| F-1 ☐ | Put a small harmless APK in `/sdcard` (`$A push test.apk /sdcard/Download/`) and open "Install apps from storage" | You can browse folders and `.apk` files; bundles are greyed; `Android` and dot-folders are not shown | [eye] |
| F-2 ☐ | Tap the APK | A card shows what it is (new / update), permissions, signature; the Install button is locked for 10 s; "Grant all permissions (-g)" is off | [eye] |
| F-3 ☐ | Install it | Progress, then done; the app appears in the grid | [adb] `pm list packages` |
| F-4 ☐ | "Uninstall apps" | Lists only apps installed this way; confirm card with a 10 s lock; removal works | [eye] + `pm list packages` |
| F-5 ☐ | Delete button on an APK file | Warning first; the file is removed | [adb] `ls /sdcard/Download` |
| F-6 ☐ | P-5 (ADB off) | Both rows are greyed with "needs ADB"; a tap explains how to switch it on | [eye] |

## 13. Backup and recovery (`Backup`)

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| R-1 ☐ | Change one setting (for example the bubble timer to 10 s), Save, then `$A shell settings get secure lp_companion_backup` | A JSON string with `bubbleSecs` and `showStatus` among the values | [adb] |
| R-2 ⚠ ☐ | `$A shell pm clear --user 10 $P`, then open the grid | Settings come back from the backup (not the PIN, child mode, running apps); the permissions stay granted (a clear does not revoke them). It also deletes the app's adb key, see P-7 | [adb] + [eye] |
| R-3 ☐ | PIN reset command (section 9) with a PIN set | PIN cleared, child mode off, everything else unchanged | [adb] |

## 14. Other apps that depend on LP Companion

| ID | Steps | Expected | Check |
|----|-------|----------|-------|
| X-1 ☐ | LP Music (`com.migu.car.music`) plays a track | The now-playing card in LP Companion shows it (N-1) | [eye] |
| X-2 ☐ | Child mode on (K-2) | LP Music locks itself too (it follows `lp_companion_child`) | [eye] |
| X-3 ☐ | LP Music's own notification access is separate (`com.migu.car.music/uz.carhelper.passenger.WheelListener`); removing LP Companion's never touches it | Both listeners are listed in `settings get secure enabled_notification_listeners` | [adb] |

## 15. Known limits (not bugs)

- No temperature value exists for apps on this car (no thermal zones, no battery, the thermal HAL reports one fixed 30.8 °C
  "test" sensor), so the chip says `temp OK`, never degrees.
- A real restart has not been tried yet (B-5), nor a new key meeting the car's adbd ("Allow USB debugging?" path, P-7), nor
  wireless ADB being off (P-5). The key the app has now is already trusted by the car, which is why P-1 showed no prompt.
- The system keeps a stale `...WheelListener` notification entry for LP Companion; it is inert.
  Remove with `adb shell cmd notification disallow_listener uz.carhelper.passenger/uz.carhelper.passenger.WheelListener 10`.
- Apps draw their own insets; Yandex Music's "В авто" player draws under the car's top and bottom bars.
  YouTube ReVanced and ContraCam ask for edge-to-edge themselves, so even a fresh start does not help (only a patch of the app).
- A window moved from the passenger screen to the main screen keeps the passenger display's InsetsState (no bars). Settings >
  "Restart an app when it is moved to the main screen" (2.39, default off) starts such an app again instead (M-6).

## Run log 2026-10-24 (version 2.34, adb-only run, passenger screen only)

Ran from the PC with taps on display 3 only. Passed: I-3, P-1, P-2, P-3, P-4, P-6, B-1, B-2, B-3, G-1, G-2, G-3, G-4, G-5, G-7,
G-8, N-1, N-2, N-3, N-5, BP-1 to BP-6, BM-1, S-1 to S-5, S-8 (tick part), S-10, R-1, X-3. Nothing crashed (`logcat -b crash`
clean); every setting I changed was put back (autoOpen, healAdb, bubble timer, wallpaper, hidden list, language English).

What the run showed that the plan did not say:
- **The grid start repairs permissions too.** With auto-repair ON, removing only the overlay and then opening the grid
  (`am start ... MainActivity`) restored the overlay within 5 s (log `adb self-grant: OK|appops ... allow`). To see the red
  Status row you must first switch auto-repair OFF (P-3 setup), which is what P-2 now does.
- **With auto-repair OFF** the Status rows go red (Bubble overlay: OFF + the adb command; Back button: "Needs the
  self-repair permission above") and "Fix permissions now" repairs by hand: it granted WRITE_SECURE_SETTINGS and the Back
  entry came back in the same second. "Re-check status" then shows all green.
- **No grid when "open automatically" is OFF** (B-2) and **one grid for three boot broadcasts** (B-3: 25 s after the first).
- **Back entry restored in about 6 s** after it was removed from the accessibility list (P-4), the aispeech entry untouched.
- **Position kept** (BP-2): dragging the passenger bubble, force-stop + boot broadcast, it came back at the new place.
- **Screen off** (BP-6): the cover is a full-screen overlay window (seen in `dumpsys window`); screenshots of it fail, because
  the window is secure, so check it with `dumpsys`, not `screencap`. A tap removes it.
- **Show bar** (G-7): the car's sidebar overlays the right ~160 px of the grid and half-covers the third header pill. The part
  of the pill that shows still works (tap near x 1700). A tap at x 1767 hits the sidebar's Home button, which opens the car's
  own passenger home (I did that once by mistake; "Back" from the bubble or the grid shortcut returns).
- **Language** (S-2): Russian, Chinese and Spanish switch at once, Settings and grid included; English restored.
- Minor, not fixed: with WRITE_SECURE_SETTINGS missing the log gets `cannot re-enable Back` every 3 s for the 3 minutes of the
  boot loop (about 60 lines). Harmless, but noisy.

**Real restart, 2026-10-24 16:41 (restart from the car menu, B-5 / B-6).** What the car really sends, from `logcat -d -s LPBoot`:
- uptime 12 s: `kick by listener (open=true)`. The notification listener (MediaListener) bound by itself first, which is the second
  trigger added in 2.32 doing its job.
- uptime 21 s: `kick by com.leapmotor.action.BOOT_COMPLETED (open=true)`. The car's own action arrives 9 s later. The standard
  `android.intent.action.BOOT_COMPLETED` follows at uptime 49 s (the first read of the log was too early to see it); the QUICKBOOT actions did not arrive.
- 5 s after the first kick (display 3 was there): Back entry re-enabled, `started BubbleService`, `started MainBubbleService`.
- uptime ~38 s: `opening the grid on the passenger screen`, once, then `done (opened=true)`. The grid, the bubbles (saved place) and the
  now-playing card (the player had resumed by itself) were on the passenger screen; no crash; permissions, listener and Back entry intact, so no
  `adb self-grant` was needed this time.
- The car's clock was 01-01 05:00 at boot and was corrected to the real time about 40 s later, so log lines straddle two dates:
  read the log without a date filter. The loop itself uses uptime, not the wall clock, so it is not affected.
- Not covered: a restart by deep sleep (the car may send different broadcasts), a firmware update (permissions may be lost).

**Move test on the main screen, 2026-10-24 (Opera Mini, then YouTube ReVanced read-only).** Question: does moving an app from the
passenger screen to the main one make it ignore the car's top bar (120 px) and bottom bar (144 px)?
- The bars are real insets on display 0: `ITYPE_STATUS_BAR [0,0][2560,120]` and `ITYPE_NAVIGATION_BAR [0,1296][2560,1440]`, provided by the
  car's `LeapMotor{Top,Bottom}{UI,Logic}CarSystemBar` windows (display 3 has none). `dumpsys window displays` shows them.
- Opera Mini, fresh launch on main vs moved passenger -> main through the bubble (same task, one task only): window flags
  (`vsysui=LAYOUT_STABLE`, `FIT_INSETS_CONTROLLED`), frames, given insets and appBounds (0,0 - 2560,1296) are IDENTICAL, and the pictures
  look the same (content between the bars, only the labels of Opera's own bottom toolbar clipped by the blurred bottom bar both times).
  So the move itself does not break the layout of an app that respects insets.
- YouTube ReVanced on main: its window asks for `LAYOUT_FULLSCREEN | LAYOUT_HIDE_NAVIGATION | IMMERSIVE_STICKY` and is the control target of
  the status / navigation bars, frame = whole 2560x1440, given insets 0. It draws its header and bottom content under the bars. That is the
  app's own request, so relaunching or re-laying it out gives the same result.
- LP's "main -> passenger" arrow moves the app LP has recorded as `onMain` (it moved YouTube when Opera was the one on screen: Opera had
  been started with `am start`, which LP does not record). Open apps through the LP grid / bubble for the arrows to know them.
- No freeform windows (no `android.software.freeform_window_management`), so an app cannot be boxed between the bars; shrinking the display
  would shrink the car's own screens. The fix for an edge-to-edge app is a patch of that app (as for Yandex Music Lite).
- Left the screens as they were: Opera Mini force-stopped, main = car home, passenger = LP grid (YouTube's task now sits behind it on the passenger screen).

**Why moved apps ignore the bars (found 2026-10-24, Opera Mini opened on the passenger screen first, then moved to main).**
- Window flags, frames, configuration (h1176dp, appBounds 2560x1296) of the moved window are identical to a fresh launch on main. What differs is
  the app's own copy of the insets (`dumpsys activity top`, section of the activity, `InsetsController` / `InsetsState`):
  moved passenger -> main: `mDisplayFrame=(0,0 - 1920,720)` and ONLY `ITYPE_IME` (no status bar, no navigation bar) = the passenger display's state;
  fresh on main: `mDisplayFrame=(0,0 - 2560,1440)` plus `ITYPE_STATUS_BAR [0,0][2560,120]` and `ITYPE_NAVIGATION_BAR [0,1296][2560,1440]`.
  Android 12 on this car does not send the new display's insets to a window that was moved; the app keeps the old ones and lays out edge to edge
  under the car's bars. The reverse (main -> passenger) keeps the main insets, i.e. empty 120 / 144 px bands on the passenger screen.
- Home + reopen (stop/start) does NOT refresh it; showing the keyboard did not either. Only a NEW window does: relaunching with
  `NEW_TASK | CLEAR_TASK` (0x10008000) on the target display gave Opera the full state (one task, bars respected). The cost is that the app
  restarts from its first screen.
- A second, separate cause: apps that ask for edge-to-edge themselves (YouTube ReVanced: LAYOUT_FULLSCREEN | LAYOUT_HIDE_NAVIGATION |
  IMMERSIVE_STICKY; ContraCam: LAYOUT_FULLSCREEN). A restart does not help those; only a patch of the app does.
- Yandex Navigator (24.5.1, targetSdk 35, built edge to edge) was not running during the checks: not examined; it very likely shows the first cause.

Not run in the first part, and why: M-1 to M-5, BM-2, BM-3 and G-6 put an app or the grid on the main screen (live), K-1 to K-7 are child mode
(by hand only), S-6/S-7/S-9 partly (S-9 opens the car's own screens), W-2 and W-3, O-1 and O-2, F-1 to F-6 (need an APK on
the car), R-2 and R-3, X-1 and X-2, and the three that need you: B-5 / B-6 (real restart), P-5 / F-6 (wireless ADB off),
P-7 (a key the car has not seen).


## Result sheet

| Date | Version | Tester | Passed | Failed (IDs) | Notes |
|------|---------|--------|--------|--------------|-------|
|      |         |        |        |              |       |
