@echo off
REM Runner for sketch_1_13_compare.ipynb -- portable execute + debug + control-visibility patch.
setlocal enabledelayedexpansion
cd /d "%~dp0"
set "NB=sketch_1_13_compare.ipynb"
set "OUT=sketch_1_13_compare_out.ipynb"
echo === [1/4] Installing dependencies (requirements.txt) ===
python -m pip install -r requirements.txt --quiet --disable-pip-version-check
if errorlevel 1 ( echo [ERROR] Dependency installation failed. & exit /b 1 )
python -m ipykernel install --user --name python3 >nul 2>&1
echo === [2/4] Running "%NB%" with papermill ===
python -m papermill "%NB%" "%OUT%" --kernel python3 --log-output
set "RC=%errorlevel%"
echo === [3/4] Debugging according to output ===
python _debug_report.py "%OUT%"
set "SCAN=%errorlevel%"
echo === [4/4] Patching interactive control visibility ===
python _patch_altair_control_visibility.py "%OUT%"
if not "%RC%"=="0" ( echo [FAIL] papermill exited with code %RC%. & exit /b %RC% )
if not "%SCAN%"=="0" ( echo [FAIL] a cell produced an error. & exit /b 1 )
echo.
echo [OK] sketch_1_13_compare ran cleanly. PNG: sketch_1_13_compare.png
endlocal
exit /b 0
