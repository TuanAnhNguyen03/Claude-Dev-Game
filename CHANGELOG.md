# Changelog

## 1.0.0 — 2026-10-06

Bản đầu tiên.

### Added
- `CLAUDE.md` chung mọi game + `MAP.md` (bản đồ điều hướng, SSOT).
- Quy tắc 2 file mỗi game: `CLAUDE.md` + `<stt>_claude.md`, kèm `stt_claude.template.md`.
- Scaffold `nts_claude_dev/`: 11 rules, 9 commands, subagent `@dev`, 11 templates, 7 hooks, statusline, `settings.json`, `.mcp.json`, skill `unity-mcp`.

### Changed (so với scaffold gốc)
- Path-glob rules chuẩn hoá `Unity/*/Assets/...` → `**/Assets/...`.
- `nts_claude_dev/CLAUDE.md` đổi từ nội dung riêng một game sang template `{{placeholder}}`.

### Known issues (xem MAP.md §7)
- `plan.md` tham chiếu skill `smart-pole-context-analyzer`, `brainstorming` chưa có.
- `publish-gdd.md`, `narrative.md` còn path cứng `Unity/design/...`, `design/narrative/**`.
- `ui-code.md` yêu cầu gamepad, mâu thuẫn với game mobile cảm ứng.
- `prototype-code.md` còn ví dụ riêng một game.
- `unity-mcp` (scaffold) trùng `unity-mcp-skill` (global).
