# Claude-Dev-Game

> Bộ **scaffold + quy chuẩn làm việc với Claude Code** dùng chung cho mọi game Unity mobile. **Version 1.0.0** · Private.

## Mục đích

Khi làm nhiều game Unity, mỗi lần mở project mới lại phải dạy lại AI: code theo luật nào, workflow ra sao, dùng skill nào, thông tin game để ở đâu. Repo này đóng gói tất cả thành một bộ có thể **copy vào bất kỳ project nào** để Claude:

- tuân thủ cùng một bộ rule code production (zero-alloc, event lifecycle, persistence wrapper, build-ready Android...),
- đi theo cùng một workflow (`/plan → /execute → /review → /commit → /finish`),
- biết rõ đọc file nào trước, ai thắng khi xung đột (qua `MAP.md`),
- tách bạch **luật chung** và **thông tin riêng từng game**.

Không chứa code game, asset hay thông tin riêng của một game cụ thể.

## Tính năng

| # | Thành phần | Mô tả |
|---|---|---|
| 1 | **`CLAUDE.md`** (entry chung) | Checklist áp dụng vào project mới, danh sách skill/tool global, hard rules, workflow, quy ước hierarchy & render order Unity |
| 2 | **`MAP.md`** (bản đồ, SSOT) | Thứ tự đọc 6 tầng, cây thư mục, bảng rule→glob, sơ đồ workflow, bảng template→rules_ref→plugin, bảng "việc nào dùng skill nào", danh sách điểm chưa thống nhất |
| 3 | **Quy tắc 2 file mỗi game** | `CLAUDE.md` (chung, áp dụng toàn bộ rule+skill) + `<stt>_claude.md` (riêng, vd `37_claude.md`, import bằng `@37_claude.md`) |
| 4 | **11 rules** (`.claude/rules/`) | Tự nạp theo path-glob `**/Assets/...`: prototype/engine/gameplay/ui/ai/network/tests/data/shader/design-docs/narrative |
| 5 | **9 slash command** (`.claude/commands/`) | `/blueprint` `/plan` `/execute` `/review` `/commit` `/finish` `/debug` `/teach` `/publish-gdd` |
| 6 | **Subagent `@dev`** | Senior Unity dev: Mode A trích template từ code (kèm báo drift), Mode B code feature theo template → rules → convention; có quyền `mcp__UnityMCP__*` |
| 7 | **11 templates** (`.claude/templates/`) | Singleton base, game-state-machine, sound-manager, platform-haptic, data-asset-scriptable, data-manager-orchestrator, user-data-persistence, menu-manager, dialog-pooled, ui-anim-base, gdd-sheet-page |
| 8 | **7 hook + statusline** | session-start/stop, pre/post-compact, notify, log-agent (log subagent), statusline |
| 9 | **`settings.json`** | Allow/deny quyền an toàn (chặn `rm -rf`, force-push, reset --hard, đọc `.env`) + đăng ký hook |
| 10 | **`.mcp.json`** | Kết nối UnityMCP `http://127.0.0.1:8080/mcp` |
| 11 | **Skill `unity-mcp`** | Quy trình làm việc với MCP For Unity |
| 12 | **Templates file Claude** | `nts_claude_dev/CLAUDE.md` (chung) và `stt_claude.template.md` (riêng game) |

## Skill/tool global đi kèm quy trình (cài riêng, không nằm trong repo)

`unity-mcp-skill`, `unity-mobile-arch`, `ponytail` (+review/audit), `graphify` (đồ thị code), `webapp-testing`/`playwright-cli` (chỉ web/GDD), `frontend-design`... — bảng đầy đủ ở `CLAUDE.md` mục 3 và `MAP.md` mục 6.

## Cách dùng cho game mới

1. Copy `nts_claude_dev/.claude/` + `nts_claude_dev/.mcp.json` vào root workspace của game.
2. Tạo `CLAUDE.md` từ `nts_claude_dev/CLAUDE.md` (điền Stack/Layout, thêm dòng `@<stt>_claude.md`).
3. Tạo `<stt>_claude.md` từ `nts_claude_dev/stt_claude.template.md` (vd `37_claude.md`).
4. Mở Unity Editor, bật MCP server, thử `ping`.
5. (Tuỳ chọn) `graphify update Assets/Scripts`.

Thứ tự ưu tiên khi xung đột: `<stt>_claude.md` > `CLAUDE.md` project > rules > ClaudeDev > global.

## Cấu trúc

```
Claude-Dev-Game/
├─ CLAUDE.md
├─ MAP.md
├─ README.md · CHANGELOG.md · VERSION
└─ nts_claude_dev/
   ├─ CLAUDE.md · stt_claude.template.md · .mcp.json · .gitignore
   └─ .claude/ { settings.json, statusline.sh, rules/, commands/, agents/, templates/, hooks/, skills/ }
```

## Lưu ý

- Hook dùng `bash` (Git Bash trên Windows). Môi trường mặc định: Windows 11 + PowerShell.
- Một số đường dẫn trong `CLAUDE.md` trỏ tới máy cá nhân (`C:\Users\ADMIN\.claude\...`); chỉnh khi dùng trên máy khác.
- Điểm còn mở của v1.0.0 xem `MAP.md` mục 7 và `CHANGELOG.md`.
