# AGENTS.md — entry Codex khi mở chính repo quy chuẩn này

Bộ quy chuẩn làm game Unity dùng chung. Đọc theo thứ tự:

1. `CLAUDE.md` — quy tắc chung, checklist project mới, hard rules, workflow.
2. `MAP.md` — bản đồ: rules→glob, commands, templates, profile (NTS/Restored/Custom), registry project.
3. Nếu đang làm trong repo game, đọc `<stt>_claude.md` của game đó (vd `37_claude.md`) — thông tin riêng game, **ưu tiên cao nhất**.
4. Khi cần, đọc thủ công `nts_claude_dev/.claude/rules/*.md` theo MAP.md §3; luôn đọc `rules/evidence.md` khi làm việc với Unity. Codex không tự nạp glob `paths:` của Claude Code.

Khi mở repo **của một game**, dùng mẫu `nts_claude_dev/AGENTS.md` tại root repo game. File AGENTS.md ở repo này không tự áp dụng cho repo game nằm bên cạnh.

Không commit/push/publish nếu chưa được yêu cầu. Chỉ báo hoàn thành theo đúng bằng chứng (source ≠ compile ≠ Play Mode ≠ device).
