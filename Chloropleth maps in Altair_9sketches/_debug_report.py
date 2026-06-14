"""Scan a papermill-executed notebook for errors and print a debug report.

Used by run.bat after the papermill run. Exit code 0 if no error cell was
found, 1 otherwise -- so the batch script can react to the *output* of the run.
"""
import json
import sys


def main(path: str) -> int:
    try:
        with open(path, encoding="utf-8") as fh:
            nb = json.load(fh)
    except FileNotFoundError:
        print(f"[debug] No executed notebook at '{path}' -- papermill never produced output.")
        return 1

    errors = []
    for idx, cell in enumerate(nb.get("cells", [])):
        if cell.get("cell_type") != "code":
            continue
        for out in cell.get("outputs", []):
            if out.get("output_type") == "error":
                src = "".join(cell.get("source", [])).strip()
                tb = "\n".join(out.get("traceback", []))
                errors.append((idx, out.get("ename"), out.get("evalue"), src, tb))

    if not errors:
        print("[debug] No error outputs found -- every code cell executed cleanly.")
        return 0

    print(f"[debug] Found {len(errors)} failing cell(s):\n")
    for idx, ename, evalue, src, tb in errors:
        print(f"--- cell #{idx}: {ename}: {evalue} ---")
        print("  source:")
        for line in src.splitlines():
            print(f"    {line}")
        print("  traceback (last lines):")
        # strip ANSI colour codes for a clean console log
        import re
        clean = re.sub(r"\x1b\[[0-9;]*m", "", tb)
        for line in clean.splitlines()[-12:]:
            print(f"    {line}")
        print()
    return 1


if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "Chloropleth maps in Altair_JulienGimenez_out.ipynb"
    sys.exit(main(target))
