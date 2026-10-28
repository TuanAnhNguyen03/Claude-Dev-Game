# AGENTS.md — mẫu cho Codex tại root repo của từng game Unity

> TEMPLATE: copy file này vào root repo game, điền `{{...}}`, rồi xoá dòng này.
> File này dành cho Codex; giữ nguyên `CLAUDE.md` và `.claude/` nếu dự án cũng dùng Claude Code.

## Ngữ cảnh cần đọc

- Game: `{{STT}}_claude.md` trong root repo này. Đọc trước khi sửa code hoặc asset; file này xác định `profile`, `unity_root`, `mcp_instance` và ngoại lệ của game.
- Quy chuẩn chung: `{{SHARED_RULES_PATH}}/CLAUDE.md` và `{{SHARED_RULES_PATH}}/MAP.md`. Điền đường dẫn thật tới repo Claude-Dev-Game (hoặc bản được quản lý cùng repo game). Dùng quy tắc Unity và profile; các bước dành riêng cho Claude Code không phải lệnh Codex.
- Khi sửa file Unity, đọc rule liên quan trong `{{SHARED_RULES_PATH}}/nts_claude_dev/.claude/rules/` theo bảng MAP.md §3. Luôn đọc `evidence.md`; đọc thêm `asset-integrity.md` với `Assets/`, `unity-project.md` với `Assets/`, `Packages/`, `ProjectSettings/`.
- Template trong `{{SHARED_RULES_PATH}}/nts_claude_dev/.claude/templates/` là tài liệu tham khảo, không phải code bắt buộc. Chỉ dùng khi phù hợp kiến trúc và dependency thực tế của game.

## Quy tắc làm việc

- Kiểm tra `ProjectSettings/ProjectVersion.txt`, package và cấu trúc hiện tại trước khi chọn cách sửa. Với profile `Restored` hoặc `Custom`, giữ kiến trúc và các tham chiếu hiện có; mục đánh dấu `(NTS)` chỉ áp dụng cho profile `NTS`.
- Giữ cặp asset/`.meta` và GUID. Kiểm tra scene, prefab, serialized field và Build Settings trước khi đổi tên hoặc di chuyển asset.
- Nếu dùng Unity MCP và có nhiều Editor, xác nhận đúng `mcp_instance` trước mọi thao tác ghi. Không suy ra kết quả Editor từ việc chỉ đọc source.
- Báo rõ mức bằng chứng: source, compile, Play Mode và device build là các phép kiểm tra khác nhau. Ghi `not run` cho bước chưa chạy; dependency thiếu là blocker, không tạo stub để giả pass.
- Không commit, push hoặc publish khi chưa được yêu cầu.

## Ghi chú tương thích

Codex không tự nạp `CLAUDE.md`, `@{{STT}}_claude.md`, glob `paths:` trong `.claude/rules/`, slash command, subagent hay hook từ `.claude/settings.json`. Các mục trên chỉ có hiệu lực khi được đọc và áp dụng rõ ràng. Cấu hình Unity MCP cho Codex cần được kiểm tra riêng; `.mcp.json` hiện là cấu hình của Claude Code.
