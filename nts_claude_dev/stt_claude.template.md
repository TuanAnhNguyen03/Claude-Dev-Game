# {{STT}}_claude.md — {{GAME_NAME}} (RIÊNG game này)

> TEMPLATE. Đổi tên thành `<stt>_claude.md` (vd `37_claude.md`), điền `{{...}}`, xoá dòng này.
> Import từ `CLAUDE.md` bằng dòng `@{{STT}}_claude.md`.
> Chỉ ghi thứ riêng của game này. Rule/skill chung ở `CLAUDE.md` + `../MAP.md`; không lặp lại.
> Không nới lỏng hard rules chung; ngoại lệ phải ghi rõ + lý do ở mục 5.

profile: {{NTS | Restored | Custom}}   <!-- xem MAP.md §1b; mặc định NTS -->
unity_root: {{thư mục chứa Assets/ + ProjectSettings/}}
mcp_instance: {{Name@hash hoặc tên project — dùng với set_active_instance; port đổi khi restart Editor}}
claudedev_version: {{VERSION của ClaudeDev đã áp, vd 1.1.0}}

## 1. Tổng quan
- Tên / mã: {{GAME_NAME}} ({{STT}})
- Mục tiêu / hypothesis: {{...}}
- Phạm vi (in / out): {{...}}

## 2. Stack & plugin
- Unity `{{UNITY_VERSION}}` · `{{RENDER_PIPELINE}}` · {{PLATFORM}} · {{ORIENTATION}} · {{FPS}} FPS
- Plugin có sẵn: {{DOTween, Easy Save 3, ...}} (thiếu plugin khác → STOP và báo user)

## 3. Kiến trúc riêng
- Assembly / thư mục chính: {{...}}
- Pattern đặc thù: {{...}}
- Nguồn chân lý định danh: {{đường dẫn}}

## 4. Quy ước đặc thù
- Input: {{...}}
- Art style / skill art áp dụng: {{vd tr37-art-style}}
- Save-key prefix: `{{stt}}_`
- Naming / layer / sorting: {{...}}

## 5. Ngoại lệ so với rule chung (nếu có)
| Rule chung | Ngoại lệ | Lý do |
|---|---|---|
| | | |

## 6. Trạng thái hiện tại (cập nhật khi đổi)
- Đã xong: {{...}}
- Đang làm: {{...}}
- Việc tiếp: {{...}}

## 7. Quyết định đã chốt
- {{YYYY-MM-DD}}: {{quyết định}} — {{lý do}}

## Git / release (xem rules/git-release.md, rules/android-build.md)

- repo / nhánh: {{url}} · {{develop → main}}
- submodule dùng chung: {{path @ commit trên remote, vd nts-unity-foundation @ 4f40bb3}} · patch: `CustomPatchTools/foundation_custom_logic.patch` · **không push submodule**
- ads: phase {{chưa cài | đã cài YYYY-MM-DD}} · bảng thời điểm theo `NTS-Ads-Setup/templates/stt_claude.ads-section.md` · `USE_RATE` {{có/không}}
- keystore: {{TRG<stt>.keystore track/không track; alias}} — mật khẩu không lưu repo
- file AI/agent chia sẻ với team: {{không | danh sách}}

## Thiết bị / ADB (điền khi game chạy Android)

- android_package: {{com.company.game}}
- apk_path: {{đường dẫn APK build gần nhất}}
- device_target: {{vd LDPlayer 9 `emulator-5554` (1080x1920, Android 9) — emulator, không thay thế máy thấp cấu hình}}
- Kiểm thử: `/device-test`; script `.claude/scripts/adb-device.sh`; bằng chứng `production/device-evidence/`.
