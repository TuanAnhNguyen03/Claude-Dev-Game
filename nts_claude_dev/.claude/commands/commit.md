---
description: Generate commit message from staged files, user reviews then proceeds to commit
---

# /commit - Generate Commit Message & Commit

## Workflow Steps

### 1. Auto-stage & check staged files
// turbo
First, automatically `git add` all files that were modified or created during the **current conversation** (you know which files you edited). Then run `git diff --cached --stat` and `git diff --cached --name-status` to see what's staged.

If nothing is staged (no files changed in conversation and nothing pre-staged), notify user: "No files to commit."

### 1b. Hygiene gate (`rules/git-release.md`)
// turbo
Unstage and report (do not delete without asking) anything that must not ship:
- AI/agent files: `CLAUDE.md`, `<stt>_claude.md`, `AGENTS.md`, `.claude/`, `.mcp.json`, `brain/`, `production/`, screenshots/evidence, one-off helper scripts (unless `<stt>_claude.md` says they are shared).
- Regenerated files: `Assets/GeneratedLocalRepo/`, `FirebaseCrashlytics.androidlib/`, `Assets/_Recovery/`, `Assets/Screenshots/`, `*.orig`, `*.rej`, logs, apk/aab.
- `.meta` without its asset or asset without its `.meta` (`git diff --cached --name-status`).
- A shared submodule pointer moved to a commit not on its remote (`git -C <submodule> branch -r --contains <sha>` empty) — see `rules/git-release.md`.
- Secrets: keystore passwords, API keys, tokens in any staged file.

### 2. Analyze changes
// turbo
Run `git diff --cached` to read the actual diff content. For large diffs, focus on the key changes.

### 3. Generate commit message

Based on the diff analysis, generate a commit message following **Conventional Commits** format:

```
<type>(<scope>): <short summary>

<body - bullet points of key changes>
```

**Type rules:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring without behavior change
- `chore`: Maintenance, config, dependencies
- `docs`: Documentation only
- `style`: Formatting, no logic change
- `perf`: Performance improvement
- `test`: Adding/updating tests

**Scope detection rules:**
- Files in `Assets/Scripts/` → scope: `scripts`
- Files in `Assets/Art/` → scope: `art`
- Files in `Assets/Audio/` → scope: `audio`
- Files in `Assets/Prefabs/` → scope: `prefabs`
- Files in `Assets/Scenes/` → scope: `scenes`
- Files in `Assets/ScriptableObjects/` → scope: `data`
- Files in `Assets/Plugins/` → scope: `plugins`
- Files in `.claude/` → scope: `workflow`
- Files in `CustomPatchTools/` or a submodule → scope: `foundation`
- Files in `Docs/` → scope: `docs`
- Mixed modules → scope: most-changed module, mention others in body

**Guidelines:**
- Summary line: max 72 chars, lowercase, no period at end
- Body: bullet points with `-`, grouped logically
- Language: English
- Be specific about WHAT changed, not HOW

### 4. Present to user

Show the generated commit message in a code block:

```
📝 Commit message:
```

Then show the message, followed by quick-reply options AND terminal command:

```
👉 Reply:
   1 = Commit now
   2 = Edit message (include your changes)
   3 = Cancel
```

Then output the terminal command for user to copy-paste:
```bash
git commit -m "<title>" -m "<body>"
```

**⚠️ STOP HERE. Wait for user response. Do NOT auto-commit.**

### 5. Process user response

- **User replies `1`**, `ok`, `proceed`, `lgtm`, `commit`, or equivalent → Execute commit
- **User replies `2` + content** → Update message per suggestion, show step 4 again
- **User replies `3`**, `cancel`, or equivalent → Abort, do not commit

**Commit execution flow:**

Run `git commit -m "<title>" -m "<body>"` directly (user approves via command approval).

### 6. Confirm

Show the result of `git log -1 --oneline` to confirm the commit was created successfully.

### 7. Merge / push (only when the user asks)

- Fast-forward another branch without checkout (Unity may be open): `git fetch . <from>:<to>`.
- Push only the branches the user named, of the game repo only: `git push origin <branches>`. Never push a shared submodule unless the user names that repo.
- After push: `git fetch origin` and confirm local and `origin/<branch>` SHAs match; for LFS repos `git lfs push --dry-run origin <branch>` prints nothing.
