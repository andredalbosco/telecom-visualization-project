@echo off
REM ============================================================================
REM  run_9sketches.bat - Execute and debug the 9-sketches notebook with papermill.
REM
REM    1. install/refresh dependencies from requirements.txt
REM    2. run the notebook headlessly with papermill
REM    3. scan the executed output and print a debug report on any error
REM    4. patch Altair HTML controls while keeping the executed notebook interactive
REM
REM  Exit code: 0 on a clean run, non-zero if papermill failed or any cell
REM  produced an error output.
REM ============================================================================
setlocal enabledelayedexpansion
cd /d "%~dp0"

for /f %%I in ('powershell -NoProfile -Command "[DateTimeOffset]::Now.ToUnixTimeMilliseconds()"') do set "RUN_START_MS=%%I"

set "NB=Chloropleth maps in Altair_9sketches.ipynb"
set "OUT=Chloropleth maps in Altair_9sketches_out.ipynb"

echo === [1/4] Installing dependencies (requirements.txt) ===
python -m pip install -r requirements.txt --quiet --disable-pip-version-check
if errorlevel 1 (
    echo [ERROR] Dependency installation failed. Aborting.
    exit /b 1
)

echo === [2/4] Running "%NB%" with papermill ===
python -m papermill "%NB%" "%OUT%" --kernel python3 --log-output
set "RC=%errorlevel%"

echo === [3/4] Debugging according to output ===
python _debug_report.py "%OUT%"
set "SCAN=%errorlevel%"

echo === [4/4] Patching interactive control visibility ===
python _patch_altair_control_visibility.py "%OUT%"
set "PATCH=%errorlevel%"

if not "%RC%"=="0" (
    echo.
    echo [FAIL] papermill exited with code %RC% -- see the traceback above.
    exit /b %RC%
)
if not "%SCAN%"=="0" (
    echo.
    echo [FAIL] The notebook ran but at least one cell produced an error.
    exit /b 1
)
if not "%PATCH%"=="0" (
    echo.
    echo [FAIL] The notebook ran but the interactive control visibility patch failed.
    exit /b %PATCH%
)
for /f %%I in ('powershell -NoProfile -Command "[DateTimeOffset]::Now.ToUnixTimeMilliseconds() - [int64]$env:RUN_START_MS"') do set "RUN_DURATION_MS=%%I"
for /f %%I in ('powershell -NoProfile -Command "[math]::Round([int64]$env:RUN_DURATION_MS / 1000, 1)"') do set "RUN_DURATION_S=%%I"

echo.
echo [OK] Notebook executed cleanly with interactive Altair HTML outputs and dynamic control visibility. Sketch PNGs: sketch_1_5_*.png ... sketch_3_3_*.png
echo [time] Total run duration: !RUN_DURATION_MS! ms (!RUN_DURATION_S! s)
endlocal
exit /b 0
