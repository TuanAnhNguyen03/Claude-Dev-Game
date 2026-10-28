#!/bin/bash
# ADB helper for device/emulator (LDPlayer 9 or phone) verification. Evidence -> $OUT.
# Usage: adb-device.sh <check|install|launch|stop|shot|logcat|perf|clearlog> [args]
#   check                 list devices + model/android/size/density (must be exactly 1 target)
#   install <apk>         adb install -r
#   launch <pkg>          start via monkey LAUNCHER (no activity name needed)
#   stop <pkg>            force-stop
#   shot [name]           screenshot png -> $OUT
#   logcat [pkg]          dump log (errors + Unity/crash tags; filtered to pkg pid if running) -> $OUT
#   perf <pkg>            meminfo TOTAL + gfxinfo janky summary + cpuinfo line -> $OUT
#   clearlog              adb logcat -c
# Env: SERIAL (adb serial; required if >1 device), OUT (default production/device-evidence), ADB (default adb)
export MSYS_NO_PATHCONV=1
ADB="${ADB:-adb}"; OUT="${OUT:-production/device-evidence}"
mkdir -p "$OUT"
n=$("$ADB" devices | awk 'NR>1 && $2=="device"' | wc -l)
if [ "$n" -eq 0 ]; then echo "FAIL: no device. LDPlayer: enable ADB debugging; run '$ADB connect 127.0.0.1:5555' if not listed."; exit 2; fi
if [ "$n" -gt 1 ] && [ -z "$SERIAL" ]; then echo "FAIL: $n devices; set SERIAL=<serial>"; "$ADB" devices; exit 2; fi
A=("$ADB"); [ -n "$SERIAL" ] && A=("$ADB" -s "$SERIAL")
ts=$(date +%Y%m%d-%H%M%S)
case "$1" in
  check)
    "${A[@]}" devices
    for p in ro.product.model ro.build.version.release ro.product.cpu.abi; do printf '%s=' "$p"; "${A[@]}" shell getprop $p | tr -d '\r'; done
    "${A[@]}" shell wm size | tr -d '\r'; "${A[@]}" shell wm density | tr -d '\r' ;;
  install) "${A[@]}" install -r "$2" ;;
  launch)  "${A[@]}" shell monkey -p "$2" -c android.intent.category.LAUNCHER 1 ;;
  stop)    "${A[@]}" shell am force-stop "$2" ;;
  shot)    f="$OUT/${2:-shot}-$ts.png"; "${A[@]}" exec-out screencap -p > "$f" && echo "$f" ;;
  logcat)
    f="$OUT/logcat-$ts.txt"; pid=""
    [ -n "$2" ] && pid=$("${A[@]}" shell pidof "$2" | tr -d '\r')
    if [ -n "$pid" ]; then "${A[@]}" logcat -d -v time --pid="$pid" > "$f"; else "${A[@]}" logcat -d -v time > "$f"; fi
    echo "$f ($(wc -l < "$f") lines); crash/exception hits:"
    grep -E "FATAL EXCEPTION|AndroidRuntime|ANR in|Unity.*(Exception|Error)|SIGSEGV|signal 11" "$f" | head -20 ;;
  perf)
    f="$OUT/perf-$ts.txt"
    { echo "# meminfo"; "${A[@]}" shell dumpsys meminfo "$2" | grep -E "TOTAL|Native Heap|Graphics"
      echo "# gfxinfo"; "${A[@]}" shell dumpsys gfxinfo "$2" | grep -E "Total frames|Janky|percentile"
      echo "# cpuinfo"; "${A[@]}" shell dumpsys cpuinfo | grep "$2"; } | tr -d '\r' | tee "$f"
    echo "-> $f" ;;
  clearlog) "${A[@]}" logcat -c ;;
  *) sed -n '2,13p' "$0"; exit 1 ;;
esac
