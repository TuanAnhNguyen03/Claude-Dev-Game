# MAP — Bản đồ điều hướng ClaudeDev (AI đọc FILE NÀY TRƯỚC)

> Nguồn sự thật duy nhất (SSOT) về **ở đâu có gì, đọc gì khi làm gì, ai thắng khi xung đột**.
> Các CLAUDE.md khác chỉ trỏ về đây, không lặp lại bảng. Sửa cấu trúc → sửa file này.

## 1. Thứ tự đọc bắt buộc

```
① C:\Users\ADMIN\.claude\CLAUDE.md          (global: phong cách + hierarchy/render order)
② <workspace>\ClaudeDev\CLAUDE.md           (bộ dùng chung: checklist, skill, hard rules, workflow)
③ <workspace>\ClaudeDev\MAP.md              (file này: bản đồ)
④ <project>\CLAUDE.md                       (chung: stack, layout, áp dụng toàn bộ rule+skill; import @<stt>_claude.md)
④b <project>\<stt>_claude.md                (RIÊNG game, vd 37_claude.md)  ← chỉ 1 nơi chứa thông tin riêng game
⑤ .claude\rules\*.md                        (tự nạp theo path-glob khi đụng file khớp)
⑥ .claude\skills\* / ~\.claude\skills\*     (nạp theo mô tả task)
```
Xung đột: **④b <stt>_claude.md > ④ project CLAUDE.md > ⑤ rules > ② ClaudeDev > ① global** (ngoại lệ so với hard rules phải ghi rõ ở ④b). Không sửa tầng thấp để phục vụ riêng một game.

## 1b. Profile của project (khai báo ở đầu `<stt>_claude.md`: `profile: NTS | Restored | Custom`)

| Profile | Dùng khi | Áp dụng |
|---|---|---|
| `NTS` | Game dựng mới theo kiến trúc NTS (asmdef Core/UI/Shell/Game, `Core/SaveManager`, `Core/Log`) | Toàn bộ rules, gồm mục gắn `(NTS profile)` |
| `Restored` | Project phục hồi/port từ bản có sẵn (nhiều scene/prefab phụ thuộc GUID, serialized field, SDK bên thứ ba) | Rules chung **trừ** mục `(NTS profile)`; **giữ cấu trúc hiện có**, không đổi tên class/field/asset path/GUID khi chưa kiểm tra tác động; `asset-integrity` + `unity-project` là bắt buộc |
| `Custom` | Cấu trúc riêng không thuộc hai loại trên | Rules chung + quy ước ghi rõ ở `<stt>_claude.md` |

Mặc định (không khai báo) = `NTS`. Profile không nới lỏng `rules/evidence.md` và hard rules chung.

## 2. Cây thư mục

```
ClaudeDev/
├─ CLAUDE.md                    entry workspace-level (generic, mọi game)
├─ MAP.md                       bản đồ này
├─ AGENTS.md                    entry cho agent khác (Codex...) → trỏ về CLAUDE.md + MAP.md
├─ README.md · CHANGELOG.md · VERSION
├─ CLAUDE.md.bak-*              backup — KHÔNG đọc, KHÔNG nạp
└─ nts_claude_dev/              scaffold (git repo riêng) — copy sang mỗi project
   ├─ CLAUDE.md                 TEMPLATE CLAUDE.md chung của project (điền {{placeholder}})
   ├─ stt_claude.template.md    TEMPLATE file riêng game → đổi tên <stt>_claude.md (vd 37_claude.md)
   ├─ .mcp.json                 UnityMCP http://127.0.0.1:8080/mcp
   ├─ .gitignore                bỏ qua Unity/, brain/, CLAUDE.local.md, settings.local.json
   ├─ production/session-state/ output hook (git-keep)
   └─ .claude/
      ├─ settings.json          permissions allow/deny + 7 hook + statusline
      ├─ statusline.sh
      ├─ rules/        (14)     luật code, auto-load theo glob  → §3
      ├─ commands/     (9)      slash command                    → §4
      ├─ agents/        (3)      dev (Mode A extract / Mode B code) · reviewer (read-only) · qa (Editor verify)
      ├─ templates/    (12)     skeleton tái dùng cho @dev       → §5
      ├─ hooks/        (7)      session-start/stop, compact, notify, log-agent
      └─ skills/unity-mcp/      quy trình MCP For Unity (scaffold)
```

## 3. Rules → glob → áp dụng
(glob chuẩn hoá `**/Assets/...` — khớp cả khi Unity project ở root hoặc lồng trong `Unity/<tên>/`)

| Rule | Glob chính | Nội dung cốt lõi |
|---|---|---|
| `evidence.md` | luôn nạp (không glob) | nhãn OBSERVED/REPORTED/PROPOSED/UNKNOWN, chỉ claim theo đúng loại bằng chứng, `set_active_instance` khi nhiều Editor, thiếu plugin → blocker không stub |
| `asset-integrity.md` | `**/Assets/**` | giữ `.meta`/GUID, move qua AssetDatabase, không đổi tên class/field khi chưa kiểm tra |
| `unity-project.md` | `**/Assets/**`, `**/Packages/**`, `**/ProjectSettings/**` | pin Editor version, giữ package/setting, SDK phải thật (shim phải đánh dấu) |
| `prototype-code.md` | `**/Assets/Scripts/**`, `prototypes/**` | baseline (mục `(NTS profile)` chỉ cho NTS): clean arch, event-driven, SerializeField, cache ở Awake, TrySubscribe, zero-alloc, SaveManager, Log, no UnityEditor, plugin STOP-and-warn, UI back-path |
| `engine-code.md` | `**/Scripts/Core/**` | zero-alloc, core ↛ gameplay, cleanup xác định |
| `gameplay-code.md` | `**/Scripts/Gameplay/**` | giá trị qua SerializeField, deltaTime, ↛ UI, FSM rõ |
| `ui-code.md` | `**/Scripts/UI/**` | UI chỉ hiển thị, tween kill được, audio qua event, Canvas Scaler |
| `ai-code.md` · `network-code.md` | `**/Scripts/{AI,Networking}/**` | chỉ khi game có |
| `test-standards.md` | `**/Scripts/Tests/**` | chuẩn test |
| `data-files.md` | `**/Assets/{Resources/Data,Data}/**`, `assets/data/**` | data asset |
| `shader-code.md` | `**/Assets/**/*.{shader,hlsl,cginc}`, `**/Assets/Shaders/**` | shader |
| `design-docs.md` | `**/design/gdd/gdd.md` | GDD |
| `narrative.md` | `**/design/narrative/**` | narrative |

## 4. Commands (workflow)

```
/blueprint (cả sản phẩm → cây feature)          ┐
/plan  ──duyệt──▶ /execute ──▶ /review ──▶ /commit ──▶ /finish
   task.md + implementation_plan.md     @dev Mode B bắt buộc       walkthrough.md
/debug (bug)   /teach (debrief)   /publish-gdd (gdd-sheet.md → html, commit local, không push)
```
- Artifact task: `brain/<slug>/{task.md, implementation_plan.md, walkthrough.md}`.
- `/execute`: Data → Core → Gameplay/UI → Tests; save `task.md` sau mỗi layer.
- Code dưới `Scripts/{UI,Gameplay,Core,AI,Networking}` **chỉ** qua `@dev` Mode B. Trước `/commit`: `@reviewer` (chỉ đọc). Xác minh Editor: `@qa`.

## 5. Templates → rules_ref (@dev khớp theo `purpose`/`tags`)

| Template | rules_ref | requires_plugins |
|---|---|---|
| `mono-behaviour` | prototype, asset-integrity | — |
| `mono-singleton-extensions` | engine, gameplay | — |
| `game-state-machine` | gameplay, engine | — |
| `sound-manager` | engine, prototype | — |
| `platform-haptic` | engine | — |
| `data-asset-scriptable` | data-files, gameplay | — |
| `data-manager-orchestrator` | gameplay, prototype | — |
| `user-data-persistence` | prototype, gameplay | Easy Save 3 |
| `menu-manager` | ui, engine | — |
| `dialog-pooled` | ui | DOTween |
| `ui-anim-base` | ui | DOTween |
| `gdd-sheet-page.html` | — | dùng bởi `/publish-gdd` |

## 6. Skill: ai làm gì

| Việc | Skill / tool |
|---|---|
| Thao tác Unity Editor (scene/prefab/script/console/test/screenshot) | `unity-mcp-skill` (global, đầy đủ) — `unity-mcp` (scaffold, quy trình) |
| Kiến trúc mobile, mini-game, local multiplayer, save, perf, APK | `unity-mobile-arch` |
| Viết/sửa code | `ponytail` ladder → `ponytail-review` trước commit, `-audit` định kỳ |
| Hiểu cấu trúc code | `graphify` — đọc `graphify-out/GRAPH_REPORT.md` trước; `graphify update <Scripts>` sau khi sửa |
| Art style FLAT/PPU160 | `tr37-art-style` (chỉ game dùng style này) |
| HTML/GDD/artifact | `webapp-testing`, `playwright-cli`, `frontend-design`, `web-artifacts-builder` — **không** test game Unity |

## 7. Điểm chưa thống nhất đã phát hiện (cần người quyết)

| # | Vấn đề | Ảnh hưởng | Trạng thái |
|---|---|---|---|
| 1 | Glob `Unity/*/Assets/**` không khớp layout `<tên>/Assets/**` | rules không nạp | **Đã sửa** → `**/Assets/**` (rules + execute + blueprint) |
| 2 | `nts_claude_dev/CLAUDE.md` ghi cứng "TRG36 bubbleshoot" | AI hiểu nhầm game | **Đã sửa** → template `{{placeholder}}` |
| 3 | 2 CLAUDE.md lặp bảng rules/commands | lệch khi sửa 1 nơi | **Đã sửa** → bảng chỉ ở MAP.md |
| 4 | `plan.md` gọi skill `smart-pole-context-analyzer`, `brainstorming` — **không có** trong `~/.claude/skills` | bước tham chiếu rỗng | **Đã sửa v1.0.1** → "nếu có skill thì đọc, không thì áp dụng thủ công, không claim đã chạy" |
| 5 | `publish-gdd.md` còn path cứng `Unity/design/gdd/gdd-sheet/...` | sai nếu layout khác | Mở (`design-docs`/`narrative` đã glob `**/design/...` ở v1.0.1) |
| 6 | `ui-code.md` yêu cầu "keyboard/mouse AND gamepad" — game mobile touch-first | mâu thuẫn | **Đã sửa v1.0.1** → input theo profile/`<stt>_claude.md`, mặc định touch-first |
| 7 | `prototype-code.md` nêu ví dụ riêng một game; rule NTS áp lên project không-NTS | rò thông tin / áp sai | **Đã sửa v1.0.1** → bỏ ví dụ riêng, gắn nhãn `(NTS profile)` |
| 8 | `unity-mcp` (scaffold) trùng `unity-mcp-skill` (global) | 2 nguồn hướng dẫn MCP | Quy ước: global = tra cứu tool, scaffold = quy trình |
| 9 | Lệnh dùng `docs/learned/`, `brain/`, `CLAUDE.local.md` nhưng không có sẵn | AI tìm file không tồn tại | Tạo khi dùng; `CLAUDE.local.md` đã gitignore |

## 8. Registry project trong workspace `D:/1.Game UNITY/2.TRG` (quét 2026-10-06)

Chỉ là chỉ mục để chọn profile; chi tiết game nằm ở `<stt>_claude.md` của từng project.

| stt | Project | Unity root | Editor | Profile gợi ý | Hiện có | Cần làm để theo chuẩn |
|---|---|---|---|---|---|---|
| 24 | PRJ_TRG24-color-asmr | `trg24-color-asmr/trg24_color_asmr` (thư mục ngoài có `Assets/` rỗng — không mở) | 6000.1.17f1 | NTS (skill `unity-mobile-arch` đúc kết từ game này) | chỉ `.claude/settings.local.json` | copy scaffold + tạo `CLAUDE.md` + `24_claude.md` |
| 37 | PRJ_TRG37_Minigame | `trg37-minigame` | 6000.1.17f1 | NTS | `.claude/skills` (Unity MCP), `.mcp.json` | tạo `CLAUDE.md` + `37_claude.md` (nội dung lấy từ `CLAUDE.md.bak-20261006`) |
| 42 | PRJ_TRG42_Unboxing | `Unity/TRG42-Unboxing` | 6000.1.17f1 | Custom (kiến trúc Domain/Core/UI/Shell/Features/Integrations) | `AGENTS.md`, `Docs/` (ARCHITECTURE, DECISIONS, RULES_AND_SKILLS), `brain/` | thêm `CLAUDE.md` + `42_claude.md`; giữ `AGENTS.md` |
| 51 | PRJ_TRG51_Ragdoll_Kick | thư mục project (root = Unity root) | **6000.3.25f1** | Restored | `CLAUDE.md`, `.claude/{rules,agents,commands,templates,skills}` riêng | đổi `CLAUDE.md` thành bản chung + `51_claude.md`; rules riêng đã được gộp thành `asset-integrity`/`unity-project`/`evidence` ở repo này |

Lưu ý chung: nhiều Editor có thể mở cùng lúc → luôn `set_active_instance`. Editor version khác nhau giữa project → đọc `ProjectVersion.txt`. Nguồn rip/tham chiếu nằm ngoài (`D:.Game UNITY.RIPPER_DUC`), coi là read-only.

## 9. Cách giữ map đúng

Thêm/xoá rule, command, template, skill → cập nhật bảng tương ứng ở file này **trong cùng lần sửa**.
