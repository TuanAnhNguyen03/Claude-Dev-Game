# Variant port (A ↔ B ↔ C clones of one game) — load when syncing features between sibling projects

Rút từ TRG42A/B/C (2026-10-14 → 10-26). Áp dụng khi "mang tính năng/thay đổi từ X sang Y".

## Trước khi sửa
- Lập **identity list** của đích (không bao giờ ghi đè): productName, package id, version/code, icon, ad/MMP/Firebase ID, `Ads Settings.asset`, InitScene/Splash/AdsLoading prefab, notification art, Java `package`, keystore. Ghi vào `<stt>_claude.md`.
- Phân loại file bằng script, không đọc tay: `comm` danh sách file (only-src / only-dst / both-diff + số dòng khác, `diff --strip-trailing-cr`). Đọc diff chỉ cho file both-diff có logic riêng của đích.
- Tìm base chung (commit clone) để 3-way merge (`git merge-file dst base src`). Không có base → so với bản thứ ba (vd 42B) để biết bên nào là "fix", bên nào là "riêng".
- Submodule dùng chung (nts-unity-foundation): code `.cs/.java/.asmdef` theo upstream mới nhất + fix của anh em; **asset/prefab/scene/ID giữ của đích**. Clone submodule vào scratch để fetch/so sánh, không fetch trong repo của game khác.

## Khi copy asset
- Copy kèm `.meta` để giữ GUID. Nếu đích còn bản cũ cùng GUID ở path khác → Unity re-guid bản mới: xoá/move bản cũ trước, hoặc khôi phục meta từ nguồn.
- Prefab/scene của nguồn tham chiếu art của nguồn: liệt kê GUID thiếu (`AssetDatabase.GetDependencies` / grep `guid:`) và copy đủ art trước khi mở prefab.
- Editor đang mở: copy file rồi `refresh_unity`; không `git checkout` (xem git-release.md).
- **GUID trùng nhưng khác nghĩa**: bản clone có thể tái dùng GUID của art khác (42C dùng GUID art cơm nắm 42A cho pack bánh bao). Trước khi copy prefab: join bảng GUID hai bên, lọc cặp khác thư mục/khác loại, lập bảng remap theo tên file và thay `guid:` trong YAML khi copy; file không có đối ứng → GUID mới.
- Play khi máy khoá màn hình: Editor không chạy frame → `EditorApplication.Step()` trong execute_code + `ScreenCapture`.

## Dòng sản phẩm / catalog
- Không suy dòng sản phẩm từ index catalog (`i < 8`) — thêm field trên data asset (`line`) và một helper tra cứu; mọi màn (Home, Collection, Trade, Market, Inventory, quest) đọc từ đó.
- Thêm pack → chạy lại EconomySim (nếu có) và ghi bảng giá trước/sau vào Docs.

## Token
- Đọc transcript session cũ bằng script digest (chỉ text user + câu trả lời > 200 ký tự), không mở jsonl.
- Không in danh sách dài (>50 dòng) ra context: ghi file scratch rồi `grep`/`head`.
- Không gen lời thoại/giải thích thừa; báo cáo dạng data (file:line, số liệu, pass/fail).
