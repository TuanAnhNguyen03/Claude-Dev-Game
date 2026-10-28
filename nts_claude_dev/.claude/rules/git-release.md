# Git, submodule & release hygiene (always loaded)

Applies to every profile. Commit/push still only when the user asks.

## Branches with Unity open
- Never `git checkout`/`switch`/`stash` across branches while that project's Editor is open: Unity reimports the swapped tree, can regenerate `.meta` GUIDs (seen: Firebase `google-services-desktop.json.meta`) and churns ~1000+ files.
- Fast-forward another branch without touching the working tree: `git fetch . develop:main` (or `git branch -f main develop`), then `git push origin develop main`.
- A checkout that cannot be avoided → ask the user to close the Editor first.

## Shared submodules (e.g. `Assets/Packages/nts-unity-foundation`)
- The submodule remote is shared by many games: **never commit-and-push game-specific edits to it** unless the user explicitly asks for that repo.
- Pin the game repo's submodule pointer to a commit that exists on the submodule remote (`git branch -r --contains <sha>` non-empty). A pointer to a local-only commit breaks every fresh clone.
- Keep game-specific edits uncommitted inside the submodule and save them as `CustomPatchTools/foundation_custom_logic.patch` in the game repo (Tools > NTS Foundation > Patching > Create Custom Patch). Commit the patch with the game. Status ` m <submodule>` is then expected.
- Verify a regenerated patch applies to the pinned base without touching the Editor tree: temporary `GIT_INDEX_FILE` + `git read-tree <base>` + `git apply --cached <patch>`.

## What goes in the game repo
- Track: `Assets/`, `Packages/` (incl. `file:*.tgz` deps referenced by `manifest.json`), `ProjectSettings/`, `CustomPatchTools/`, design docs, the release keystore **only if the user asks** (never its passwords; `ProjectSettings` must reference it as `{inproject}: <name>.keystore`).
- Do not track (regenerated or local): `Library/`, `Temp/`, `Logs/`, `UserSettings/`, `Builds/`, apk/aab, `Assets/GeneratedLocalRepo/`, `Assets/Plugins/Android/FirebaseCrashlytics.androidlib/`, `Assets/_Recovery/`, `Assets/Screenshots/`, per-machine installer settings.
- Every tracked `.meta` must have its asset tracked and vice versa (orphan metas get deleted by Unity on clone and dirty the tree). Do not blanket-ignore an extension (e.g. `*.mdb`) whose `.meta` is already tracked.
- AI/agent files stay local unless `<stt>_claude.md` says the team shares them: `CLAUDE.md`, `<stt>_claude.md`, `AGENTS.md`, `.claude/`, `.mcp.json`, `brain/`, `production/`, audit/evidence screenshots, one-off helper scripts. Remove them from the commit before `/commit`.

## Before pushing a release
- `git status` clean except the expected submodule ` m`; `git lfs push --dry-run origin <branch>` prints nothing; local and `origin/<branch>` SHAs equal after push.
- README has first-clone steps when the repo needs any (LFS, `--recurse-submodules`, Apply Custom Patch, keystore password source).
