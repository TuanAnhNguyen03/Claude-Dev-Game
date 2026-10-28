---
name: unity-mcp
description: "Use when working with Unity through MCP For Unity, Claude Desktop, GitHub Copilot, Codex, or another AI client; inspect scenes, edit Unity objects, debug Console errors, validate Play Mode, or coordinate Unity Editor and an AI Agent."
---

# Unity MCP Workflow

## Purpose

MCP For Unity connects an AI client to the open Unity Editor. It exposes structured tools for inspecting and changing scenes, GameObjects, components, prefabs, assets, Play Mode, Console output, and screenshots.

MCP is the tool connection. It does not replace project architecture, code review, gameplay design, or runtime testing.

## Project Context

The target project, its Unity root, `profile` and MCP instance come from the project's `<stt>_claude.md` (`unity_root`, `mcp_instance`). Follow the project `CLAUDE.md`, `MAP.md` and the rules in `.claude/rules/` for that profile.

Keep the project's assembly boundaries and framework intact. Do not modify unrelated scenes, prefabs, catalogs, or packages.

## Several Editors open (common in this workspace)

- Read `mcpforunity://instances`, `set_active_instance` to the intended `Name@hash`, then confirm project name/path from Editor state before any write.
- Hash and socket port change when an Editor restarts. Never reuse a remembered port: resolve it by project name from `~/.unity-mcp/unity-mcp-status-*.json` (the file whose project path matches `unity_root`).
- A write sent to the wrong Editor is a real change in another game: if it happens, stop, check that project's `git status`, and report it.
- `Editor.log` is shared across open Editors; filter by project path before trusting a log or build report.

## Startup Checklist

1. Open the target Unity project.
2. Open `Window > MCP For Unity`.
3. Use `Transport: Stdio` for Claude Desktop and VS Code GitHub Copilot.
4. Confirm `Session Active` with a green status.
5. Open only one AI client for Unity editing at a time.
6. If the client was already open before Unity, reload or restart the client.

Do not switch to HTTP Local for Claude Desktop or VS Code when the client configuration uses `uvx` and `stdio`. HTTP Local is a different transport mode and can cause a transport mismatch.

## Client Configuration

- Claude Desktop: `%APPDATA%\\Claude\\claude_desktop_config.json`
- VS Code Copilot: project `.vscode/mcp.json`
- Claude Code: project `.mcp.json`

The normal local server command is:

```text
uvx --from mcpforunityserver==9.7.3 mcp-for-unity --transport stdio
```

If Unity reports that `uvx` is not recognized:

1. Verify `uvx --version` in a new PowerShell.
2. Close Unity and Unity Hub completely.
3. Reopen Unity Hub and the project so it inherits the updated PATH.
4. Start the MCP session again.

Do not create duplicate Cloud and local entries for the same client. Remove invalid HTTP Cloud entries from clients that only support stdio.

## Safe Task Workflow

For every coding or Unity-editing task:

1. Inspect first without changes.
2. State the relevant scene, object, script, prefab, or asset owner.
3. Make the smallest requested change.
4. Check Unity Console immediately after compilation.
5. Inspect the changed object or asset in Unity.
6. Run the relevant scene or Play Mode check.
7. Report changed files, validation performed, and any remaining warning.

Use this first prompt pattern:

```text
Inspect the current Unity scene and the relevant scripts/prefabs first. Do not modify anything. Identify the owner of the requested behavior and report your findings.
```

Then use an implementation prompt with explicit scope:

```text
Modify only the identified files and Unity objects. Follow CLAUDE.md, <stt>_claude.md (profile), and applicable .claude/rules. After editing, check the Unity Console and validate the relevant scene in Play Mode.
```

## MCP Usage Rules

- Prefer structured MCP inspection over reading large Unity YAML files.
- Ask for confirmation before destructive operations such as deleting objects, replacing assets, changing package versions, or editing project settings.
- Do not let two AI clients edit the same Unity project simultaneously.
- Do not assume a successful tool call means the visual result is correct; inspect the result.
- Keep asset references and GUIDs intact.
- For UI, inspect anchors, pivots, aspect ratio, sorting order, masking, and mobile resolution behavior.
- For transitions and animations, validate both entering and leaving states, not just one screenshot.
- For Android-related changes, validate the target resolution, touch input, performance, and build configuration.
- Builds: one synchronous `execute_code` call that writes the `BuildReport` summary to a file; no `delayCall` builds (lost on domain reload). See `rules/android-build.md`.
- Screenshot tools may write into `Assets/Screenshots/`; delete that folder and its `.meta` after use so it never reaches a commit.
- Before judging a Game View capture, check the Game View resolution preset (Free Aspect makes UI look shifted).

## Code Constraints

- Private `[SerializeField]` fields for new code; existing public serialized fields stay until scenes/prefabs are checked (`Restored`).
- Never use `Find`, `GetComponent`, `Camera.main`, LINQ, or allocations in `Update`/`FixedUpdate` hot paths; cache references in `Awake`.
- `(NTS profile)`: preserve `NTS.Core <- NTS.UI <- NTS.Shell <- NTS.<Game>` assembly isolation; persistence via `Core/SaveManager`, logs via `Core/Log`.
- Project-specific frameworks (e.g. TRG37 `MiniGameBase`/`MiniGameContext`) are listed in that project's `<stt>_claude.md`.
- Do not add SDKs or packages the task did not ask for.
- Keep a back path for every UI screen.

## Completion Report

At the end of the task, report:

- What changed.
- Which Unity scene, prefab, script, or asset owns the change.
- Whether Console and Play Mode were checked.
- Any warnings that are unrelated or still require manual Unity Editor review.
