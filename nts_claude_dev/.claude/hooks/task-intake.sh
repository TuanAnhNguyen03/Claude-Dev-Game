#!/bin/bash
# UserPromptSubmit hook: stdout is injected as context on every prompt.
# Keeps the task-intake contract in front of the model; trimmed to ~10 lines to save tokens.
cat <<'TXT'
[TASK INTAKE — mandatory]
1. Read MAP.md order; project <stt>_claude.md wins. Profile decides which rules apply.
2. Before code: ponytail ladder; read existing code (no assumptions). Arch question -> graphify GRAPH_REPORT.md first (note if stale vs HEAD).
3. Code under Scripts/{UI,Gameplay,Core,AI,Networking} -> @dev Mode B. Before commit: /ponytail-review + @reviewer.
4. Unity writes: set_active_instance + confirm project name first.
5. Report with evidence labels (OBSERVED/REPORTED/PROPOSED/UNKNOWN); source != compile != Play Mode != device. Say "not run" when not run.
6. Device claims need ADB evidence (/device-test). No commit/push/publish unless asked. Terse, data-style answers.
TXT
exit 0
