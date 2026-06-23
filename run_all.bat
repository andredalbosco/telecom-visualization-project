@echo off
setlocal
cd /d "%~dp0"
echo ### Visualization 01 - Streamgraph ###
call "%~dp0run_Visualization 01 - Streamgraph.bat" || exit /b 1
echo ### Visualization 02 - Heatmap region ###
call "%~dp0run_Visualization 02 - Heatmap region.bat" || exit /b 1
echo ### Visualization 03 - Gender scatter ###
call "%~dp0run_Visualization 03 - Gender scatter.bat" || exit /b 1
echo.
echo [OK] all 3 visualizations ran cleanly.
endlocal
