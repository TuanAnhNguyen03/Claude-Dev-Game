---
paths:
  - "**/ProjectSettings/**"
  - "**/Assets/Plugins/Android/**"
  - "**/Assets/**/*.java"
  - "**/Assets/**/*.gradle"
  - "**/Assets/**/*.androidlib/**"
  - "**/Assets/Settings/Build Profiles/**"
  - "**/Assets/Packages/nts-unity-foundation/**/Ads Settings.asset"
---

# Android build & release rules

Defaults below are measured on TRG51 (Unity 6000.3); state the size/effect when you change them, and keep a project's existing choice if `<stt>_claude.md` overrides it.

## Size / performance defaults
- Texture compression: ASTC (ETC1 leaves NPOT/alpha textures uncompressed → larger APK). 3D textures `Normal` quality (ASTC 6x6) is a safe default; lower max size / ASTC 8x8 is lossy → ask first.
- Player compression method **Default**, not LZ4/LZ4HC: the APK zip deflates Default data, LZ4 output does not (TRG51: 133 MB vs 156 MB). Build Profiles can reset it → set it in the same build call.
- IL2CPP code generation `OptimizeSize` (TRG51 libil2cpp 18.8 → 12.5 MB). Disable splash/Unity logo only on a licence that allows it.

## Gradle / native plugins
- AppsFlyer + AGP 8/9: `NoClassDefFoundError com/appsflyer/api/Store` → add `android.uniquePackageNames=false` to `gradleTemplate.properties`; do not exclude `purchase-connector`.
- Java sources under `Assets/**/Plugins/Android`: ASCII only; write other characters as `\uXXXX` (javac on Windows defaults to windows-1252; emoji/Vietnamese break the build).
- `.androidlib` folders need their own `AndroidManifest.xml` with a unique `package` and `project.properties` (`android.library=true`).

## Builds via Unity MCP
- Run builds synchronously in one `execute_code` call and write the `BuildReport` result to a file; `EditorApplication.delayCall` builds race with domain reloads and get lost.
- Keystore passwords are not persisted across Editor restarts → "Unable to sign" means ask the user to re-enter them; never type or store them yourself.
- `Editor.log` is shared by all open Editors: filter the build report by project path before reading results.

## Ads release checklist (projects using `nts-unity-foundation`)
- `Ads Settings.asset`: real app/unit IDs (no `ca-app-pub-3940256099942544`), `isDebug 0`, `SystemLogs 0`, `testDeviceIds []`.
- InitScene: native unit IDs real, `forceFullAds 0`. AppsFlyer helper `appID` = this game's AdMob app id.
- `AdsLoading.teaBrakeObject = None` hides the "ADS BREAK" popup while keeping `useTeaBrake` waiting for the ad.
- Testing real units: add the device hash to `testDeviceIds` temporarily, never click real ads, remove before the release build. "No fill" (code 3) on emulators is expected, not a bug.
- Define `USE_RATE` decided when the game calls `RateAppUtils.OnRate`; `GameNativeHandle.isPortrait` matches orientation.
- Foundation pointer and `CustomPatchTools/foundation_custom_logic.patch` committed together; `.meta` of new upstream files inside the patch.
- One `ads-latest.aar` only; md5 matches `NTS-Ads-Setup/sdk/VERSIONS.md`.
- Full pre-build list: `NTS-Ads-Setup/checklists/03-pre-build.md`.
- How game code calls ads (directly, no extra guards): `rules/ads-integration.md`.
