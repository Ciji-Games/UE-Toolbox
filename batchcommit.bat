@echo off
setlocal enabledelayedexpansion

REM === Ask for commit name ===
set "COMMIT_NAME="
echo Enter commit name (description for this batch):
set /p COMMIT_NAME=

echo [Step 1] Scanning .git directory...

REM Set threshold to 99MB (in bytes)
set "MIN_FILE_SIZE=103809024"

REM Locate .git directory (up to 5 parent levels)
set "GIT_ROOT="
set "SEARCH_DIR=%cd%"
for /l %%i in (1,1,5) do (
    if exist "!SEARCH_DIR!\.git" (
        set "GIT_ROOT=!SEARCH_DIR!"
        goto :FoundGit
    )
    for %%a in ("!SEARCH_DIR!\..") do set "SEARCH_DIR=%%~fa"
)
:FoundGit

if not defined GIT_ROOT (
    echo Error: .git directory not found.
    pause
    exit /b 1
)
pushd "%GIT_ROOT%" >nul 2>&1

echo [Step 2] Scanning for local changes (excluding files +99MB)...

REM Clear previous list
set "LOCAL_CHANGES="
if exist local_changes.txt del local_changes.txt

REM === Untracked (new) files ===
for /f "delims=" %%f in ('git ls-files --others --exclude-standard 2^>nul') do (
    if exist "%%f" (
        for %%A in ("%%f") do (
            if %%~zA LEQ %MIN_FILE_SIZE% (
                set "LOCAL_CHANGES=!LOCAL_CHANGES! %%f"
                echo %%f>>local_changes.txt
            )
        )
    )
)

REM === Modified files ===
for /f "delims=" %%f in ('git diff --name-only --diff-filter=M 2^>nul') do (
    if exist "%%f" (
        for %%A in ("%%f") do (
            if %%~zA LEQ %MIN_FILE_SIZE% (
                set "LOCAL_CHANGES=!LOCAL_CHANGES! %%f"
                echo %%f>>local_changes.txt
            )
        )
    )
)

REM Count the number of local changes
set /a CHANGE_COUNT=0
if exist local_changes.txt (
    for /f %%C in (local_changes.txt) do set /a CHANGE_COUNT+=1
)

echo Number of local changes: %CHANGE_COUNT%

REM === Single loop: group and commit ===
setlocal enabledelayedexpansion

set "MAX_COMMIT_SIZE=209715200"
set /a GROUP_IDX=1
set /a GROUP_SIZE=0
set "GROUP_FILELIST=group_files.txt"

if exist "!GROUP_FILELIST!" del "!GROUP_FILELIST!"

for /f "delims=" %%f in (local_changes.txt) do (
    if exist "%%f" (
        for %%A in ("%%f") do (
            set /a FILE_SIZE=%%~zA
            set /a TEST_SIZE=!GROUP_SIZE! + !FILE_SIZE!
            if !TEST_SIZE! GEQ !MAX_COMMIT_SIZE! (
                REM Commit current group if not empty
                if exist "!GROUP_FILELIST!" (
                    echo [Step 3] Committing group !GROUP_IDX!... 
                    git add --pathspec-from-file="!GROUP_FILELIST!" >nul 2>&1
                    git commit -m "!COMMIT_NAME! (!GROUP_IDX!)" >nul 2>&1
                    del "!GROUP_FILELIST!"
                )
                set /a GROUP_IDX+=1
                set /a GROUP_SIZE=0
            )
            set /a GROUP_SIZE+=!FILE_SIZE!
            echo %%f>>"!GROUP_FILELIST!"
        )
    )
)

REM Commit any remaining files in the last group
if exist "!GROUP_FILELIST!" (
    echo [Step 3] Committing group !GROUP_IDX!... 
    git add --pathspec-from-file="!GROUP_FILELIST!" >nul 2>&1
    git commit -m "!COMMIT_NAME! (!GROUP_IDX!)" >nul 2>&1
    del "!GROUP_FILELIST!"
)

echo.
echo [Step 4] Cleaning up temporary files...

REM Cleanup temporary .txt files
if exist local_changes.txt del local_changes.txt >nul 2>&1
if exist group_files.txt del group_files.txt >nul 2>&1

endlocal

popd >nul 2>&1
echo [Done] All steps completed.
pause
endlocal
exit /b
