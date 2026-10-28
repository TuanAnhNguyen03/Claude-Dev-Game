# Token discipline (always loaded)

- Reply in the user's language, ≤8 lines, data only (file:line, value, pass/fail). No preamble, no re-narrating plan/status the task list already shows; explain only when asked "why".
- Read narrowly: Grep, offset/limit; never re-read a file already in context; no full hierarchy/asset/log dumps.
- UnityMCP calls paged and summary-first: `page_size` ≤25, `include_properties=false`, `generate_preview=false`.
- Screenshots: scale ≤0.5 or zoom a region; one capture per verified change.
- Long logs/findings → write a file (docs/notes), reply with the path.
- Status, history and release notes live in on-demand docs (`docs/<STT>_STATUS_HISTORY.md`), not in auto-loaded `CLAUDE.md`/`<stt>_claude.md`/rules. Rules get `paths:` frontmatter unless truly global.
- One Unity MCP server per machine/project (`UnityMCP` stdio in `.mcp.json`); remove duplicate registrations (e.g. old `unityMCP` in the desktop config) instead of keeping both.
- Broad searches → subagent on a cheap model. Fresh session or `/compact` between independent tasks (one game/feature per session).
- Optional output style: `.claude/templates/output-style-terse.md` → copy to `~/.claude/output-styles/`.
