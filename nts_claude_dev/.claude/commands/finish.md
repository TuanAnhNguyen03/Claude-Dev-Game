---
description: Mark task as complete and extract learnings
---

# Finish Workflow

> Complete the task and extract learnings.
> Flow: `/plan` → `/execute` → `/finish`

## Trigger
User calls:
- `/finish` → Auto-detect task from current conversation
- `/finish [task_name]` → Specify a particular task
- `/finish --no-learnings` → Skip learnings extraction

## Step 1: Locate Task Context

### 1.1 If user did NOT provide task_name:
Agent identifies task from conversation:
1. Find task.md and implementation_plan.md created in this conversation (in `brain/<task>/`)
2. Use conversation content to identify the feature being worked on
3. If uncertain, ask user: "Do you want to /finish task [name]?"

### 1.2 If user DID provide task_name:
Find task.md in brain/ of the current conversation

### 1.3 Fallback if NO task artifacts exist:
If the conversation has no artifacts:
1. Ask user: "No task artifacts found. Would you like me to create a mini-summary for learnings?"
2. If user agrees → Create walkthrough.md with format:
   ```markdown
   # Quick Note: [Date]
   ## Context
   [Brief description of the conversation]
   ## Learnings
   - [Learning 1]
   ```
3. Still update `<stt>_claude.md` (or propose a scaffold change) if there are noteworthy learnings

> [!TIP]
> The agent remembers the current task throughout the conversation so `/finish` doesn't need the task name.

## Step 2: Update Task Status
Update the task file:
- Mark completed checkboxes
- Record test results (if any)
- Record actual changes vs. the original plan

## Step 3: Extract Learnings (DEFAULT — skip if --no-learnings flag is set)

### 3.1 Analyze the completed task:
- **New patterns**: What new code patterns were used that could be reused?
- **Gotchas**: What bugs/errors were encountered? How were they fixed?
- **Best practices**: What should/shouldn't be done?
- **Reusable code**: What code snippets could be reused?

### 3.2 Decide where to update (Decision Tree):

```text
What type of learning is this?
│
├─► Rule that applies to EVERY project in the workspace?
│   └─► ✅ Propose a change to the ClaudeDev scaffold (`nts_claude_dev/.claude/rules|commands|skills`) + `CHANGELOG.md`
│       **⚠️ MUST ask user approval** — it ships to all games. Keep it generic (game names only as measured examples).
│       Example: "Never git checkout with the Editor open", "Never push a shared submodule"
│
├─► Rule/decision for THIS project only?
│   └─► ✅ `<stt>_claude.md` (rules / decisions / status sections)
│
├─► Specific rule, pattern, or deep technique for a specific domain?
│   └─► ✅ `.claude/learned/[domain].md` (local, gitignored)
│       Example domains: `unity-dev.md`, `playable.md`, `art-2d.md`, `ui.md`, `game-designer.md`
│       Example learning: "Use Prefab Variants for ScriptableObjects", "Phaser 3 texture packing"
│
├─► Improvement to PLANNING or WORKFLOW processes?
│   └─► ✅ `.claude/commands/*.md` (and the scaffold copy) — **⚠️ MUST ask user approval before modifying workflow!**
│
├─► Debugging insight (root cause analysis, non-obvious bug)?
│   └─► ✅ `.claude/learned/[domain].md` (relevant domain file, add "Gotchas" section)
│       Format: **[Module] [Symptom]**: Root cause was [X] because [Y]
│
└─► Only applies to this task, not reusable?
    └─► ❌ Keep in task file, no need to update rules
```

> [!TIP]
> **Dual-category tiebreaker**: When a learning fits multiple categories (e.g., both a gotcha and a pattern),
> place it in the higher-priority location. scaffold rule > `<stt>_claude.md` > `.claude/learned/`.

### 3.3 Quality Gate — Entry MUST pass ALL 3 filters

Every candidate entry must pass these 3 filters before being written. If it fails ANY filter → **do NOT write it**.

**Filter 1 — Novelty** (Was this surprising or did it cause a real bug?)
- ❌ REJECT if it's standard framework behavior documented in official Unity/engine docs
- ❌ REJECT if any competent developer would already know this (e.g., "cache GetComponent", "unsubscribe events in OnDisable", "Resources.Load needs Resources folder")
- ✅ ACCEPT only if discovered through actual debugging or unexpected behavior in THIS task

**Filter 2 — Non-Duplication** (Does this ALREADY exist somewhere?)
- Search `.claude/rules/*.md`, `.claude/skills/`, `~/.claude/skills/` and `<stt>_claude.md` for the same concept
- Search `.claude/knowledge/` (if present) for the same pattern
- Search the target `.claude/learned/*.md` file for semantically similar entries
- ❌ REJECT if covered by existing sub-skill rules (even partially)
- ❌ REJECT if an existing learned entry covers >80% of the same topic → MERGE instead of appending
- ✅ ACCEPT only if this is a genuinely NEW insight not captured anywhere

**Filter 3 — Project Specificity** (Is this tied to THIS project's codebase?)
- ❌ REJECT generic advice (e.g., "use events for decoupling", "write editor scripts for repetitive tasks")
- ❌ REJECT Unity Editor bugs that are Googleable (e.g., "GameObjectInspector NullRef on Play Mode")
- ✅ ACCEPT specific gotchas naming actual project classes (e.g., "MonsterController wrapper bypasses QuantizedAudioPlayer state")
- ✅ ACCEPT specific patterns tied to game mechanics (e.g., "AcidPool hazard: set bodyType to Static for bridge")

> [!IMPORTANT]
> **If borderline on any filter → write a 1-line condensed version**, not a paragraph.
> **Learned files are for scars, not textbooks.** Only record things that actually bit you.

### 3.4 Update priority (in order of importance):

| Priority | File | When to update | Agent reads when |
|----------|------|----------------|------------------|
| 🥇 1st | `<stt>_claude.md` | Project rules, decisions, status | **Every conversation** (imported by `CLAUDE.md`) |
| 🥈 2nd | Scaffold `.claude/rules/*.md` (user-approved) | Cross-project rules | When files match the rule glob |
| 🥉 3rd | `.claude/learned/[domain].md` | Domain gotchas | When working within domain |
| 4th | `.claude/commands/*.md` | Process improvements | When calling the command |

> [!IMPORTANT]
> **`<stt>_claude.md` is the primary location** because it is always loaded via `CLAUDE.md`. Keep it strict; cross-project rules go to the scaffold, not here.
> Only update workflows when the learning relates to PROCESS, not CODE.

### 3.5 Dedup & Compaction Check (BEFORE writing new entry)
Before appending, read the target learned file and search for semantically similar existing entries:
- If an existing entry covers >80% of the same topic → **MERGE** (update it, do not append a duplicate)
- If the file exceeds 60 entries → archive resolved gotchas to `[domain]-archive.md` and merge overlapping patterns

### 3.6 Update files:
// turbo
- Read the file to update
- Add/merge learnings to the appropriate section
- Keep formatting consistent with existing content
- Note the source of the learning (which task)

### 3.7 Refresh code graph (optional)
If the project uses `graphify` and code changed, run `graphify update <Scripts path>` so `GRAPH_REPORT.md` matches HEAD.

## Step 4: Create Walkthrough
// turbo

Create `walkthrough.md` in brain/ to document results:
```markdown
# Walkthrough: [Feature Name]
> Completed: [YYYY-MM-DD]

## Changes Made
| File | Action | Description |
|------|--------|-------------|
| path/to/file | MODIFY | What changed |

## What Was Tested
- [ ] Compile: Verify no errors in Unity Editor Console
- [ ] Manual verification: [steps]

## Validation Results
- Test results: ✅/❌
- Notes: [any relevant notes]
```

> [!TIP]
> `brain/` is local (gitignored); never commit walkthroughs into the game repo.

## Step 4.5: Deeper Learning (Optional)
If the task was complex or had many valuable insights:
- Ask user: "This task had many interesting learnings. Would you like me to run `/teach` to create a detailed lesson?"
- If user agrees → run `/teach` workflow (global)
- If user skips → continue to Step 5

> [!TIP]
> `/teach` creates narrative-style lessons, different from the rules/patterns extraction in Step 3.

## Step 5: Report to User
Notify the user:
- ✅ Task completed
- 📝 Files updated (if any)
- 🧠 Learnings extracted (summary)
- 💡 Suggestion: Call `/commit` when ready to commit

---

## Example Output

```markdown
✅ **Task Completed**: [feature_name]

### Files Updated:
- `<stt>_claude.md` or `.claude/learned/[domain].md`: Added [pattern] rule

### Learnings Extracted:
1. **Pattern**: [reusable pattern description]
2. **Gotcha**: [non-obvious issue and fix]

💡 Call `/commit` when ready to commit.
```
