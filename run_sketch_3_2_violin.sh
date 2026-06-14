#!/usr/bin/env bash
# Runner for sketch_3_2_violin.ipynb -- portable execute + debug + control-visibility patch.
set -euo pipefail
cd "$(dirname "$0")"
PY="${PYTHON:-python3}"
NB="sketch_3_2_violin.ipynb"
OUT="sketch_3_2_violin_out.ipynb"
echo "=== [1/4] Installing dependencies (requirements.txt) ==="
"$PY" -m pip install -r requirements.txt --quiet --disable-pip-version-check
"$PY" -m ipykernel install --user --name python3 >/dev/null 2>&1 || true
echo "=== [2/4] Running $NB with papermill ==="
"$PY" -m papermill "$NB" "$OUT" --kernel python3 --log-output
echo "=== [3/4] Debugging according to output ==="
"$PY" _debug_report.py "$OUT"
echo "=== [4/4] Patching interactive control visibility ==="
"$PY" _patch_altair_control_visibility.py "$OUT"
echo
echo "[OK] sketch_3_2_violin ran cleanly. PNG: sketch_3_2_violin.png"
