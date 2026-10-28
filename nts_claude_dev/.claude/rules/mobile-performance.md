---
paths:
  - "**/Assets/**/Scripts/**"
  - "**/ProjectSettings/QualitySettings.asset"
  - "**/ProjectSettings/ProjectSettings.asset"
  - "**/ProjectSettings/TimeManager.asset"
---

# Mobile performance — FPS, GC, ổn định (Android)

Rút từ TRG42A (2026-10-20) và TRG51B (2026-10-21). Mục tiêu: không giật, không tụt FPS, không đơ, không crash trên máy yếu; máy mạnh chạy vừa đủ (đỡ nóng/pin). Số đo trong Editor ≠ thiết bị: ghi nhãn OBSERVED/UNKNOWN theo `rules/evidence.md`.

## Bẫy hay gặp (kiểm đầu tiên)
- **Không có `Application.targetFrameRate` → Android chạy 30 fps.** `grep targetFrameRate` toàn `Assets` (gồm foundation); không có = lỗi. Đặt bằng `FrameRateGovernor` (template `frame-rate-governor`), không hardcode 60.
- **vSync bật → Android bỏ qua `targetFrameRate`.** Quality level hay bật lại vSync (foundation `QualityManager`) → governor ép `vSyncCount = 0` mỗi frame.
- **Player Settings Android mặc định chưa tối ưu:** bật `gcIncremental` (cắt đỉnh GC), `mobileMTRendering` Android, `optimizedFramePacing` (Swappy). `stripEngineCode`: chỉ bật khi đã có `link.xml` cho SDK và đã test máy (TRG42A bật; TRG51 chưa).
- **`Maximum Allowed Timestep` mặc định 0,333 s** → frame chậm dồn 16 bước vật lý (xoắn ốc → đơ). Đặt 0,1 s (tối đa 5 bước với Fixed 0,02) cho game dùng physics.
- **Đồ hoạ API:** để Auto (Vulkan + GLES3) có thể crash trên GPU/driver cũ; chốt theo thử máy yếu, ghi vào `<stt>_claude.md`.

## FrameRateGovernor (tier + tiết kiệm + tự hạ)
1. **Tier theo RAM/API:** RAM < 2800 MB hoặc Android < 9 → Low (30 fps, hạ độ phân giải render ≤ 1280 px cao); < 5500 MB → Mid; còn lại High. Mid/High = 60 fps.
2. **Màn tĩnh → 30 fps:** nhận biết bằng điều kiện của game, **không** dùng "không chạm" cho game physics (vật vẫn bay sau khi nhả tay): TRG42A (UI, shelf) = 3 s không chạm; TRG51 (ragdoll) = `GameConstants.openPanel` (Home/Mode/Settings) sau 1 s.
3. **Lưới an toàn:** pin < 15 % hoặc Battery Saver → 30; đo FPS thực mỗi 2 s, dưới 80 % mục tiêu 3 cửa sổ liền → hạ 60 → 45 → 30, **không tự tăng lại** trong phiên (tránh dao động khi máy nóng).
4. Tự cài (`RuntimeInitializeOnLoadMethod`, `BeforeSceneLoad`) để chạy từ màn đầu, trước loading của foundation.

## Hot path (Update/FixedUpdate/LateUpdate, input, spawn)
- `Object.name`, `tag ==`, `string +`, `$""`, `ToString()` **cấp phát chuỗi mỗi lần** trên Android: không đọc trong `FixedUpdate`; cache khi chọn (VD `forcePoint.selectedIsHand`).
- Raycast UI (`EventSystem.RaycastAll`) mỗi `FixedUpdate` khi kéo: memo theo `Time.frameCount` (FixedUpdate chạy nhiều lần mỗi frame). Tái dùng `PointerEventData` + `List<RaycastResult>`.
- Không `Find*`/`GetComponent*`/`Camera.main`/LINQ/`new` trong vòng lặp mỗi frame; `Physics.OverlapSphere` → bản `NonAlloc` nếu gọi thường xuyên.
- **Màn ẩn không được tốn CPU:** `Update` kiểm `IsOpen`/`canvas.enabled`; một Canvas dùng chung chứa nhiều màn → tách sub-Canvas, màn ẩn tắt `Canvas` (không chỉ alpha = 0). Animator trang trí (sparkle, float, wobble) dừng khi Canvas tắt.
- Soft-body/mô phỏng riêng: cho "ngủ" khi đứng yên, không `SetVerticesDirty` vô điều kiện.
- Tween/coroutine/event: kill ở `OnDisable`/`OnDestroy`; tween dùng `SetUpdate(true)` nếu chạy lúc `timeScale = 0` (Settings/Pause).
- Pool vật lặp lại (AudioSource xoay vòng thay vì `AddComponent`/`Destroy` mỗi lần, hạt, mảnh vỡ).

## Quy trình audit (read-only trước, sửa sau)
1. `grep` các bẫy ở trên + `ProjectSettings` (TimeManager, QualitySettings, Android player).
2. Quét `Update/FixedUpdate/LateUpdate` tìm Find/GetComponent/`new`/LINQ/chuỗi; **đếm số scene/prefab dùng script đó** (GUID) — bỏ qua demo/vendor không nằm trong scene (TRG51: `forcePoint` có trong 420 scene; `CameraMovement`, `ETFX*`, `fan`, `MeshExplosion`… 0 scene).
3. Xếp theo tác động (script chạy ở mọi level trước); sửa tối thiểu, giữ field serialize.
4. Verify trong Editor: compile 0 lỗi, Play Mode đọc `Application.targetFrameRate`/tier, đổi trạng thái màn tĩnh → rate đổi; **ghi rõ chưa đo trên máy thật**, rồi chạy `/device-test` trên máy yếu + máy mạnh.

## Cấm
- Đặt `targetFrameRate` cố định rải rác (mỗi màn một giá trị) — chỉ governor được ghi.
- Mở khoá FPS cao hơn tier để "mượt hơn" khi chưa đo nhiệt/pin.
- Đổi `Fixed Timestep`/solver iterations của physics khi chưa so cảm giác chơi (đổi cảm giác game).
