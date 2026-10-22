# Credits

This folder vendors **DiPlay-Leapmotor** (the `leapmotor-24-27` branch) — a Leapmotor 2024+
adaptation of DiPlay, a wireless CarPlay receiver for Android head units.

- Fork: **Wh1t3co1azZ/DiPlay-Leapmotor** — https://github.com/Wh1t3co1azZ/DiPlay-Leapmotor
- Upstream: **shihabal3amri/DiPlay** — https://github.com/shihabal3amri/DiPlay

License: **GPL-3.0** (see `LICENSE`). All credit for DiPlay and its Leapmotor port goes to the
authors above. This copy is unchanged except for the one local modification noted below, and the
authors' own README / docs are kept alongside it.

## Local modification (leapmotor-car-apps)
DiPlay now **yields the steering-wheel media keys** to our own companions — **LP Music**
(`uz.carhelper.music`) or **Migu** (`com.migu.car.music`) — whenever either is installed, so one
physical press is never handled by two apps. With neither installed, DiPlay behaves exactly as
upstream.

Changed files:
- `common/src/main/java/com/shilapi/xcertplay/Leapmotor24WheelKeys.kt` — `yieldingTo()` plus gates
  in `attach()` (skip registering the receiver) and `claim()` (suppress every press, which also
  covers the Android media-key path via `claimAndroidKey`).
- `common/src/main/AndroidManifest.xml` — `<queries>` entries so `getPackageInfo` can see those two
  packages on Android 11+.

## Not built here
Kept as source only. Building needs Android Studio / Gradle and Apple MFI auth assets
(`offline-mfi/identity.pk8`, `certificate.p7b`) that are not included — see the authors' BUILD and
INSTALL docs. The `.github` CI workflows and the authors' assistant-config files were left out of
this copy; nothing else was removed.
