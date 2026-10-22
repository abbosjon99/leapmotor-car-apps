# Leapmotor C01 car apps

Two companion apps for a Leapmotor C01 (2025) head unit (Snapdragon 8155, Android 12),
built by decompiling/patching with apktool and signing with a local key.

## Projects
- **[LP-Companion](LP-Companion/)** (`uz.carhelper.passenger`) — launcher for sideloaded apps on
  the passenger screen: app grid, draggable AssistiveTouch-style bubble (Home / Back / Open app /
  Screen-off / Swap / bar toggle), settings (wheel buttons, auto-close, overload protection, kid
  mode + PIN, a Status page), steering-wheel media control, and self-repair of its Back
  accessibility service after a restart.
- **[LP-Music](LP-Music/)** (`uz.carhelper.music`) — a media companion: mirrors the playing
  sideloaded player into its own MediaSession + MediaBrowserService (to try to light up the car's
  dock "now playing" card), plus the type-13 announce and the steering-wheel key channels. Its
  screen has a master on/off switch and, when DiPlay is installed, a switch to hand the wheel
  buttons to DiPlay while CarPlay is playing.

## Credit
- **DiPlay (wireless CarPlay)** — not included here. Credit to
  [DiPlay-Leapmotor](https://github.com/Wh1t3co1azZ/DiPlay-Leapmotor) by Wh1t3co1azZ, a fork of
  [DiPlay](https://github.com/shihabal3amri/DiPlay) (GPL-3.0). LP Music can yield the steering-wheel
  keys to it while it is playing (toggle in LP Music's settings).

## Not in this repo (kept local on purpose)
- `LP-Companion/tools/` — the bundled JDK, `apktool.jar`, `signer.jar`, and the **signing key**
  (`signing-key.jks` + `signing-key.txt`). The key never leaves the machine; losing it means
  installed apps can't be updated in place.
- `**/build/` intermediates and the built `*.apk` files.

To build, restore a `tools/` folder under `LP-Companion/` with Temurin JDK 21, apktool 3.0.3,
uber-apk-signer, and your own `signing-key.jks` (+ a `signing-key.txt` holding `alias`, `password`),
then run `LP-Companion/build.ps1`. LP-Music is built with the same toolchain.

## Install (over Wi-Fi ADB)
```
adb install --no-incremental --install-reason 64 -r LP-Companion/LP-Companion.apk
```
Per-app grants, the self-repair permission, and the full change history are documented in
`LP-Companion/README.md` and `LP-Companion/CHANGELOG.txt`.

## Note
These are personal tools for one specific car, provided as-is. They sideload and re-sign
third-party apps; re-signed apps with their own signature checks (e.g. Yandex Passport login)
may refuse to run. Use at your own risk.
