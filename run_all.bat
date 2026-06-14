@echo off
setlocal
cd /d "%~dp0"
echo ### sketch_1_5_streamgraph ###
call "run_sketch_1_5_streamgraph.bat" || exit /b 1
echo ### sketch_1_2_leaderboard ###
call "run_sketch_1_2_leaderboard.bat" || exit /b 1
echo ### sketch_1_13_compare ###
call "run_sketch_1_13_compare.bat" || exit /b 1
echo ### sketch_2_4_map ###
call "run_sketch_2_4_map.bat" || exit /b 1
echo ### sketch_2_2_heatmap ###
call "run_sketch_2_2_heatmap.bat" || exit /b 1
echo ### sketch_2_6_small_multiples ###
call "run_sketch_2_6_small_multiples.bat" || exit /b 1
echo ### sketch_3_5_scatter ###
call "run_sketch_3_5_scatter.bat" || exit /b 1
echo ### sketch_3_2_violin ###
call "run_sketch_3_2_violin.bat" || exit /b 1
echo ### sketch_3_3_positional ###
call "run_sketch_3_3_positional.bat" || exit /b 1
echo.
echo [OK] all 9 sketches ran cleanly.
endlocal
