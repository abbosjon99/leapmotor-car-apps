# LP Music

Companion media app for the Leapmotor C01, split out of LP Companion. It mirrors whatever
sideloaded player is playing (Yandex Music, etc.) into its own `MediaSession` and exposes a
`MediaBrowserService`, so the car's dock "now playing" card has a media app to bind to. It also
keeps the type-13 Migu announce and the steering-wheel key channels.

Package: `uz.carhelper.music`  ·  version 1.0  ·  signed with LP Companion's key.

## Settings (the app's screen)
Opening LP Music shows its settings:
- **LP Music enabled** — master on/off. Save starts or stops the media service.
- **Give the wheel buttons to DiPlay while it's playing** — only shown when DiPlay
  (`com.shihab.diplay`) is installed. While DiPlay is actively playing, LP Music stops controlling
  (no mirror, no wheel keys, no type-13 announce) so the wheel buttons drive DiPlay instead.
- **Don't grab the hardware media buttons** (on by default) — LP Music's media session won't claim
  the hardware/`MEDIA_BUTTON` keys, so Android Auto or the actually-playing app keeps them. LP Music
  still controls music via the car's own wheel signal. Turn off only if the wheel buttons stop working.
- **Save** writes the settings (and restarts the service so changes apply); **Exit** leaves without saving.

## Why a separate app
The dock card experiment needs an app that publishes a standard Android media session. Keeping it
apart from LP Companion means we can install it, test, and remove it (`adb uninstall
uz.carhelper.music`) without touching the main app. It uses its own package name — it does NOT
impersonate Migu.

## What's inside (`source/smali/uz/carhelper/passenger/`)
| File | Role |
|------|------|
| `MediaBrowser.smali`   | `MediaBrowserService`; owns the `MediaSession`, runs the mirror + Migu announce + steer channel, foreground service. |
| `MediaMirror.smali`    | Every 1 s copies the playing player's title/artist/album/art + play state into our session. |
| `MediaCb.smali`        | Session callback; play/pause/next/prev/stop forwarded to the mirrored player. |
| `MiguBridge.smali`     | Announces the player to the car as media type 13 (dock + wheel routing). |
| `MiguCtrlReceiver.smali` | METER.CTRL / VOICE.CTRL -> player (through `KeyDedup`). |
| `SteerWheelReceiver.smali` | `com.leapmotor.steerwheelcontrol.media` (action 1/4/7) -> player. |
| `KeyDedup.smali`       | 350 ms de-dup shared by the two key channels, logs under `LPWheelKeys`. |
| `WheelReceiver/Listener/Guard.smali` | Media-session helpers + the notification listener for `getActiveSessions`. |
| `OpenPlayerActivity.smali` | Opens the playing/last player when the car's media card is tapped. |
| `MusicSettingsActivity.smali` | The launcher screen: enable + DiPlay-yield switches, Save / Exit. |
| `MusicGate.smali` | Reads the settings and decides `shouldHandle()` — off, or yielding to a playing DiPlay. |
| `BootReceiver.smali`   | Start the service on boot (it stops itself if disabled). |

Its own music launcher icon lives in `res/drawable/ic_launcher_music_fg.xml` +
`res/mipmap-anydpi-v26/ic_launcher.xml` (teal background, white note).

## Build
Built with the shared toolchain in `..\LP-Companion\tools` (apktool + uber-apk-signer), the same
way LP Companion is built. Produces `LP-Music.apk`.

## Install and test (needs the car on ADB)
First, avoid both apps handling wheel keys at once (their de-dup is per-process and won't cross
apps): in LP Companion's Settings, turn the **wheel** switch OFF while testing LP Music.

```
adb install --no-incremental --install-reason 64 -r LP-Music.apk
adb shell appops set --user 10 uz.carhelper.music SYSTEM_ALERT_WINDOW allow   # only if needed
adb shell cmd notification allow_listener uz.carhelper.music/uz.carhelper.passenger.WheelListener 10
adb shell am start -n uz.carhelper.music/uz.carhelper.passenger.MusicSettingsActivity
```
Play something in Yandex Music, then watch the dock card.
- Card shows the song, controls work  -> the own-named media app is enough; no impersonation needed.
- No card ever appears                 -> the car only shows its own allowlisted media packages.
                                          That would need spoofing, which we don't do. Keep type-13.

Logs: `adb logcat -s LPMusic LPWheelKeys LPMigu`

## Revert
```
adb uninstall uz.carhelper.music
```
Then turn LP Companion's wheel switch back ON. Nothing else changed.

## Untested
The `MediaSession` / `MediaBrowserService` smali is hand-written and has not run on the car yet.
First launch may surface a crash in logcat (tag `AndroidRuntime`); send it over if so.
