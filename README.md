# Baby Names — 3 standalone visualization notebooks

This folder keeps **3 selected visualizations**, each as an independent,
self-contained notebook. The folder carries its own data and scripts, so each
notebook runs on its own. Chart data is **inlined**, so the HTML renders on Linux,
macOS and Windows.

## The 3 notebooks

| Notebook | From sketch | Question |
|---|---|---|
| `Visualization 01 - Streamgraph.ipynb` | 1.5 | evolution over time — Top-N streamgraph (sliding window, Raw/Share) |
| `Visualization 02 - Heatmap region.ipynb` | 2.2 | regional effect — each **decade's** top names × department, **grouped by region** |
| `Visualization 03 - Gender scatter.ipynb` | 3.5 | gender — boys-vs-girls share scatter with a name **history trail** |

## Updates from peer feedback

- **Visualization 01 (Streamgraph)** — the two free *From/To* year handles are
  replaced by a **fixed-size sliding window** (`Window size` sets the width once,
  `Window start` slides it), and a **Raw / Share toggle** is added: *Share* divides
  each name by the top-N total of its year, so the stacked height stays ~constant and
  recent decades are no longer crushed by the post-war birth-volume bump (the most
  recurring review request). Default = Raw, full span (unchanged initial view). Top-N,
  sex filter and click-to-isolate are kept.
- **Visualization 02 (Heatmap region)** — departments are now **grouped by region**
  (13 metropolitan regions; sorted by total births within each), so neighbouring
  departments sit together (addresses the "lost geographic adjacency" feedback). The
  **department code** is on the axis (full name in the tooltip), a **region colour
  strip with a named legend** sits on top, and the region is in the tooltip. The
  universe is each **decade's own top-25 names** (per sex), so sliding the decade
  shows the right names (e.g. LÉO / GABRIEL / JADE in the 2010s). The (praised)
  row-relative colour encoding is kept.
- **Visualization 03 (Gender scatter)** — adds a **history trail**: pick a name and
  its decade-by-decade path is drawn across the scatter (dark line, decade labels)
  over the current-decade snapshot, so a name's drift (e.g. CAMILLE toward the female
  side) is visible at a glance instead of stepping frames from memory (the
  change-blindness critique).

## Run one visualization

Windows:

```bat
run_Visualization 01 - Streamgraph.bat
```

macOS / Linux:

```bash
bash "run_Visualization 01 - Streamgraph.sh"
```

Each runner: installs `requirements.txt`, executes the notebook with **papermill**
(`<name>_out.ipynb`), scans the output for errors (`_debug_report.py`), and applies
the interactive-control-visibility patch (`_patch_altair_control_visibility.py`,
a no-op for these three).

On macOS / Linux, the runners use `PYTHON` when set, otherwise they use `.venv` if it
exists and create `.venv` if it does not. This avoids installing packages into a
system-managed Python.

## Run all three

```bat
run_all.bat
```

```bash
bash run_all.sh
```

`run_all` calls each runner by **absolute** path, so it works regardless of the
directory it is launched from.

## What's in the folder

- the 3 `Visualization 0N - *.ipynb` notebooks + their `run_*.bat` / `run_*.sh`
  runners, plus `run_all.bat` / `run_all.sh`;
- `dpt2020.csv`, `departements-version-simplifiee.geojson` — the data;
- `requirements.txt` — Python deps (Python 3.12);
- `_debug_report.py`, `_patch_altair_control_visibility.py` — shared helper scripts;
- after a run: `<name>_out.ipynb` (executed) and `<name>.png` (verification image).

## Portable across Linux / macOS / Windows

These notebooks **inline their chart data** (no external `altair-data-*.json` URL
files, which don't load in many notebook frontends and left the charts blank on
macOS): every HTML output is self-contained and renders on any OS. The `.sh` runners
honour a `PYTHON` override (`PYTHON=python ./run_*.sh`) and otherwise run through
`.venv`; all runners register a `python3` Jupyter kernel if missing.

## Memory / size

To keep the inlined data small (the default view is unchanged):

- **Visualization 01** — ever-top-60 names (covers the window Top-N, capped at 50) → ~6 MB;
- **Visualization 02** — only each (decade, sex) period's **top-25** names × departments
  are kept (≈ 18 MB inline), instead of the ~180 MB an all-name version would embed;
- **Visualization 03** — small pre-aggregated table (no restriction needed) → ~0.6 MB.

A re-run regenerates the executed `_out.ipynb` and the `<name>.png` files.
