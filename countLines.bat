@echo off
setlocal enabledelayedexpansion

set "scriptDir=%~dp0"
for %%i in ("%scriptDir:~0,-1%") do set "parentDir=%%~ni"
set "directory=%scriptDir%Source\%parentDir%"
set "totalLines=0"

for /r "%directory%" %%f in (*.cpp) do (
    set "file=%%f"
    set "shortFile=%%~nxf"
    for /f %%l in ('find /v /c "" ^< "%%f"') do (
        echo !shortFile!: %%l lines
        set /a totalLines+=%%l
    )
)
echo ==========TOTAL:==============
echo Total lines in all .cpp files: %totalLines%
pause

