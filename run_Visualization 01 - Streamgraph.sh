#!/usr/bin/env bash
# Runner for "Visualization 01 - Streamgraph.ipynb" -- portable execute + debug + control-visibility patch.
set -euo pipefail
cd "$(dirname "$0")"
if [[ -n "${PYTHON:-}" ]]; then
  PY="$PYTHON"
elif [[ -x ".venv/bin/python" ]]; then
  PY=".venv/bin/python"
else
  python3 -m venv .venv
  PY=".venv/bin/python"
fi
if ! "$PY" -m pip --version >/dev/null 2>&1; then
  python3 -m venv --upgrade-deps .venv
  PY=".venv/bin/python"
fi
NB="Visualization 01 - Streamgraph.ipynb"
OUT="Visualization 01 - Streamgraph_out.ipynb"
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
echo "[OK] Visualization 01 - Streamgraph ran cleanly. PNG: Visualization 01 - Streamgraph.png"
