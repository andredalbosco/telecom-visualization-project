# how to view and rerun this submission

This folder is the exported week 2 implementation for the Baby Names mini-project.

Start with:

```text
Chloropleth maps in Altair_9sketches_out.ipynb
```

It is the executed notebook. The source notebook is:

```text
Chloropleth maps in Altair_9sketches.ipynb
```

## files

| file | purpose |
|---|---|
| `Chloropleth maps in Altair_9sketches.ipynb` | source notebook |
| `Chloropleth maps in Altair_9sketches_out.ipynb` | executed notebook for review |
| `sketch_*.png` | screenshots of the nine implemented sketches |
| `dpt2020.csv` | baby names by department, 1900 to 2020 |
| `departements-version-simplifiee.geojson` | French department shapes |
| `altair_dn_decade.json` | data for the regional map |
| `altair-data-*.json` | data exported by Altair |
| `requirements.txt` | Python dependencies |
| `run_9sketches.bat` | Windows rerun script |
| `_debug_report.py` | checks the executed notebook for error cells |
| `_patch_altair_control_visibility.py` | adjusts visible controls in the executed notebook |

Do not split these files across folders. The notebook output refers to the JSON and CSV files by local filename.

## rerun

Windows:

```bat
run_9sketches.bat
```

macOS or Linux:

```bash
python -m pip install -r requirements.txt
python -m papermill "Chloropleth maps in Altair_9sketches.ipynb" "Chloropleth maps in Altair_9sketches_out.ipynb" --kernel python3
python _debug_report.py "Chloropleth maps in Altair_9sketches_out.ipynb"
python _patch_altair_control_visibility.py "Chloropleth maps in Altair_9sketches_out.ipynb"
```

The data files are large. If you cloned this repository, make sure Git LFS pulled the CSV and JSON files.
