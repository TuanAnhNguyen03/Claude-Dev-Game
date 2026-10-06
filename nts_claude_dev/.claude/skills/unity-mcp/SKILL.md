---
name: unity-mcp
description: "Use when working with Unity through MCP For Unity, Claude Desktop, GitHub Copilot, Codex, or another AI client; inspect scenes, edit Unity objects, debug Console errors, validate Play Mode, or coordinate Unity Editor and an AI Agent."
---

# Unity MCP Workflow

## Purpose

MCP For Unity connects an AI client to the open Unity Editor. It exposes structured tools for inspecting and changing scenes, GameObjects, components, prefabs, assets, Play Mode, Console output, and screenshots.

MCP is the tool connection. It does not replace project architecture, code review, gameplay design, or runtime testing.

## Project Context

For TR37, follow `D:\Project_unity\ClaudeDev\CLAUDE.md` and the NTS rules in `.claude/rules/`.

The target Unity project is:

`D:\Project_unity\UNITY\TR37_Minigame_clone\trg37-minigame\trg37-minigame`

Keep the assembly boundaries and mini-game framework intact. Do not modify unrelated scenes, prefabs, catalogs, or packages.

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
Modify only the identified files and Unity objects. Follow CLAUDE.md, the NTS architecture, and applicable .claude/rules. After editing, check the Unity Console and validate the relevant scene in Play Mode.
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

## TR37 Code Constraints

- Preserve `NTS.Core <- NTS.UI <- NTS.Shell <- NTS.MiniGames.<Name>` assembly isolation.
- Mini-games inherit from `MiniGameBase` and communicate through `MiniGameContext`.
- Use private `[SerializeField]` fields; avoid public mutable fields.
- Never use `Find`, `GetComponent`, `Camera.main`, LINQ, or allocations in `Update`/`FixedUpdate` hot paths.
- Cache component references in `Awake`.
- Use `Core/SaveManager` for persistence and `Core/Log` for logs.
- Do not add monetization SDKs or unrelated packages.
- Keep a back path for every UI screen.

## Completion Report

At the end of the task, report:

- What changed.
- Which Unity scene, prefab, script, or asset owns the change.
- Whether Console and Play Mode were checked.
- Any warnings that are unrelated or still require manual Unity Editor review.
