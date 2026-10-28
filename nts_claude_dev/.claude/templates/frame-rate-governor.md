---
name: frame-rate-governor
purpose: Self-installing FPS governor for Android — tier by RAM/API (Low 30, Mid/High 60), static-screen drop to 30, battery/saver cap, sustained-slow step-down (never steps up), vSync forced off, optional low-tier render resolution cap
when_to_use: Any Android game that does not set Application.targetFrameRate (Android defaults to 30 fps), or needs old phones stable at 30 and new phones at 60 without burning battery
rules_ref: [engine-code, prototype-code, mobile-performance]
tags: [performance, fps, android, tier, battery]
---

## Skeleton
Nguồn đã chạy: TRG51 `Assets/_Project/Scripts/Game/FrameRateGovernor.cs` (không namespace, màn tĩnh = `GameConstants.openPanel`) và TRG42A `Assets/_Game/Scripts/Core/Performance/FrameRateGovernor.cs` (namespace `TRG42.Core`, màn tĩnh = 3 s không chạm). Copy, rồi chỉ sửa **một chỗ**: điều kiện "đang bận" (`IsBusy`).

```csharp
namespace __NAMESPACE__
{
    public sealed class FrameRateGovernor : MonoBehaviour
    {
        public enum Tier { Low, Mid, High }

        private const int FloorFps = 30, StepFps = 15, StaticScreenFps = 30;
        private const float IdleAfter = 1f, WindowSeconds = 2f, SlowRatio = 0.8f, PowerCheckSeconds = 20f;
        private const int SlowWindowsToStepDown = 3, LowTierMaxHeight = 1280;
        private const int LowTierMemoryMb = 2800, MidTierMemoryMb = 5500, LowTierApiLevel = 28;

        public static FrameRateGovernor Instance { get; private set; }
        public static Tier DeviceTier { get; private set; }
        public static int ActiveFps { get; private set; } = 60;

        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
        private static void Install() { /* new GameObject, DontDestroyOnLoad, HideInHierarchy, AddComponent */ }

        public static Tier DetectTier(int ramMb, int api) =>
            ramMb < LowTierMemoryMb || (api > 0 && api < LowTierApiLevel) ? Tier.Low
            : ramMb < MidTierMemoryMb ? Tier.Mid : Tier.High;

        // Awake: tier -> ActiveFps (Low 30, else 60), QualitySettings.vSyncCount = 0, Apply, CapLowTierResolution (Android only).
        // Update: force vSync 0 every frame (quality manager may re-enable it); busy = !IsStaticScreen();
        //         static for >= IdleAfter -> min(StaticScreenFps, ActiveFps); every PowerCheckSeconds check
        //         battery < 15% / Android isPowerSaveMode -> cap 30; measure fps over WindowSeconds while busy,
        //         below SlowRatio * ActiveFps for SlowWindowsToStepDown windows -> tierFps -= StepFps (floor 30), never up.
        // OnApplicationFocus: reset timers (coming back from an ad / home).
        // CapLowTierResolution: Low tier and Screen.height > LowTierMaxHeight -> Screen.SetResolution(scaled, LowTierMaxHeight, true).
        // IsStaticScreen (the one game-specific hook):
        //   physics/ragdoll game  -> GameConstants.openPanel (Home/Mode/Settings); never "no touch" (objects keep moving)
        //   UI/idle game          -> no touch for 3 s
    }
}
```

## Kiểm sau khi cài
- Play Mode: `Application.targetFrameRate == 60` (Editor = High), `QualitySettings.vSyncCount == 0`.
- Bật điều kiện màn tĩnh → sau `IdleAfter` rate = 30; tắt → về 60.
- Bảng tier (unit): 1,5 GB → Low · 3,6 GB → Mid · 8 GB → High · Android 8 → Low.
- Chưa đo trên Android thật = UNKNOWN: pin/nhiệt, ngưỡng RAM của tier, hiệu quả cap độ phân giải. Test máy yếu (≤ 3 GB) + máy mạnh bằng `/device-test`.
