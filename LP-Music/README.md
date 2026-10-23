# LP Music

Companion media app for the Leapmotor C01, split out of LP Companion. It watches whatever
sideloaded player is playing (Yandex Music, etc.) and does what the car's own NetEase and Migu apps
do: announces the track to the car as media type 13 (title, artist, cover, play state) so the dock
card, the instrument cluster and the voice assistant show it, and takes the steering-wheel, dock
button and voice commands the car sends back. How the car does this, and why, is in
[FINDINGS.md](FINDINGS.md). It no longer exposes a media source to Android: the old mirror
`MediaSession` / `MediaBrowserService` made the car's media service pause the real player
(FINDINGS.md section 9), so the session stays inactive.

Package: **`com.migu.car.music`** (since 2.19; before that `uz.carhelper.music`)  ·  version 2.21  ·
signed with LP Companion's key.

It takes Migu's package name on purpose: the car has neither Migu nor NetEase, and its media app only
lists type 13, only refreshes the launcher's drawer card for it and only "opens" it when a package with
that name is installed and its `SourceService` can be bound (FINDINGS.md sections 4, 5 and 10). The real
Migu can't be installed next to LP Music.

## Settings (the app's screen)
Opening LP Music shows a Settings page styled like LP Companion's Settings tab (same dark cards, blue accent,
green/red status chips; the shared `Ui.smali` helper is copied from LP Companion).
- **Status** — one row per requirement, green **OK** or red **OFF** with the ADB command that fixes it (selectable text):
  - *Now playing (notification access)* — without it LP Music cannot see the player. Fix:
    `adb shell cmd notification allow_listener com.migu.car.music/uz.carhelper.passenger.WheelListener 10`.
  - *LP Music service* — red when the service is not running. If it is enabled but down, opening the page starts it
    ("Starting now"); if it is switched off the row says so.
  - *Old LP Music (uz.carhelper.music) removed* — red while the old package is still installed (two LP Music apps
    would both announce and both act on the wheel). Fix: `adb uninstall uz.carhelper.music`.
  - **Re-check status** reopens the page to refresh the rows.
- **Playback**
  - *LP Music on* — master on/off. Save starts or stops the media service.
  - *Give the wheel buttons to DiPlay while it's playing* — only shown when DiPlay (`com.shihab.diplay`) is installed.
    While DiPlay is actively playing, LP Music stops controlling (no wheel keys, no type-13 announce) so the wheel buttons
    drive DiPlay instead.
- **Language** — five chips: English, Русский, Español, Oʻzbekcha, 中文. A tap applies at once (the page reopens in
  that language and keeps unsaved switch positions). Before anything is chosen, the system language is used if it is
  Russian, Spanish, Uzbek or English; every other system language, including the car's default Chinese, opens in
  English. Chinese is only selected by hand.
- **Vehicle** — *Vehicle settings* opens Android's settings.
- **Save** writes the settings (and restarts the service so changes apply); **Cancel** leaves without saving.
  The old "Don't grab the hardware media buttons" switch is gone: the media session it configured is never active now.

## Why a separate app
Keeping it apart from LP Companion means we can install it, test, and remove it (`adb uninstall
com.migu.car.music`) without touching the main app.

## What's inside (`source/smali/uz/carhelper/passenger/`, plus `source/smali/com/migu/car/music/launcher/`)
| File | Role |
|------|------|
| `MediaBrowser.smali`   | The app's foreground service (not exported, no `MediaBrowserService` intent-filter): owns an inactive `MediaSession`, runs the announce + steer channel. |
| `MediaMirror.smali`    | Every 1 s remembers which player is in use (`lastPlayer`) for `OpenPlayerActivity`; keeps our session inactive. |
| `MediaCb.smali`        | Session callback, play/pause/next/prev/stop forwarded to the player (unreachable while the session is inactive). |
| `MiguBridge.smali`     | Announces the player to the car as media type 13 (`MEDIA.INFO`: title, artist, album, duration, cover URL + JPEG, play state). |
| `CoverProvider.smali`  | Serves the current cover as `content://com.migu.car.music.cover/cover.jpg?v=<hash>`; the dock card loads `imagUrl` with Glide. |
| `MiguCtrlReceiver.smali` | METER.CTRL / VOICE.CTRL (wheel, dock buttons, voice) -> player (METER through `KeyDedup`). |
| `SteerWheelReceiver.smali` | `com.leapmotor.steerwheelcontrol.media` (action 1/4/7) -> player. |
| `KeyDedup.smali`       | 350 ms de-dup shared by the two key channels, logs under `LPWheelKeys`. |
| `WheelReceiver/Listener/Guard.smali` | Media-session helpers + the notification listener for `getActiveSessions`. |
| `OpenPlayerActivity.smali` | Opens the playing/last player when the car's media card is tapped or the car "opens Migu" (`com.migu.car.music.ACTION_START`). |
| `../../com/migu/car/music/launcher/SourceService*.smali` | The service the car's media app binds to (`ISourceController`); answers its favourite lookups, which lets the launcher drawer card refresh. |
| `MusicSettingsActivity.smali` | The launcher screen (Settings page): Status rows, enable + DiPlay-yield switches, Vehicle settings, Save / Cancel. |
| `Lang.smali` | Language choice (saved pick, else system language if supported, else English) and string lookup by name from `res/values*/strings.xml`. |
| `Ui.smali` | Shared look (colours, rounded cards, pills, switch tint), copied from LP Companion. |
| `MusicGate.smali` | Reads the settings and decides `shouldHandle()` — off, or yielding to a playing DiPlay. |
| `BootReceiver.smali`   | Start the service on boot (it stops itself if disabled). |

Its own music launcher icon lives in `res/drawable/ic_launcher_music_fg.xml` +
`res/mipmap-anydpi-v26/ic_launcher.xml` (teal background, white note).

## Languages
The Settings page is in English (default, `res/values`), Russian (`values-ru`), Spanish (`values-es`), Uzbek in Latin
script (`values-uz`) and Simplified Chinese (`values-zh`). To add or fix a text, edit the same key in each
`strings.xml` and keep `Lang`'s language list in sync. The app name and the ADB commands are not translated, and
the language only applies to LP Music's own screen.

## Build
`powershell -ExecutionPolicy Bypass -File build.ps1` — uses the shared toolchain in
`..\LP-Companion\tools` (JDK, apktool, uber-apk-signer, signing key; pass `-Tools <folder>` if it lives
elsewhere), the same way LP Companion is built. Produces `LP-Music.apk` and `LP-Music-<version>.apk`.

## Install and test (needs the car on ADB)
LP Companion 2.19 has no wheel handling of its own any more (and steps aside whenever LP Music is
installed). With an older LP Companion, avoid both apps handling wheel keys at once (their de-dup is
per-process and won't cross apps): turn its **wheel** switch OFF while testing LP Music.

If the old `uz.carhelper.music` is installed, remove it first (for both users; two LP Music apps would both
announce and both act on the wheel). The new package starts with default settings.
```
adb uninstall uz.carhelper.music
adb install --no-incremental --install-reason 64 -r LP-Music.apk
adb install --user 10 --no-incremental --install-reason 64 -r LP-Music.apk   # the car runs user 10
adb shell cmd notification allow_listener com.migu.car.music/uz.carhelper.passenger.WheelListener 10
adb shell am start-foreground-service --user 10 -n com.migu.car.music/uz.carhelper.passenger.MediaBrowser
```
Play something in Yandex Music, then watch the launcher drawer card, the status-bar strip and the cluster.
- Expected (2.19, not yet run on the car): the drawer card switches to the song with the "Migu" source name and the
  cover; the strip shows it while another app is in front; the wheel, the card's buttons and voice (play / pause /
  next / previous) drive the player. In logcat: `MiGuServiceImpl: isConnected : true`.
- Card still empty -> check `adb logcat -s LPMigu` for the announced JSON, and the car's side:
  `adb logcat -s CtrlReciver NotifyOutForOtherManager SmartDockService`
  ("not in the MusicItem enumeration" means the type was wrong).

Logs: `adb logcat -s LPMusic LPWheelKeys LPMigu`

## Revert
```
adb uninstall com.migu.car.music
```
Then turn LP Companion's wheel switch back ON. Nothing else changed.

## Untested
The smali is hand-written. 2.16 (cover provider, richer announce, voice parsing) ran on the car: the car
and the dock accepted the announce and the wheel "next" worked (FINDINGS.md section 8). 2.17 (own-session fix,
the car routes the wheel) ran on the car and the wheel routing looked right in the logs. 2.18 (no mirror
session, no `MediaBrowserService`: fixes Yandex Music pausing by itself), 2.19 (package
`com.migu.car.music` + `SourceService`) , 2.20 (new Settings page with Status rows) and 2.21 (five languages) were built while the car
was offline and have not run on the car yet.
