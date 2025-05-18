@echo off
setlocal enabledelayedexpansion

set "ATTR_FILE=%~dp0.gitattributes"
set "LFS_FILTER=filter=lfs diff=lfs merge=lfs -text"
set "MAX_SIZE=104857600"  REM 100MB

REM Skip the .git, __ExternalActors__, __ExternalObjects__, and DerivedDataCache folders

set "EXISTING_PATHS="
if exist "%ATTR_FILE%" (
    for /f "usebackq delims=" %%A in ("%ATTR_FILE%") do (
        for /f "tokens=1" %%B in ("%%A") do (
            set "EXISTING_PATHS=!EXISTING_PATHS!;%%B;"
        )
    )
)

set "ADDED_COUNT=0"

REM Store the original color
set "ORIGINAL_COLOR=07"

echo Scanning files, please wait...

REM Use dir and findstr to exclude unwanted folders from the scan
for /f "delims=" %%F in ('dir /b /s /a-d "%~dp0*" ^| findstr /vi /i "\\\.git\\ \\__ExternalActors__\\ \\__ExternalObjects__\\ \\DerivedDataCache\\ \\Intermediate\\ \\Saved\\"') do (
    set "REL=%%F"
    set "REL=!REL:%~dp0=!"
    set "REL_NORM=!REL:\=/!"
    REM Show progress only for files not skipped
    echo Processing: !REL!
    if /i not "%%~nxF"=="checkLFS.bat" if /i not "%%~nxF"==".gitattributes" (
        call :CheckSize "%%F" "%%~nxF" %%~zF
    )
)

echo Files added: !ADDED_COUNT!

endlocal
pause
goto :eof

:CheckSize
set "F=%~1"
set "NXF=%~2"
set "SZ=%~3"
if %SZ% leq %MAX_SIZE% goto :eof
set "REL_PATH=%F%"
set "REL_PATH=!REL_PATH:%~dp0=!"
set "REL_PATH=!REL_PATH:\=/!"
echo !EXISTING_PATHS! | findstr /i /c:";!REL_PATH!;" >nul
if errorlevel 1 (
    echo !REL_PATH! %LFS_FILTER% >> "%ATTR_FILE%"
    set /a ADDED_COUNT+=1
    REM Change color to red on black
    color 0C
    echo Added: !REL_PATH! (%SZ% bytes)
    REM Reset color to default (white on black)
    color 07
)
goto :eof
