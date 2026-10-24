# Leapmotor C01 car apps

Two companion apps for a Leapmotor C01 (2025) head unit (Snapdragon 8155, Android 12, the car runs
Android user 10), built by decompiling/patching with apktool and signing with a local key.

| App | Package | Version | Folder |
|-----|---------|---------|--------|
| **LP Companion** | `uz.carhelper.passenger` | 2.39 (versionCode 47) | [LP-Companion](LP-Companion/) |
| **LP Music** | `com.migu.car.music` | p1.0 (versionCode 37, the build that was 2.28) | [LP-Music](LP-Music/) |

Both are installed on the car. The signed APKs are attached to the
[Releases](../../releases) of this repository (they are not in git).

## Projects
- **[LP-Companion](LP-Companion/)** — launcher for sideloaded apps on the passenger screen (display 3) and
  the main screen: app grid, floating AssistiveTouch-style bubbles on both screens (Home / Back / Screen off /
  bar toggle / move an app to the other screen), now-playing card, Settings page, PIN-protected child mode,
  overload protection, five interface languages (uz, ru, es, en, zh).
  - Starts by itself after the car restarts or wakes (`Boot`), and **repairs its own permissions** through
    the car's own Wi-Fi ADB (`127.0.0.1:5555`, three allow-listed grant commands only). With the car's ADB off
    the repair button is greyed with a hint and unlocks by itself when ADB comes back.
  - Built-in installer / uninstaller for APKs on storage or USB (streamed through the same on-device ADB).
  - **Move apps between the screens** (since 2.23). An app that was opened on the passenger screen and then moved to
    the main screen keeps the passenger display's window insets and draws under the car's top and bottom bars;
    Settings > "Restart an app when it is moved to the main screen" (2.39, off by default) starts it again so it
    gets the right ones. Details and the cause are in `LP-Companion/README.md`.
  - `LP-Companion/TEST-SCENARIO.md` is the checklist used to test it on the car, with run logs.
- **[LP-Music](LP-Music/)** — a media companion that does what the car's own NetEase and Migu apps do: it
  announces the playing sideloaded player (Yandex Music, ...) to the car as media type 13 (title, artist, cover,
  play state), so the dock card, the cluster and the voice assistant show it, and takes the steering-wheel, dock
  button and voice commands back. It has its own home screen with a now-playing widget and a Settings page, and,
  when DiPlay is installed, a switch to hand the wheel buttons to DiPlay while CarPlay is playing.
  How the car does this, and why, is in [LP-Music/FINDINGS.md](LP-Music/FINDINGS.md).

## Credit
- **DiPlay (wireless CarPlay)** — not included here. Credit to
  [DiPlay-Leapmotor](https://github.com/Wh1t3co1azZ/DiPlay-Leapmotor) by Wh1t3co1azZ, a fork of
  [DiPlay](https://github.com/shihabal3amri/DiPlay) (GPL-3.0). LP Music can yield the steering-wheel
  keys to it while it is playing (toggle in LP Music's settings).

## Install (over Wi-Fi ADB)
Download the APKs from the Releases page, then:
```
adb install --no-incremental --install-reason 64 -r LP-Companion-2.39.apk
adb install --user 10 --no-incremental --install-reason 64 -r LP-Music-p1.0.apk
```
`--install-reason 64` makes the car's installer skip its app whitelist. LP Companion's three permissions
(draw over other apps, notification access, `WRITE_SECURE_SETTINGS`) and LP Music's notification access are
granted with the commands in each app's README; after the first grant LP Companion restores its own by itself.
The full change history is in `LP-Companion/CHANGELOG.txt`.

## Build
Restore a `tools/` folder under `LP-Companion/` with: Temurin JDK 21, apktool 3.0.3, uber-apk-signer
(`signer.jar`), `android.jar` (Android 12 platform stubs, compile only), `r8.jar` (D8 8.5.35) and your own
`signing-key.jks` (+ a `signing-key.txt` holding `alias`, `password`). Then, in `LP-Companion/`:
`adbclient\build-adb.ps1`, `java-keys.ps1`, `make-lang.ps1`, `xref-check.ps1 -Dir source\smali`, `build.ps1`.
Text shown to the user goes through `Lang.t(...)` and needs a line in `translations.txt`; the Java under
`adbclient/` is converted to smali by `build-adb.ps1` (never edit that generated smali by hand).
LP-Music is built with the same toolchain (`LP-Music/build.ps1`).

## Not in this repo (kept local on purpose)
- `LP-Companion/tools/` — the bundled JDK and jars and the **signing key** (`signing-key.jks` +
  `signing-key.txt`). The key never leaves the machine; losing it means installed apps can't be updated in place.
- `**/build/` intermediates, `adbclient/out/` and the built `*.apk` files (they go to Releases).

## Note
These are personal tools for one specific car, provided as-is. They sideload and re-sign
third-party apps; re-signed apps with their own signature checks (e.g. Yandex Passport login)
may refuse to run. Use at your own risk.
