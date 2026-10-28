---
description: Verify a build on the connected Android device/LDPlayer via ADB and report pass/fail/not-run
---

# Device Test

1. Read `rules/device-testing.md` and `<stt>_claude.md` (package name, APK path, evidence folder).
2. `bash .claude/scripts/adb-device.sh check` — stop and report if 0 or >1 target without `SERIAL`.
3. `clearlog` → `install <apk>` (skip if user says installed) → `launch <pkg>`.
4. Exercise the path under test (taps via `adb shell input`, or ask the user to).
5. `shot`, `logcat <pkg>`, `perf <pkg>`.
6. Report as data: target (model/Android/ABI/emulator?), each step passed / failed / not run, quoted crash lines, perf numbers labelled `emulator` or `device`, evidence file paths.

Do not claim release readiness from an emulator run. Do not modify the device beyond install/launch/stop.
