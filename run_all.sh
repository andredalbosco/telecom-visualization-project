#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
echo "### Visualization 01 - Streamgraph ###"
bash "$(dirname "$0")/run_Visualization 01 - Streamgraph.sh"
echo "### Visualization 02 - Heatmap region ###"
bash "$(dirname "$0")/run_Visualization 02 - Heatmap region.sh"
echo "### Visualization 03 - Gender scatter ###"
bash "$(dirname "$0")/run_Visualization 03 - Gender scatter.sh"
echo
echo "[OK] all 3 visualizations ran cleanly."
