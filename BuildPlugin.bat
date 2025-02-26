@echo off

setlocal EnableDelayedExpansion

title Build Plugin

set RootDirectory=%~dp0
set RootDirectory=%RootDirectory:~0,-1%

for %%i in ("%RootDirectory%\*.uplugin") do (
  set UpluginFilePath=%%~i
  goto UpluginLocationFound
)

cd..
set RootDirectory=%cd%

for %%i in ("%RootDirectory%\*.uplugin") do (
  set UpluginFilePath=%%~i
  goto UpluginLocationFound
)

echo [91mError: No .uplugin file found in %RootDirectory%[0m
goto ExitWithPause

:UpluginLocationFound
for /f "tokens=2 delims=: " %%a in ('findstr /i /c:"EngineAssociation" /c:"EngineVersion" "%UpluginFilePath%"') do (
  if %%a=="EngineAssociation" (
    set EngineVersion=%%a
    set EngineVersion=!EngineVersion:~1,-2!
  ) else (
    set EngineVersion=%%a
    set EngineVersion=!EngineVersion:~1,-2!
  )
)

for /f "tokens=1-3 delims=." %%a in ("%EngineVersion%") do (
    set EngineVersion=%%a.%%b
)

if not defined EngineVersion (
  echo [91mError: No Engine association found in %UpluginFilePath%[0m
  set /p EngineVersion=Please enter the Unreal Engine version:
)

for /f "tokens=1-3 delims=." %%a in ("%EngineVersion%") do (
    set EngineVersion=%%a.%%b
)

for /f "skip=2 tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\EpicGames\Unreal Engine\%EngineVersion%" /v "InstalledDirectory"') do (
  set EngineDirectory=%%b
)

if defined EngineDirectory (
  set AutomationToolPath=!EngineDirectory!\Engine\Build\BatchFiles\RunUAT.bat
  echo Automation Tool Path: !AutomationToolPath!
  echo:
  call "!AutomationToolPath!" BuildPlugin -Plugin="!UpluginFilePath!" -Package="!RootDirectory!\Build" -Rocket -TargetPlatforms=Win64
) else (
    echo [91mError: Couldn't find Unreal Engine installation location![0m
    goto ExitWithPause
)

:ExitWithPause
pause
exit /b 0

endlocal
