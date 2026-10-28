# Device / Emulator Testing (ADB + LDPlayer 9)

Load when a task claims "runs on device", "Android build OK", perf, or crash status. Helper: `.claude/scripts/adb-device.sh`.

- Editor Play Mode ≠ device. Claim "device-verified" only with ADB evidence from this session; otherwise write **not run**.
- Target = exactly one serial. >1 device → set `SERIAL`, never guess. LDPlayer 9 serial is `emulator-5554` or `127.0.0.1:5555`.
- Two adb binaries exist (platform-tools and `LDPlayer9/adb.exe`). Use ONE (default PATH `adb`); mixing versions kills the server (`adb kill-server`, then retry).
- Record the target in evidence: model, Android version, ABI, size, density (`adb-device.sh check`). An emulator pass is not a low-end-phone pass: perf numbers from LD9 are indicative only, label them `emulator`.
- Flow: `check` → `clearlog` → `install <apk>` → `launch <pkg>` → exercise the changed path → `shot` → `logcat <pkg>` → `perf <pkg>`. Evidence files go to `production/device-evidence/` (gitignored).
- Fail conditions: `FATAL EXCEPTION`, `ANR in`, `SIGSEGV`, Unity `Exception` in logcat for the package; or install/launch error. Report the quoted line, not a summary.
- Package name and APK path come from `<stt>_claude.md` / Player Settings. Do not invent them.
- ADB is read/test only: no `adb root`, `rm`, `pm clear`, `settings put` or system changes without user approval.
- Need UI taps/input: prefer `adb shell input tap/swipe` for smoke checks; for layout verification use `shot`, not text dumps.
