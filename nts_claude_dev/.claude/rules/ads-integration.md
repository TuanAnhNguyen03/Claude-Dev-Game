---
paths:
  - "**/Assets/**/Scripts/**/*Ads*.cs"
  - "**/Assets/**/Scripts/**/GameManager.cs"
  - "**/Assets/**/Scripts/**/Settings.cs"
  - "**/Assets/**/ScStatic.cs"
  - "**/Assets/Packages/nts-unity-foundation/**"
---

# Ads integration (projects using `nts-unity-foundation`)

Full kit (SDK setup, API, checklists, templates, aar, lessons): `D:\1.Game_UNITY\4.SkillDev\NTS-Ads-Setup` — skill `nts-ads-setup`.

## Phase gate: ads/SDK is the LAST phase
- Build and verify the game first (core loop, levels, UI, save, Settings, Home). Ads/SDK setup starts only after the user **confirms in chat** that it is time to install it.
- Before coding ads, fill the moment table (`NTS-Ads-Setup/checklists/02-ads-placement.md`) with the user and write it to `<stt>_claude.md`.
- Order inside the phase: SDK/config → host contract (`ScStatic`, `NtsHostContract`, `AdShowDelay`) → ad calls → foundation patch → build → device test.

Owner of ads logic = the foundation. Game code only **calls** it at the right moment. Learned on TRG51 (2026-10-08): extra guards in game code cost time and produced wrong behaviour.

## Call directly, one line per moment
| Moment | Call |
|---|---|
| Level start (level scenes only, `buildIndex > SceneIndexOffset`) | `_ShowBottomBanner()` **or** `_DelayShowCollab()` — one, as decided in `<stt>_claude.md` (TRG54 banner, TRG51 collab) |
| Level win | after the win screen + `AdShowDelay.Seconds`: [`RateAppUtils.OnRate` once] → `ShowNativeInter(_ => Continue(), "level_win")` (+ `_ShowBottomBanner()` if the game uses it) |
| Reward button (Next/Skip, unlock, revive, x2…) | `AdShowDelay.Seconds` → `ShowNativeReward(ok => Continue(), "next_level")` |
| MREC / banner in a panel | `NativeAdBridge.Instance.ShowNativeBanner(...)` on open, `HideNativeBanner()` on close |
| Plain AdMob (no native) | `AdsManager.Instance.ShowInterstitial(...)` / `ShowRewardBasedVideo(...)` |

- Put the game's continuation (load next level, close panel) **inside the callback**. Guard against double taps with one `adBusy` flag in the caller, nothing more.
- Reset `adBusy` in `OnApplicationFocus(true)`: `ShowRewardBasedVideo` returns without callback when offline.
- `RateAppUtils.OnRate` without define `USE_RATE` opens the Play Store page; decide and record it.
- Placement names are plain strings at the call site (used for analytics).

## Do NOT add in game code
- Readiness wrappers (`Ready`, `gameLoaded`, `Instance != null` chains), internet checks, organic/non-organic checks, remote-config/level gates, cap/interval counters — the foundation already does these and returns through the callback (in Editor it completes immediately).
- Chained ads per action (inter **then** reward on one button) or a second facade that re-implements foundation behaviour.
- Copies of foundation logic "to be safe". If a foundation call misbehaves, read its source (`GameNativeHandle.cs`, `AdsManager.cs`) and fix the cause or report it — do not wrap it.

## `ScStatic.LevelCurrent` / `LevelLog` = the game's own level
The foundation reads `ScStatic.LevelCurrent` for every level gate (`levelShowInter/Banner/OpenAds/Collab`, `levelPreloadReward`) and `LevelLog` for analytics. Learned on TRG37 (2026-10-08).
- Make both **read-only properties over the save that already holds the level** — never a static field that some controller has to remember to assign:
  `public static int LevelCurrent => <save>.Level;` (1-based) · `public static int LevelLog => LevelCurrent;`
- Before writing it, find the real level key in the project (grep `Level`, `PlayerPrefs`, `SaveManager`/ES3 keys) and reuse it. Do not invent a parallel counter when a level save exists.
- **Game without levels**: add one persisted **start-game counter** (+1 per match start, incl. retry/next from the result screen) and use it as the level. Persist through the project's save wrapper (`SaveManager` in NTS).
- **Collection of mini-games**: the level is per mini-game — games with a saved level expose it (TRG37: `ILevelProgress { int Level { get; } }`), the rest use a per-game start counter (`mg.starts.<gameId>`); keep the last value after leaving a match so Hub/Result screens still gate correctly.
- Changing what "level" means moves every ad gate. State the impact (which gates, what existing players see after update) and get it confirmed before release.

## Before claiming ads work
- Release config is in `rules/android-build.md` (ads release checklist).
- Verify on device/LDPlayer with ADB evidence; Editor shows no real ads.
