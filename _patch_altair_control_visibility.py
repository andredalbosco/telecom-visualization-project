"""Patch executed Altair HTML outputs so extra bound controls hide dynamically.

Altair/Vega-Lite renders every parameter binding declared in the specification.
For sketches 1.13 and 2.6 we keep the full interactive HTML output, then inject a
small DOM patch that hides dropdown rows above the active slot count.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ALT_ID_RE = re.compile(r'<div id="(altair-viz-[^"]+)"></div>')

CONTROL_PATCHES = [
    {
        "key": "sketch_1_13_name_slots",
        "required": ["Name slots shown", "Name 20"],
        "count_label": "Name slots shown",
        "row_labels": [f"Name {i:02d}" for i in range(1, 21)],
        "min_count": 0,
        "max_count": 20,
        "default_count": 3,
    },
    {
        "key": "sketch_2_6_map_slots",
        "required": ["Maps shown", "Name 06"],
        "count_label": "Maps shown",
        "row_labels": [f"Name {i:02d}" for i in range(1, 7)],
        "min_count": 3,
        "max_count": 6,
        "default_count": 6,
    },
]


def html_as_text(value: object) -> str:
    if isinstance(value, list):
        return "".join(str(part) for part in value)
    return str(value)


def make_patch_script(chart_id: str, patch: dict) -> str:
    payload = {
        "chartId": chart_id,
        "key": patch["key"],
        "countLabel": patch["count_label"],
        "rowLabels": patch["row_labels"],
        "minCount": patch["min_count"],
        "maxCount": patch["max_count"],
        "defaultCount": patch["default_count"],
    }
    payload_json = json.dumps(payload, ensure_ascii=False)
    return f"""
<script type="text/javascript" data-codex-control-visibility="{patch["key"]}">
(function(config) {{
  function normalise(text) {{
    return (text || "").replace(/\\s+/g, " ").trim();
  }}

  function install() {{
    var root = document.getElementById(config.chartId);
    if (!root) {{
      return false;
    }}
    if (root.dataset["codexVisibility" + config.key]) {{
      return true;
    }}

    var scopes = [root];
    if (root.parentElement) {{
      scopes.push(root.parentElement);
    }}

    var rows = [];
    scopes.forEach(function(scope) {{
      Array.prototype.forEach.call(scope.querySelectorAll(".vega-bind"), function(row) {{
        rows.push(row);
      }});
    }});

    if (!rows.length) {{
      scopes.forEach(function(scope) {{
        Array.prototype.forEach.call(scope.querySelectorAll("label"), function(label) {{
          var row = label.closest("div") || label.parentElement || label;
          rows.push(row);
        }});
      }});
    }}

    var seen = new Set();
    rows = rows.filter(function(row) {{
      if (!row || seen.has(row)) {{
        return false;
      }}
      seen.add(row);
      return !!row.querySelector("input, select");
    }});

    function rowStartsWith(row, label) {{
      return normalise(row.textContent).indexOf(label) === 0;
    }}

    var countRow = rows.find(function(row) {{
      return rowStartsWith(row, config.countLabel);
    }});
    if (!countRow) {{
      return false;
    }}

    var countInput = countRow.querySelector('input[type="range"], input, select');
    if (!countInput) {{
      return false;
    }}

    var slotRows = config.rowLabels.map(function(label) {{
      return rows.find(function(row) {{
        return rowStartsWith(row, label);
      }});
    }});
    if (!slotRows.some(Boolean)) {{
      return false;
    }}

    function currentCount() {{
      var parsed = parseInt(countInput.value, 10);
      if (isNaN(parsed)) {{
        parsed = config.defaultCount;
      }}
      return Math.max(config.minCount, Math.min(config.maxCount, parsed));
    }}

    function update() {{
      var count = currentCount();
      slotRows.forEach(function(row, idx) {{
        if (row) {{
          row.style.display = idx < count ? "" : "none";
        }}
      }});
    }}

    countInput.addEventListener("input", update);
    countInput.addEventListener("change", update);
    root.dataset["codexVisibility" + config.key] = "1";
    update();
    return true;
  }}

  if (!install()) {{
    var root = document.getElementById(config.chartId);
    var observer = new MutationObserver(function() {{
      if (install()) {{
        observer.disconnect();
      }}
    }});
    if (root) {{
      observer.observe(root, {{childList: true, subtree: true}});
    }}
    [50, 100, 250, 500, 1000, 2000].forEach(function(delay) {{
      window.setTimeout(install, delay);
    }});
  }}
}})({payload_json});
</script>
"""


def patch_html(html: str) -> tuple[str, int]:
    applied = 0
    for patch in CONTROL_PATCHES:
        marker = f'data-codex-control-visibility="{patch["key"]}"'
        if marker in html:
            continue
        if not all(required in html for required in patch["required"]):
            continue

        match = ALT_ID_RE.search(html)
        if not match:
            continue
        html += make_patch_script(match.group(1), patch)
        applied += 1
    return html, applied


def patch_notebook(path: Path) -> int:
    nb = json.loads(path.read_text(encoding="utf-8"))
    applied = 0

    for cell in nb.get("cells", []):
        for output in cell.get("outputs", []):
            data = output.get("data")
            if not isinstance(data, dict) or "text/html" not in data:
                continue
            html = html_as_text(data["text/html"])
            html, count = patch_html(html)
            if count:
                data["text/html"] = html
                applied += count

    metadata = nb.setdefault("metadata", {})
    metadata["altair_control_visibility_patched"] = {
        "patches_applied": applied,
        "patch_keys": [patch["key"] for patch in CONTROL_PATCHES],
    }
    path.write_text(json.dumps(nb, ensure_ascii=False, indent=1), encoding="utf-8")
    return applied


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("Usage: python _patch_altair_control_visibility.py NOTEBOOK.ipynb")
        return 2

    path = Path(argv[1])
    applied = patch_notebook(path)
    print(f"[controls] Applied {applied} dynamic control visibility patch(es) to {path.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
