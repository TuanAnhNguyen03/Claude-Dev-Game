# Evidence & Honest Reporting (always loaded)

- Label claims: **OBSERVED** (seen in source/Editor/device this session) · **REPORTED** (from user or docs) · **PROPOSED** (design decision, not verified) · **UNKNOWN**. Never infer original game behaviour from a class name.
- Claim only what the evidence type supports: source read ≠ compile ≠ Play Mode ≠ device build. Say "not run" for checks that did not run.
- Unity Editor evidence = compile 0 errors + Console read + (for UI/scene) a Game View capture. Wait for compile/import to finish before judging.
- Several Unity Editors can be open at once: with UnityMCP, **always `set_active_instance` to the intended project** and confirm the project name before any write.
- Missing dependency/plugin/SDK: record it as a blocker, continue independent work, never stub to fake a pass.
- Do not commit/push/publish unless asked. Report outcomes with artifact paths, not narration.
