# Trạng thái công cụ trên máy phát triển — 2026-10-06

Đây là ảnh chụp trạng thái cài đặt, không phải danh sách dependency bắt buộc của mọi game. `OBSERVED` là đã kiểm tra trong phiên này; `REPORTED` là thông tin người dùng cung cấp. Skill trong `~/.claude/skills` thuộc môi trường Claude; không mặc nhiên là skill của Codex.

| Công cụ | Trạng thái | Bằng chứng / giới hạn |
|---|---|---|
| Playwright CLI | OBSERVED: đã cài, `playwright-cli --help` chạy được | Dùng cho web/GDD; không phải phép kiểm tra Unity Play Mode. |
| Ponytail | OBSERVED: có 6 thư mục skill (`ponytail`, `ponytail-review`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`) | Nằm trong `C:/Users/ADMIN/.claude/skills/`; chưa xác minh trong Codex. |
| Graphify | OBSERVED: có skill `graphify` và báo cáo `graphify-out/GRAPH_REPORT.md` dưới `Assets/Scripts` của TRG37 | Báo cáo tồn tại; chưa chạy lại lượt quét hoặc xác minh Graphify CLI trong PATH của phiên này. |
| Agent Skills (Anthropic) | REPORTED: đã chép 13 skill; 6 skill trùng được bỏ qua | Chưa đối chiếu danh sách nguồn và từng skill; không diễn giải thành 20 skill mới. |
| ADB (platform-tools) | OBSERVED 2026-10-06: `C:/platform-tools/platform-tools/adb.exe` trên PATH; `adb devices` thấy `emulator-5554` | Có thêm `LDPlayer9/adb.exe` — dùng 1 bản. |
| LDPlayer 9 | OBSERVED: `D:/LDPlayer/LDPlayer9` (có `dnconsole.exe`, `aapt.exe`); thiết bị PJD110, Android 9, x86_64, 1080x1920, 480dpi | Emulator, không thay thế máy Android thật/thấp cấu hình. |
| `adb-device.sh` | OBSERVED: `check`, `shot`, `logcat` chạy được trên LD9 | `install`, `launch`, `perf` chưa chạy (chưa có APK/package). |
| UnityMCP | OBSERVED: server kết nối trong phiên; tool `mcp__UnityMCP__*` có sẵn | Chọn đúng instance trước khi ghi. |
| scrcpy | OBSERVED: chưa cài | Tuỳ chọn: mirror/điều khiển máy thật; không bắt buộc. |
| Android build tools (apkanalyzer/bundletool) | UNKNOWN: chưa kiểm | Tuỳ chọn: đo size APK/AAB. |
| OmniRoute | REPORTED: chưa cài; người dùng khuyên bỏ qua | Không nằm trong quy trình của repo này. |

Skill mới của Claude Code có thể cần mở lại phiên để được nhận diện đầy đủ. Khi dùng Codex, kiểm tra danh sách skill khả dụng trong chính phiên Codex; không suy từ thư mục skill Claude.
