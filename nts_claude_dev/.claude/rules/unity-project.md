---
paths:
  - "**/Assets/**"
  - "**/Packages/**"
  - "**/ProjectSettings/**"
---

# Unity Project Rules

- Editor version is pinned by `ProjectSettings/ProjectVersion.txt`; never upgrade it inside an unrelated task. Projects in this workspace differ in version — read the file, do not assume.
- Keep package versions and platform settings; when changing packages check `manifest.json` and `packages-lock.json` together.
- Runtime code never references `UnityEditor`; editor-only code lives in an `Editor` folder or editor-only asmdef.
- Change project settings narrowly and state the effect on existing Android builds.
- Do not remove SDKs/integrations only because a new feature does not use them.
- Third-party SDK/plugin must be verified present and working (assembly + runtime API) before depending on it; do not stub it. SDK shims already in a project must stay marked (e.g. `// SHIM`) and never be reported as real integration.
