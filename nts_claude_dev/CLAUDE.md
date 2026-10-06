# {{GAME_NAME}} — Unity Mobile

> TEMPLATE project CLAUDE.md. Copy vào root workspace của game, điền `{{...}}`, xoá dòng này.
> Bản đồ + thứ tự đọc + rules/commands/templates: `../MAP.md` (workspace `ClaudeDev/`). **Không lặp lại bảng ở đây.**
> Thông tin riêng của game CHỈ ghi trong file này.

## Stack

- **Unity**: `{{UNITY_VERSION}}` (`{{RENDER_PIPELINE}}`) — xem `{{PATH}}/ProjectSettings/ProjectVersion.txt`
- **Build target**: {{PLATFORM}} ({{ORIENTATION}}, {{FPS}} FPS)
- **Input**: {{INPUT_SYSTEM}}
- **Host OS**: Windows 11 + PowerShell (`$null`, `$env:VAR`, backtick). Bash qua Bash tool cho POSIX script.

## Layout

| Path | Purpose |
|------|---------|
| `{{UNITY_PROJECT_PATH}}/` | Unity project (Library/Temp/UserSettings ignore) |
| [.claude/rules/](.claude/rules/) | Code rules theo path-glob — **luôn reference, không inline** |
| [.claude/skills/unity-mcp/](.claude/skills/unity-mcp/) | Quy trình MCP For Unity |
| [.claude/agents/dev.md](.claude/agents/dev.md) | Subagent `@dev` (extract template + code feature) |
| [.claude/templates/](.claude/templates/) | Skeleton tái dùng |
| [.claude/commands/](.claude/commands/) | Slash commands |
| `brain/` | Working state theo task: `task.md` + `implementation_plan.md` + `walkthrough.md` |
| `production/session-*` | Output hook (ignored) |

## Workflow

`/plan` → duyệt → `/execute` → `/review` → `/commit` → `/finish` (+ `/debug`, `/blueprint`, `/teach`, `/publish-gdd`). Chi tiết: MAP.md §4.
Layer order: Data → Core Logic → Gameplay/UI → Tests. Code dưới `Scripts/{UI,Gameplay,Core,AI,Networking}` qua `@dev` Mode B.
**Commit/push chỉ khi user yêu cầu.**

## MCP

UnityMCP đăng ký ở [.mcp.json](.mcp.json) (`http://127.0.0.1:8080/mcp`). Cần Unity Editor mở + MCP server chạy.

## Riêng game này

Mọi thông tin riêng game (mục tiêu, phạm vi, plugin, quy ước, kiến trúc, trạng thái) nằm ở file riêng, tạo từ [stt_claude.template.md](stt_claude.template.md):

@{{STT}}_claude.md

File này (CLAUDE.md) giữ chung cho mọi game: áp dụng toàn bộ rule + skill trong ClaudeDev.

## Personal overrides

Ghi chú cá nhân (không share team) → `CLAUDE.local.md` (đã trong `.gitignore`).
