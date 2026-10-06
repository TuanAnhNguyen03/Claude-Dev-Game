# Changelog

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
