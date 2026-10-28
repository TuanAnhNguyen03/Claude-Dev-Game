# Changelog

## 1.5.0 — 2026-10-28

Tối ưu context/token (audit phiên TRG37: Messages 365k, 2 Unity MCP trùng).

### Added
- `rules/token-discipline.md` (luôn nạp): trả lời ngắn data-only, đọc hẹp, MCP phân trang, ảnh scale ≤0.5, log dài ra file, lịch sử/trạng thái ra docs đọc khi cần, chỉ 1 Unity MCP, phiên mới giữa task.
- `templates/output-style-terse.md`: output style tiếng Việt ngắn gọn.

### Changed
- `MAP.md` §3: thêm dòng `token-discipline.md`.

## 1.4.0 — 2026-10-26

Bài học đồng bộ biến thể TRG42A/B/C (port 42B→42C, 42C→42A) và tiết kiệm token.

### Added
- `rules/variant-port.md`: identity list không ghi đè, phân loại file bằng `comm`/`diff --strip-trailing-cr`, 3-way merge theo base clone, submodule dùng chung (code theo upstream, asset/ID giữ của đích), copy asset kèm meta + bẫy re-guid, dòng sản phẩm bằng field data (không theo index), chạy lại EconomySim khi thêm pack, quy tắc token (digest transcript, không in list dài, không gen lời thoại).

### Changed
- `MAP.md` §3: thêm dòng `variant-port.md`.

## 1.3.0 — 2026-10-21

Bài học hiệu năng từ TRG42A (2026-10-20) và TRG51B (2026-10-21): game không đặt `targetFrameRate` chạy 30 fps trên Android.

### Added
- `rules/mobile-performance.md` (glob `Scripts/**`, `ProjectSettings/{Quality,Time,Project}Settings.asset`): bẫy FPS/vSync, Player Settings Android (gcIncremental, mobileMTRendering, Swappy), `Maximum Allowed Timestep` 0,1, quy tắc hot path (không đọc `Object.name`/chuỗi trong `FixedUpdate`, memo raycast UI theo frame, màn ẩn không tốn CPU), quy trình audit (đếm scene dùng script để bỏ qua demo/vendor), cấm đặt FPS rải rác.
- `templates/frame-rate-governor.md`: governor tự cài — tier RAM/API (Low 30 + cap 1280 px, Mid/High 60), màn tĩnh → 30 fps, pin < 15 %/Battery Saver → 30, tự hạ 60→45→30 khi dưới 80 % mục tiêu (không tự tăng), ép vSync 0. Một điểm tuỳ game: điều kiện "màn tĩnh" (UI: 3 s không chạm; physics: panel mở, không dùng "không chạm").

### Changed
- `CLAUDE.md` §5 hard rule hiệu năng Android; `MAP.md` §2 (rules 19, templates 13), §3, §5.

### Evidence (TRG51B, Editor)
- Governor: tier High → 60; `openPanel` bật → 30 sau 1 s, tắt → 60; vSync 0; Console 0 lỗi. **Chưa đo trên Android thật** (pin, nhiệt, ngưỡng RAM tier, cap độ phân giải).

## 1.2.0 — 2026-10-13

Tách bộ chuẩn ads ra kit riêng `D:\1.Game_UNITY\4.SkillDev\NTS-Ads-Setup` (skill `nts-ads-setup`), rút từ TRG51/TRG54.

### Changed
- Ads/SDK là **phase cuối**: chỉ làm sau khi game xong và user xác nhận (`CLAUDE.md` §2 bước 8, `rules/ads-integration.md`, `/blueprint`, `/plan`, `/execute`).
- `rules/ads-integration.md`: vào level = banner **hoặc** collab theo `<stt>_claude.md` (bỏ mặc định collab); `AdShowDelay`; RateAppUtils/`USE_RATE`; reset `adBusy` khi focus (reward offline không callback).
- `rules/android-build.md`: kiểm `USE_RATE`, `isPortrait`, pointer+patch cùng commit, 1 aar đúng md5.
- `MAP.md` §6, `stt_claude.template.md`: trỏ kit + mục ads.

## 1.1.0 — 2026-10-08

Bài học từ release TRG51 v1.0.0 (ads NTS foundation, build Android, bàn giao repo). Nâng cấp project đang có: `CLAUDE.md` §2.2.

### Added
- `rules/git-release.md` (luôn nạp): không `git checkout` khi Editor mở (`git fetch . a:b`), không push submodule dùng chung — lưu sửa riêng ở `CustomPatchTools/*.patch`, pointer phải có trên remote, danh sách được/không được track, meta mồ côi, kiểm tra trước push (LFS, SHA).
- `rules/android-build.md`: ASTC, compression Default (LZ4 làm APK to hơn: 156 → 133 MB), IL2CPP OptimizeSize, `android.uniquePackageNames=false` (AppsFlyer `NoClassDefFoundError`), Java ASCII + `\uXXXX`, build MCP đồng bộ, keystore, checklist ads release cho `nts-unity-foundation` (isDebug, testDeviceIds, forceFullAds, teaBrakeObject, ID thật).
- `rules/ads-integration.md`: gọi ads thẳng qua `GameNativeHandle`/`AdsManager`/`NativeAdBridge`, một dòng mỗi thời điểm (level start/win, nút reward, MREC panel), logic tiếp tục trong callback; cấm guard trùng foundation (Ready, internet, organic, cap) và chuỗi inter→reward (TRG51: guard thừa gây sai logic).
- `rules/ads-integration.md` (+ glob `**/ScStatic.cs`): `ScStatic.LevelCurrent`/`LevelLog` là property chỉ-đọc từ save level thật của game; game không có level → biến đếm số lần start game; collection mini-game → level theo từng game (`ILevelProgress` / `mg.starts.<id>`); đổi nghĩa level phải báo ảnh hưởng ad gate (TRG37).
- `/commit`: bước 1b hygiene gate (file AI, file tự sinh, meta mồ côi, submodule pointer, secret) và bước 7 merge/push an toàn.
- `skills/unity-mcp`: mục nhiều Editor — port/hash đổi khi restart, resolve theo tên project từ `~/.unity-mcp/unity-mcp-status-*.json`; screenshot `Assets/Screenshots/` phải xoá; kiểm preset Game View.
- `stt_claude.template.md`: `claudedev_version`, mục Git / release.
- `CLAUDE.md` §2.2 quy trình nâng cấp project đang có; hard rules Git + Android build.

### Changed
- `nts_claude_dev/.gitignore`: bỏ `*.mdb` (DOTween track `.mdb.meta` → meta mồ côi); thêm khối file tự sinh (`GeneratedLocalRepo`, `FirebaseCrashlytics.androidlib`, `_Recovery`, `Screenshots`, installer settings, `*.orig`, `*.rej`).
- `skills/unity-mcp`: bỏ path cứng TR37 (`D:\Project_unity\...`), ràng buộc code theo profile.
- `/finish`, `/review`, `/debug`, `/plan`: bỏ `.agents/`, `GEMINI.md`, FAISS/Antigravity → `<stt>_claude.md`, scaffold (hỏi user), `.claude/learned/`.
- `design-docs.md`, `/blueprint`: ads/analytics OUT mặc định, IN khi project có ads stack.
- MAP.md: §3 thêm 3 rule (15 → 18), §7 đóng #11, thêm #12–13, §8 cập nhật TRG51.

### Included from earlier Unreleased

#### Added
- Device testing: `rules/device-testing.md`, `commands/device-test.md`, `scripts/adb-device.sh` (ADB + LDPlayer 9; kiểm `check`/`shot`/`logcat` trên LD9 ngày 2026-10-06), `qa` trỏ về đó, allowlist ADB chỉ-đọc trong `settings.json`.
- Task Intake Contract (`CLAUDE.md` §7b) + hook `UserPromptSubmit` `task-intake.sh` nhắc quy trình mỗi prompt.
- `stt_claude.template.md`: mục Thiết bị/ADB; `.gitignore`: `production/device-evidence/`.
- Mẫu `nts_claude_dev/AGENTS.md` cho Codex tại root repo từng game; tham chiếu quy chuẩn chung, rule Unity và file riêng game mà không dựa vào cơ chế tự nạp của Claude Code.
- `TOOLING_STATUS.md` ghi trạng thái công cụ ngày 2026-10-06 với nhãn OBSERVED/REPORTED; ghi rõ 13 Agent Skills đã chép theo báo cáo (6 bản trùng được bỏ qua, không tính là 20 skill mới).

#### Changed
- Làm rõ phạm vi `AGENTS.md` của repo quy chuẩn và hướng dẫn cài Codex trong README/MAP.

## 1.0.1 — 2026-10-06

Tối ưu sau khi quét workspace `2.TRG` (4 project: TRG24, TRG37, TRG42, TRG51).

### Added
- **Profile** `NTS` / `Restored` / `Custom` (MAP.md §1b): TRG51 (project phục hồi) tự khai báo "không áp kiến trúc NTS", TRG42 dùng kiến trúc riêng → rules không còn áp cứng NTS lên mọi game.
- Rules: `asset-integrity`, `unity-project` (tổng quát hoá từ TRG51), `evidence` (luôn nạp; nhãn OBSERVED/REPORTED/PROPOSED/UNKNOWN từ TRG42; `set_active_instance` khi mở nhiều Editor).
- Agents: `reviewer` (chỉ đọc), `qa` (xác minh Editor), tổng quát hoá từ TRG51.
- Template `mono-behaviour`.
- `AGENTS.md` cho agent ngoài Claude Code (TRG42 đang dùng).
- MAP.md §8 Registry project + việc cần làm để từng project theo chuẩn.
- `stt_claude.template.md`: thêm `profile`, `unity_root`, `mcp_instance`.

### Changed
- `prototype-code.md`: gắn nhãn `(NTS profile)` cho SaveManager/Log; bỏ ví dụ riêng một game.
- `ui-code.md`: input theo profile/`<stt>_claude.md`, mặc định touch-first (bỏ yêu cầu gamepad cứng).
- `plan.md`: skill `smart-pole-context-analyzer`/`brainstorming` là tuỳ chọn; thiếu thì áp dụng thủ công, không claim đã chạy (TRG42 cũng gặp lỗi này).
- `narrative.md`: glob `**/design/narrative/**`.
- `CLAUDE.md`: hard rules phân biệt `(NTS)`; checklist thêm `set_active_instance`.

### Still open
- `publish-gdd.md` còn path cứng `Unity/design/gdd/gdd-sheet/...`.
- `unity-mcp` (scaffold) trùng `unity-mcp-skill` (global).
- Chưa tạo `CLAUDE.md` + `<stt>_claude.md` cho 4 project (MAP.md §8).

## 1.0.0 — 2026-10-06

Bản đầu tiên.

### Added
- `CLAUDE.md` chung mọi game + `MAP.md` (bản đồ điều hướng, SSOT).
- Quy tắc 2 file mỗi game: `CLAUDE.md` + `<stt>_claude.md`, kèm `stt_claude.template.md`.
- Scaffold `nts_claude_dev/`: 11 rules, 9 commands, subagent `@dev`, 11 templates, 7 hooks, statusline, `settings.json`, `.mcp.json`, skill `unity-mcp`.

### Changed (so với scaffold gốc)
- Path-glob rules chuẩn hoá `Unity/*/Assets/...` → `**/Assets/...`.
- `nts_claude_dev/CLAUDE.md` đổi từ nội dung riêng một game sang template `{{placeholder}}`.

### Known issues at release (đã xử lý ở 1.0.1 trừ 2 mục cuối còn mở)
- `plan.md` tham chiếu skill chưa có; `ui-code.md` gamepad cứng; `prototype-code.md` ví dụ riêng game; `narrative.md` path cứng.
- `publish-gdd.md` path cứng `Unity/design/...`; `unity-mcp` trùng `unity-mcp-skill`.
