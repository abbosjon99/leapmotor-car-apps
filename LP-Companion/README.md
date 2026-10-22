# LP Companion

Companion app for a Leapmotor C01 (2025) head unit (Android 12). Launches sideloaded
apps on the passenger screen (display 3), a draggable AssistiveTouch-style bubble with
Home / Back / Open player / Screen-off / sidebar toggle, a settings page, and a
"now playing" bridge so the steering-wheel media buttons control sideloaded players.

Package: `uz.carhelper.passenger`  ·  current version: 2.13

## Folder layout

```
LP-Companion-project/
  source/              apktool project (smali, AndroidManifest.xml, res/, apktool.yml)
  tools/               bundled build toolchain (self-contained)
    jdk/               Temurin JDK 21
    apktool.jar        apktool 3.0.3
    signer.jar         uber-apk-signer 1.3.0
    signing-key.jks    signing key   (alias + passwords in signing-key.txt)
    signing-key.txt
  build.ps1            one-shot build + sign script
  LP-Companion-2.8.apk the last build
  CHANGELOG.txt        full history of every car change + how to undo each
```

## Build

From inside this folder:

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

Produces `LP-Companion.apk`. Bump `versionCode` / `versionName` in `source/apktool.yml`
before a release build.

## Install (over Wi-Fi ADB)

```
adb install --no-incremental --install-reason 64 -r LP-Companion.apk
```

`--install-reason 64` is what gets past the head unit's install whitelist
(see CHANGELOG for the details of that check).

One-time grants after a fresh install (all survive restarts and `-r` updates):

```
adb shell appops set --user 10 uz.carhelper.passenger SYSTEM_ALERT_WINDOW allow
adb shell cmd notification allow_listener uz.carhelper.passenger/uz.carhelper.passenger.WheelListener 10
adb shell pm grant --user 10 uz.carhelper.passenger android.permission.WRITE_SECURE_SETTINGS
```

With `WRITE_SECURE_SETTINGS` granted the app turns its own Back accessibility service on
(and back on whenever the car drops it after a restart), so no accessibility command is needed.

## Source map (`source/smali/uz/carhelper/passenger/`)

| File | What it does |
|------|--------------|
| `MainActivity.smali`      | Grid of sideloaded apps; header pills (Settings / Close apps / bar toggle). |
| `SettingsActivity.smali`  | Settings page: Status (grants, green/red + ADB fix), wheel, auto-close, close-music, overheat, kid mode + PIN, app checklist with "Kids" ticks. Changes held until Save; PIN asked first while kid mode is on. |
| `BubbleService.smali`     | Floating bubble + panel on the passenger screen (Home / Back / Open app / Screen-off / Swap / bar toggle). |
| `Swapper.smali`           | Bubble's Swap: moves the last grid-opened passenger app to the main screen and back. Off in kid mode. |
| `PanelAction.smali`       | Runnable for the bubble panel's delayed steps (press Back, reopen panel). |
| `BackService.smali`       | Accessibility service; performs the global Back action. Static `instance` tracks whether it's bound. |
| `BackRepair.smali`        | Re-adds BackService to `enabled_accessibility_services` (keeping the other entries) when it's missing; needs the `WRITE_SECURE_SETTINGS` grant. |
| `OpenPlayerActivity.smali`| Opens the active/last sideloaded player, else the grid. |
| `Closer.smali`            | Two-phase close of apps on the passenger screen (stop media session, then kill). |
| `HideView.smali`          | Helper view for hide/show of the bubble. |
| `MiguBridge.smali`        | Announces the active sideloaded player to the car as media type 13 so the wheel buttons route to it. |
| `MiguCtrlReceiver.smali`  | Receives the car's media/voice control broadcasts (type 13) and forwards to the active player's transport controls. |
| `SteerWheelReceiver.smali` | Second wheel-key channel: `com.leapmotor.steerwheelcontrol.media` (action 1/4/7), registered by BubbleService while it runs. |
| `KeyDedup.smali`          | Shared 350 ms de-dup for the METER.CTRL ("meter") and steerwheelcontrol ("steer") channels; logs every decision under tag `LPWheelKeys`. |
| `WheelReceiver/Listener/Guard.smali` | Earlier steering-wheel path, not registered any more; its session helpers (`getSessions`, `findTarget`, `isPlaying`, `anyCarPlaying`) are still used. |
| `BootReceiver.smali`      | Starts the bubble service after boot. |

## Notes

- `source/apktool.yml` keeps `resources.arsc` uncompressed (`doNotCompress: arsc`) — required for Android R+.
- Full change history, firmware notes, and the undo steps for everything done to the car
  are in `CHANGELOG.txt`.
- Since 2.9 the app re-enables its own Back accessibility service (`BackRepair`), because
  the car drops it on restart and has no Accessibility settings screen. It only appends its
  own entry and never touches other services. Without the `WRITE_SECURE_SETTINGS` grant it
  can't, and the greyed-out Back button says so.
- Deliberately **not** in this source: the app is not published under any third-party package name.
