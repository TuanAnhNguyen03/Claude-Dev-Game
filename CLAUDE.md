# CLAUDE.md — ClaudeDev · Bộ skill & scaffold dùng chung cho MỌI game Unity

> **Phạm vi:** áp dụng cho tất cả project game Unity (mobile 2D/3D, hyper-casual, mini-game collection...).
> KHÔNG chứa thông tin riêng của một game. Thông tin riêng (tên game, danh mục, trạng thái, asset nguồn)
> đặt trong `CLAUDE.md` của chính project đó; file này chỉ định nghĩa **cách làm việc chung**.
>
> **Đọc [MAP.md](MAP.md) ngay sau file này** — bản đồ thư mục, rules→glob, commands, templates, skill, thứ tự đọc, điểm chưa thống nhất. Bảng chi tiết chỉ nằm ở MAP.md (không lặp ở đây).
> Bản cũ (nội dung riêng TR37) đã backup: `CLAUDE.md.bak-20261006` (không đọc/nạp).

## 1. Cấu trúc bộ ClaudeDev

| Thành phần | Vị trí | Vai trò |
|---|---|---|
| Scaffold Claude | `nts_claude_dev/.claude/` | Copy vào mỗi project: `rules/`, `commands/`, `agents/`, `templates/`, `hooks/`, `skills/`, `settings.json`, `statusline.sh` |
| MCP Unity | `nts_claude_dev/.mcp.json` | UnityMCP `http://127.0.0.1:8080/mcp` (cần Editor mở + MCP server chạy) |
| CLAUDE.md mẫu | `nts_claude_dev/CLAUDE.md` | Mẫu CLAUDE.md cho project (sửa Stack/Layout theo game) |
| Skill global | `C:\Users\ADMIN\.claude\skills\` | Nạp tự động ở mọi project (xem mục 3) |
| Hướng dẫn chung | `C:\Users\ADMIN\.claude\CLAUDE.md` | Phong cách làm việc + quy tắc hierarchy/render order Unity |

## 2. Áp dụng vào một project mới (checklist)

1. Copy `nts_claude_dev/.claude/` + `.mcp.json` vào root workspace của project (chỗ chứa thư mục Unity).
2. Tạo `CLAUDE.md` của project từ `nts_claude_dev/CLAUDE.md`: sửa **Stack** (Unity version, RP, platform), **Layout** (đường dẫn thật). Thông tin riêng của game chỉ ghi ở đây.
3. Path-glob trong rules đã chuẩn hoá `**/Assets/...` (khớp cả Unity ở root lẫn lồng thư mục). Còn cứng: `design/narrative/**`, `Unity/design/...` trong `publish-gdd` — xem MAP.md §7.
4. Mở Unity Editor, bật MCP server (cổng khớp `.mcp.json`) → `set_active_instance` đúng project (có thể đang mở nhiều Editor) → thử `ping`.
5. (Tuỳ chọn) `graphify update Assets/Scripts` để có đồ thị code; `graphify hook install` để tự cập nhật theo commit.
6. Đảm bảo `.gitignore` bỏ qua `CLAUDE.local.md`, `.claude/settings.local.json`, log hook, `graphify-out/` (hoặc đặt output ngoài `Assets`).

### 2.1 Mỗi game mới = 2 file Claude (BẮT BUỘC)

| File | Vai trò | Chứa |
|---|---|---|
| `CLAUDE.md` | **Chung**: áp dụng TẤT CẢ rule + skill trong ClaudeDev | Stack, Layout, Workflow, trỏ về `MAP.md`; dòng import `@<stt>_claude.md`. Không chứa thông tin riêng game |
| `<stt>_claude.md` (vd `37_claude.md`, `36_claude.md`) | **Riêng**: tập trung vào đúng game/project đó | `profile` (NTS/Restored/Custom — MAP.md §1b), `unity_root`, `mcp_instance`, mô tả & mục tiêu, danh mục/phạm vi, plugin có sẵn, quy ước đặc thù (input, art style, asmdef, save-key prefix), kiến trúc riêng, trạng thái hiện tại, quyết định đã chốt |

Quy ước:
- `<stt>` = số thứ tự project (TRG37 → `37_claude.md`). Đặt cạnh `CLAUDE.md` ở root workspace của game.
- `CLAUDE.md` nạp file riêng bằng dòng `@<stt>_claude.md` (vd `@37_claude.md`) để tự vào context.
- Tạo từ template: `nts_claude_dev/CLAUDE.md` (chung) và `nts_claude_dev/stt_claude.template.md` (riêng); đổi tên `stt` thành số thật.
- Skill riêng của game (art style, kiến trúc đặc thù) chỉ được nhắc trong `<stt>_claude.md`, không trong `CLAUDE.md`.
- Quy tắc riêng game **không** được nới lỏng hard rules chung; nếu cần ngoại lệ, ghi rõ ngoại lệ + lý do trong `<stt>_claude.md`.
- Trạng thái/tiến độ chỉ cập nhật ở `<stt>_claude.md`.

Khi có xung đột: **`<stt>_claude.md` > rule/skill của project > scaffold ClaudeDev > skill global**. Không sửa global để phục vụ riêng một game.

## 3. Skill & tool global (áp dụng mọi game)

| Nhóm | Skill / tool | Dùng khi |
|---|---|---|
| Unity | `unity-mcp-skill` (global) · `unity-mcp` (scaffold) | Thao tác Editor qua MCP: scene, prefab, component, script, console, test, screenshot |
| Unity | `unity-mobile-arch` | Kiến trúc mobile (asmdef, singleton, pooling, DI), local multiplayer, save, UI layering, tối ưu hiệu năng, build APK |
| Art | `tr37-art-style` | **Chỉ** khi game dùng style FLAT/PPU 160 của TR37; game khác dùng art-style riêng của project |
| Code | `ponytail` (+ `-review`, `-audit`, `-debt`, `-gain`, `-help`) | Mọi task code. Ladder: có cần tồn tại không → đã có trong codebase → stdlib → platform native → dependency sẵn có → 1 dòng → code mới tối thiểu. `-review` trước commit, `-audit` định kỳ |
| Hiểu code | `graphify` (CLI `graphify update/query/path/explain`) | Câu hỏi kiến trúc/quan hệ file: đọc `graphify-out/GRAPH_REPORT.md` trước khi grep rộng. Chạy lại `update` sau khi sửa code |
| Web/GDD | `webapp-testing`, `playwright-cli`, `frontend-design`, `web-artifacts-builder` | Chỉ cho HTML/GDD sheet/artifact — **không** dùng test game Unity |
| Tài liệu | `doc-coauthoring`, `canvas-design`, `theme-factory`, `internal-comms` | Theo mô tả skill |
| Tạo tool | `mcp-builder`, `skill-creator` | Khi cần tự dựng MCP/skill mới |

Không dùng: OmniRoute (proxy giữ API key, không cần cho quy trình này).

## 4. Rules auto-load theo path-glob — `.claude/rules/`

Bảng rule → glob → nội dung: **[MAP.md §3](MAP.md)** (không lặp ở đây). Rule tự nạp khi file đang làm khớp glob `paths:`. **Tham chiếu, không chép nội dung đi nơi khác.**

## 5. Hard rules chung (cross-cutting, chi tiết ở rules)

> Mục gắn `(NTS)` chỉ áp cho project profile `NTS`; project `Restored`/`Custom` giữ cấu trúc hiện có (MAP.md §1b). `rules/evidence.md` (nhãn bằng chứng, báo cáo trung thực) áp dụng mọi profile.

- `[SerializeField] private`, không `public` field cho Inspector.
- Không `Find*`/`GetComponent` trong `Update`/`FixedUpdate` — cache ở `Awake`. Hot path **zero-alloc** (pool, reuse, không LINQ/`new`).
- Subscribe `OnEnable`, unsubscribe `OnDisable`/`OnDestroy`, kill tween. Subscribe event của singleton khác: `TrySubscribe()` idempotent, gọi ở **cả** `OnEnable` lẫn `Start`.
- (NTS) Persistence chỉ qua wrapper `Core/SaveManager`. Log chỉ qua `Core/Log` (`[Conditional("UNITY_EDITOR")]`).
- Giữ `.meta`/GUID; không đổi tên class/field/asset path đã có khi chưa kiểm tra tác động (`rules/asset-integrity.md`).
- Không `using UnityEditor` trong code runtime (Gameplay/UI/MiniGames). Phải build được Android.
- Không coroutine-as-lifecycle (`IEnumerator Start()`); dùng `void Start()` + named routine.
- Plugin bên thứ ba thiếu → **STOP và báo user**, không stub/reimplement. Lưu ý asmdef cần ref riêng.
- Mọi UI screen có đường quay lại (không dead-end).

## 6. Workflow chuẩn (mọi game)

`/plan` → (user duyệt) → `/execute` → `/review` → `/commit` → `/finish`; thêm `/debug`, `/blueprint`, `/teach`, `/publish-gdd`.

- **/plan:** thu thập SMART POLE (Aim + Outline bắt buộc, thiếu thì hỏi) → nghiên cứu codebase → `task.md` + `implementation_plan.md` trong `brain/<task>/` → tự review → dừng chờ duyệt.
- **/execute:** thứ tự **Data → Core Logic → Gameplay/UI → Tests**; save `task.md` sau mỗi layer để khôi phục khi gián đoạn. File dưới `Scripts/{UI,Gameplay,Core,AI,Networking}` **bắt buộc** qua subagent `@dev` Mode B.
- **@dev:** Mode A trích template từ code vào `.claude/templates/` (kèm báo drift); Mode B code feature theo template → rules → convention; có quyền `mcp__UnityMCP__*`.
- **Templates:** bảng template → rules_ref → plugin yêu cầu ở [MAP.md §5](MAP.md).
- **Commit/push chỉ khi user yêu cầu.** Conventional Commits, chờ user chọn trước khi push. Chạy `/review` trước.

## 7. Quy ước Unity bổ sung (từ CLAUDE.md global)

- Scene root: `Main Camera`, bootstrap, shared services; 1 game root có tên rõ ràng gắn controller.
- Nhóm prefab theo ownership: `Environment`, `Gameplay/Board`, `Gameplay/PieceTray`, `HUD/{Header,Actions,Overlays}`, `VisualFX`. Grouping transform đặt pos 0 / rot 0 / scale 1; builder editor phải idempotent.
- Khai báo Sorting Layers có tên + bảng order nhỏ; physics layer tách riêng, chỉ thêm khi cần.
- Sau khi restructure: kiểm tra prefab reference, scene instance, render order, chụp Game View ở Play mode (dùng Unity MCP).

## 8. Quy tắc làm việc với Claude

- Trả lời ngắn, dạng dữ liệu (file:line, giá trị, pass/fail); chỉ giải thích khi được hỏi.
- Trước khi viết code: leo ladder ponytail; đọc code hiện có, không giả định.
- Hỏi trước khi thao tác khó hoàn tác hoặc hướng ra ngoài (push, xoá, cài tool ngoài).
- Thông tin riêng từng game → `CLAUDE.md` của project + memory của project, **không** ghi vào file này.
