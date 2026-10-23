# How the car shows "now playing" and takes media controls (and what LP Music does about it)

Analysis of `com.leapmotor.lpplayer`, `com.migu.car.music` (v1.0.40) and NetEase
`com.netease.cloudmusic.iot`, cross-checked against the car's own media apps pulled read-only from the
head unit (MultiMedia v4.1.90, Launcher3 with the smart dock, CarControl, CarSystemUI). Everything
below is from static analysis of the shipped code plus read-only `dumpsys` on the car; nothing was
executed or observed on screen. Class names are the (obfuscated) names in those APKs.

Tooling note: REA's Android providers (JADX jar, apktool launcher) were not configured in the session,
so `inspect_android_package` could not be used. REA `open_binary` opened the APK container; code was
read with apktool 3.0.3 smali, a small AXML/dex-string dumper, and `dumpsys`.

## 1. The mechanism: one announce broadcast, three broadcasts back

The car does not discover third-party players through MediaSession or MediaBrowserService. The only
thing that makes a player appear is an announce broadcast, and the car answers with plain broadcasts.

**Announce (app -> car)** `com.leapmotor.transfer.MEDIA.INFO`, flags `0x11000000`, no package target.
The only registered receiver on the car is `com.leapmotor.multimedia` (CtrlService, dynamic receiver,
also for `car.hmi.music.BROADCAST`, `com.leapmotor.speech.tomedia`, `com.leapmotor.steerwheelcontrol.media`).
- `info` (String): `{"type":"music","data":MediaBody,"detail":{"format":"jpeg","length":N,"offset":0}}`
  with `MediaBody = {albumId, artist, duration, imagUrl, name (= track title), state, title (= album), type, uniqueId}`.
- `bitmap` (byte[]): cover JPEG; NetEase sends 200x200, quality 50.
- `state`: 1 play, 0 pause, 2 stop (the car's `PlayState`).
- MultiMedia ignores type 7 on this path (NetEase also talks to the car through an SDK path) and takes
  types 7, 13, 21-26, 28-30 into its state. The sender package is never checked.
- A state-1 announce is stored as the last played media type. That is what later routes voice and keys.
- Any announce, whatever its type, is re-broadcast as `com.leapmotor.action.MEDIA.INFO` (extra `content`,
  received by `com.leapmotor.aispeech` and `com.leapmotor.carcontrol`) and published to the instrument
  cluster over SOME/IP 0x9401 together with the bitmap.
- For known types MultiMedia posts the MediaBody to its AIDL service `com.leapmotor.mediac11.MediaService`
  (action `com.leapmotor.mediac11.MediaService`, permission `com.leapmotor.media.MediaService.permission.ACCESS_SERVICE`,
  protection level normal). `launcher3:smartdock` (the dock), `com.leapmotor.scene` and `com.leapmotor.carcontrol`
  are bound to it right now.

**Dock card** (`com.leapmotor.appcenter.service.SmartDockService`):
- `onState(MediaBody)` is applied only when `state == 1`, or when the type is already the dock's current type
  (so a "paused" announce alone never switches the card to a new source).
- The type must be in the dock's `MusicItem` enum: 12 LP radio, 0 Kugou, 3 Ximalaya, 10 online radio,
  2 Bluetooth, 5 USB, 4 FM, 7 NetEase, 13 Migu, 28 browser, 29 QQ Music. Otherwise it logs
  "not in the MusicItem enumeration" and shows nothing.
- It shows `name`, `artist` and loads the cover with Glide from the `imagUrl` string
  (types 2 and 5 always use the default cover). The `bitmap` extra is not used by the dock; it feeds the cluster.
- The card is labelled and iconed by type (13 = "Migu" text and icon).
- Its buttons call the MultiMedia AIDL (`pre()`, `pauseOrResume()`, `next()`, `play()`, `pause()`), which
  forwards to the strategy of the current type.

**Controls (car -> app)** for type 13 (Migu, `ie.y` MiGuStrategy) and 7 (NetEase), sent by MultiMedia
whether the press came from the steering wheel, the dock card, the MultiMedia screen or voice:
- `com.leapmotor.action.METER.CTRL`: `value` String `"1"` previous, `"2"` next, `"3"` play/pause;
  `keyEventType` String `"steeringWheel"` (NetEase also accepts `"backRow"`); `playMediaType` **int** (7 or 13).
- `com.leapmotor.action.VOICE.CTRL`: `value` String JSON `{"type":"play|pause|stop","state":-1}` from the car's
  own UI; the voice assistant also sends `nextOne`, `preOne`, `mode`, `mute`, `collect`, `cancelCollect`,
  `openLyric`, `closeLyric`, `open`, `music` (NetEase's `LeapVoiceDate`); `playMediaType` int.
- The raw wheel signal `com.leapmotor.steerwheelcontrol.media` (int `action`: 1 previous, 4 next, 7 play/pause,
  0 release) is consumed by MultiMedia itself and turned into the broadcasts above for the current type.
- Voice target priority in MultiMedia (`zc.d.getNeedDealMediaType`): the car source that is playing, then the
  foreground package (`com.migu.car.music` -> 13, `com.netease.cloudmusic.iot` -> 7, ...), then the last media
  type stored by a state-1 announce, then a default.

**Media type ids** (the car's `MediaType`): 0 Kugou/UltimateTV, 1 local/other, 2 Bluetooth, 3 Ximalaya, 4 FM,
5 **USB**, 6 online, 7 NetEase, 8 KTV, 9 MV, 10 online radio, 11 Yunting, 12 LP radio, 13 Migu, 14 car link,
15 Fandeng, 16 HiCar, 17 iQiyi; 21-26 / 28-30 are in-process overseas plug-ins of MultiMedia.

## 2. Per APK

| | NetEase `com.netease.cloudmusic.iot` (type 7) | Migu `com.migu.car.music` (type 13) | LP Player `com.leapmotor.lpplayer` |
|---|---|---|---|
| Announce | `IotLeapServer.sendLeapMediaInfo`: MEDIA.INFO with `data` incl. real `duration`, `imagUrl` (cover URL), `detail.format "jpeg"`, `detail.length` = cover bytes; cover downloaded with `?imageView=1&thumbnail=200z200&type=jpeg&quality=50`; flags `0x11000000` | Not readable: packed with ijiami (method bodies are stubs, real code in encrypted `ijiami.ajm`). The car's side shows what it sends (same JSON) | None. Video player for the driving-recreation SDK |
| Wheel / voice | `LeapControlBroadcastReceiver` (METER.CTRL), `LeapVoiceBroadcastReceiver` (VOICE.CTRL), both gate on `playMediaType == 7` | Manifest receivers `LingPaoMeterCtrlReceiver` (METER.CTRL) and `LingPaoReceiver` (VOICE.CTRL) | none |
| Other car hooks | `MediaBrowserService` `AutomotiveService` + `MediaSessionCompat` (tag `"MediaSession"`, flags 3), BOOT_COMPLETED receiver, binds `com.leapmotor.carcontrol` (`...services.BINDER_POOL`, permission `com.leapmotor.carcontrol.CAR_CONTROL_SERVICE`) for car data | Exported `SourceService` (AIDL `ISourceController`: collection state, play time), `BootBroadcastReceiver` for BOOT_COMPLETED plus `com.leapmotoraction.BOOT_COMPLETED`, activity action `com.migu.car.music.ACTION_START`. No MediaBrowserService | `com.leapmotor.media_focus_change` broadcast + audio focus for display 0/1 |
| Manifest permissions of note | `freemme.permission.msa[.SECURITY_ACCESS]`, `CAR_CONTROL_SERVICE` | none beyond network/storage/foreground | `WRITE_SECURE_SETTINGS`, `SYSTEM_ALERT_WINDOW` |

## 3. What does NOT matter (removed from LP Music 2.16)

- `freemme.permission.msa`, `MediaSessionServiceName` and `MediaControllerTag`: present in NetEase's manifest
  (and copied into LP Music 2.15), but the strings occur in none of the car apps checked (MultiMedia, MediaClient,
  CarSystemUI, Launcher3, CopilotShow, ScreenSaver, CarControl) and the car defines no permission with
  that name. They are generic OEM leftovers. A `MediaBrowserService` and a MediaSession are not how the car
  finds a player. LP Music used to mirror the player into its own session and expose a `MediaBrowserService`;
  nothing on the car's media/dock side reads that, and Android's own car media service reacted to it by pausing
  the real player (section 9). 2.18 keeps the session inactive and drops the `MediaBrowserService` intent-filter.

## 4. The dock card that "did not show the song" ("no widget slot type 5")

Checked on the car with 2.16 (logcat):
- The log line is `SmartDockAdapter: getPositionByWidgetType: find positon error type = 5`. It is printed after
  **every** `SmartDockService.onState` (`refreshKgListIfNeed`, "kglist is not in sd!"). It is the dock's *widget* type 5,
  the Kugou playlist widget, which this dock layout does not have. It has nothing to do with media type 5 (USB)
  and is harmless; I first misread it as the USB type.
- The real blocker for the card in the launcher's dock drawer: for types 0, 7 and 13 the dock does not refresh the
  music widget until MultiMedia answers its favourite lookup (`SmartDockService.queryIsLikeFromDb` ->
  `ApiInterface.isFav`; the callback then calls `refreshMusicWidgetView`). For type 13 MultiMedia answers through
  `MiGuServiceImpl.isFav`, which first needs `MiGuServiceImpl.isConnected()`, i.e. a bound connection to
  `ComponentName("com.migu.car.music", "com.migu.car.music.launcher.SourceService")` (`ah.e.n`, hard-coded).
  Without that package it logs `MiGuServiceImpl: isConnected : false`, `initConnect packageName : null`, and
  returns without ever calling back. Observed: 15 announces, 15 `MediaBinder: isFav mediaType : 13` lines, zero
  `isFav` answers on the dock, and no `showMusicItem` bind. So the drawer card never switches to the LP Music
  track. Only installing something under Migu's package name that serves `ISourceController` would change that
  (impersonation, not done).
- What does work for type 13 without Migu: the dock calls `refreshStatusbarMusicView` directly, and its log shows the
  status-bar music strip (`showStatusbarMusicUI: true`, view visible) while another app such as the player is in front.
  The strip is hidden on the launcher home page, where the drawer card is supposed to take over.
- Type 5 as a *media* type is the car's built-in USB source; MultiMedia does not forward third-party announces of type 5
  to the dock (accepted: 7, 13, 21-26, 28-30), so it is not an option either.
- The "no widget for" string in the car apps is androidx `MotionLayout`, unrelated.

## 5. What cannot be done without impersonating Migu or NetEase (not done)

- MultiMedia's source list for the cluster (SOME/IP 0x9701) lists 13 only if `com.migu.car.music` is installed
  (7: `com.netease.cloudmusic.iot`). The dock's source switcher does the same check.
- "Open app" from the car (voice, card tap) launches `com.migu.car.music` / `com.netease.cloudmusic.iot` by
  package name, so it cannot open LP Music. (Uninstalling one of those packages while its type is the current one
  makes MultiMedia publish a stop for it; that cleanup never fires for LP Music.)

## 6. LP Music 2.16 changes

- `MiguBridge`: announce JSON now carries `duration` (ms, from the player's metadata), `imagUrl`, and
  `detail` = `{format:"jpeg", length:<bitmap bytes>, offset:0}`; bitmap extra is 200 px JPEG quality 50 like NetEase;
  an unchanged cover does not re-announce, a changed cover does (the URL carries a hash).
- New `CoverProvider` (`content://uz.carhelper.music.cover/cover.jpg?v=<hash>`, exported, read-only, one file:
  the current cover as 300 px JPEG in the app cache). The dock loads `imagUrl` with Glide, which reads content URLs.
- `MiguCtrlReceiver`: VOICE.CTRL is parsed as JSON; `nextOne`, `preOne`, `previous`, `stop` (= pause) are handled
  (before, only `next`/`pre` matched, so the voice assistant's `nextOne` did nothing).
- Manifest: removed the freemme permissions and the two meta-data entries; `BootReceiver` also listens for the car's
  own `com.leapmotor.action.BOOT_COMPLETED` and `com.leapmotoraction.BOOT_COMPLETED`.
- 2.17: `WheelReceiver.findTarget` skips LP Music's own mirror session. Found on the car with 2.16 (see section 8):
  the mirror counted as a playing non-car player, so announces flipped between `ru.yandex.music` and
  `uz.carhelper.music` (duration 0 whenever it picked itself) and wheel presses went to LP Music's own session.
- 2.17: the raw `steerwheelcontrol.media` channel (`SteerWheelReceiver`) now stands down while the car's
  `Settings.Global LAST_PLAY_MEDIA_TYPE` is 13 (`MusicGate.carRoutes`): in that case MultiMedia routes every press
  itself as METER.CTRL / VOICE.CTRL, and acting on both made play/pause fight (section 8). With any other last
  car source the channel works as before.
- 2.17: after every car command `MiguCtrlReceiver` calls `MiguBridge.kick()`: four quick 0.5 s ticks instead of
  waiting up to 1.5 s, so the announced state (which decides whether the car's next centre press sends pause or play)
  follows the player fast.
- 2.18: the mirror `MediaSession` is never activated and the `MediaBrowserService` intent-filter is gone (service
  not exported), which stops the Yandex Music play/pause flapping (section 9). `MediaMirror` now only remembers the
  last player for `OpenPlayerActivity`.
- Unchanged: type 13, 1.5 s tick otherwise, `playMediaType` int gate, 1/2/3 mapping, KeyDedup.

## 7. Unknowns

- `duration` unit on the car side (NetEase passes its player's raw value; ms assumed). The dock does not read it.
- Whether the cluster shows the cover (nothing in logcat says either way; it matches NetEase's size and quality).
- How MultiMedia's own screen renders a type-13 source when `com.migu.car.music` is absent.
- Migu's real runtime behaviour (encrypted). Everything about type 13 comes from the car's side of the protocol.
- What the status-bar strip and the drawer look like on screen (not looked at; only the dock's log and the served cover
  were checked).

## 8. Checked on the car (2.16 installed for users 0 and 10, Yandex Music playing, logcat + dumpsys only)

Observed:
- LP Music logged the announce; MultiMedia logged `notifyOut change info` and `Recive out media bitmap size`
  (7229 and 4441 bytes); `SmartDockService.onState` received `MediaBody{type=13, ... imagUrl=content://uz.carhelper.music.cover/...,
  state=1}` and set `musicType = 13`. The car also wrote it to `Settings.Global LAST_PLAY_MEDIA_INFO`, and the voice
  assistant (`LPSpeech`) logged `updateFocus: focus: 13, state: 1`, and carcontrol's `MediaPlayReceiver` got it.
- Reading `content://uz.carhelper.music.cover/cover.jpg?v=...` as the shell user returned a valid 300 px JPEG of the
  right cover. No Glide errors were logged.
- Wheel: MultiMedia logged `steerwheelcontrol info : 4` then `MiGuStrategy: next`, and Yandex Music went to the next
  track (the press was handled by the `steer` channel; the `meter` copy was dropped by KeyDedup). Centre press:
  `steerwheelcontrol info : 7` then `MiGuStrategy: pause` and a `VOICE.CTRL {"type":"pause","state":-1}` that reached LP Music.
- No crash, no exception from LP Music.

Bug 1 (self target): the announces alternated between `uniqueId` `ru.yandex.music:...` and `uz.carhelper.music:...` (with
`duration` 0), and three of four centre presses were sent to `uz.carhelper.music` instead of Yandex Music, so the player
kept playing. Cause: `findTarget` accepted LP Music's own mirror session. Fixed in 2.17.

Bug 2 (double handling), from the user's report "pausing by the wheel works, resuming does not; pressing play in the
app sometimes triggers pause/play" and the log: the car picks pause or play for a centre press from the **last announced
state** (it sent `MiGuStrategy: pause` for all four presses, because the announced state stayed 1). LP Music's own
`steer` channel toggled at the same moment, so whenever the announced state was stale the car's command undid the
toggle. No other VOICE.CTRL / METER.CTRL reached LP Music after the wheel presses, so the "ghost" commands came from
these two paths and the self-targeting, not from a third sender. Fixed in 2.17 (car routes, steer stands down,
quick state refresh). Not yet re-tested on the car.

Side observation: any non-car session is treated as a player, so YouTube (ReVanced) videos were announced as type 13
too (title, duration, cover). That is existing behaviour, left alone.

Not observed: the dock card on screen, the cluster, voice commands, the dock's own buttons.

## 9. Yandex Music pausing by itself after "play" (2.16 / 2.17 on the car)

Reported: pressing play inside Yandex Music, it pauses for no reason, then plays again, and so on.

Log (logcat, 16:39:53 - 16:40:18, no wheel press and no METER/VOICE command from the car in that window):
- Yandex starts: `requestAudioFocus` from `ru.yandex.music`; the car's media service (`CAR.MEDIA`, `com.android.car`) logs
  `Changing media source due to playback state change: ru.yandex.music/...Media3LibraryService`.
- 0.4 - 1 s later, as LP Music's mirror session turns "playing": `CAR.MEDIA: Changing media source due to playback state
  change: uz.carhelper.music/uz.carhelper.passenger.MediaBrowser`, and 6 - 40 ms after that Yandex calls
  `abandonAudioFocus` (it pauses).
- About a second later Yandex requests focus again (it plays), and the cycle repeats: 11 request/abandon pairs in one minute,
  continuing at 16:42 without any input.
Cause: LP Music exposed a `MediaBrowserService` and kept a mirror `MediaSession` that copied the player's playing state.
Android's car media service treats whichever browser service is playing as the media source and switches to it, and the
switch pauses the previous source (the real player). Nothing on the Leapmotor side (MultiMedia, dock) reads that session.
This also explains the "ghost" play/pause seen right after starting playback.
Not seen in the log: any command from LP Music or the car's METER/VOICE path at those moments.
Fix (2.18, not yet run on the car, which was offline when it was built): the mirror session is never activated and the
`MediaBrowserService` intent-filter is removed, so `CAR.MEDIA` has no LP Music source to switch to.
Check after install: while Yandex plays, `logcat | grep CAR.MEDIA` must show only `ru.yandex.music` and
`MediaFocusControl` must show no repeated abandon/request pairs.

## 10. LP Music under the package name com.migu.car.music (2.19)

Why: section 4 (the dock card for type 13 needs a bound `com.migu.car.music/.launcher.SourceService`, and the car lists
type 13 only while that package is installed). Decided by the user: the car has neither Migu nor NetEase, so LP Music takes
Migu's package name. History: a first attempt was blocked by the tooling's permission classifier, the pieces were parked in
`wip-migu-package/` (2.18 shipped without them), then re-applied after the user asked again (2.19).
What 2.19 contains:
- manifest `package="com.migu.car.music"` (class names stay `uz.carhelper.passenger.*`); label stays "LP Music".
- `com/migu/car/music/launcher/SourceService.smali`, `SourceService$Ctl.smali`, `SourceService$Reply.smali`: a bound service with
  a hand-written Binder for `com.migu.car.music.ISourceController` (codes 1 request, 2 registerCallback, 3 unregisterCallback,
  4 getCollectionStutas, 5 collectionAction) that answers the car's callback (`com.migu.car.music.ISourceCallBack`, code 1,
  one-way) with a `ResponseFavBean` JSON `{contentId, isCollection:false, isLogin:true, isSuccess:true, mediaType:13, msg:""}`.
  The car's connector sets "connected" as soon as the bind succeeds, so the handshake is bind + registerCallback + lookups.
- cover authority and `MiguBridge` imagUrl: `com.migu.car.music.cover`; `WheelReceiver.findTarget` skips both package names.
- `OpenPlayerActivity` also answers `com.migu.car.music.ACTION_START` (what the car uses to launch Migu), so "open app" lands on
  the playing player.
Install notes:
- Uninstall `uz.carhelper.music` for users 0 and 10 first (two LP Music apps would both announce and both act on METER/VOICE).
  The new package starts with fresh settings (everything on by default) and needs the notification listener granted again:
  `com.migu.car.music/uz.carhelper.passenger.WheelListener`.
- LP Companion needs no change (its wheel/announce code is not registered anywhere).
- The real Migu can never be installed next to this. The car's app store list (`Settings.Global C11_SERVER_APP_LIST`) names apps
  like NetEase; I did not check whether it offers Migu. An update of the real Migu signed with another key would not install
  over this app.
- Expected on the car (not yet verified): `MiGuServiceImpl: isConnected : true`, an `isFav` answer on the dock, the launcher
  drawer card switching to the song with "Migu" as source name, type 13 in the car's source list, and "open Migu" opening the player.
