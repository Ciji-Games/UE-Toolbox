@echo off

setlocal EnableDelayedExpansion

title Build Plugin

:Start
:: Prompt the user for the name of the folder to build
set /p BuildFolder=Please enter the name of the folder you want to build: 

set RootDirectory=%~dp0
set RootDirectory=%RootDirectory:~0,-1%

:: Update RootDirectory to include the BuildFolder
set RootDirectory=%RootDirectory%\%BuildFolder%

for %%i in ("%RootDirectory%\*.uplugin") do (
  set UpluginFilePath=%%~i
  goto UpluginLocationFound
)

cd..
set RootDirectory=%cd%

:: Update RootDirectory to include the BuildFolder
set RootDirectory=%RootDirectory%\%BuildFolder%

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

:: Prompt the user to zip the plugin folder
echo.
choice /M "Do you want to zip the plugin folder?"
if errorlevel 2 (
  echo Not zipping the plugin folder.
  goto ExitWithPause
) else (
  echo Zipping the plugin folder...
  set TempZipDir=%RootDirectory%\%BuildFolder%_Temp
  mkdir "!TempZipDir!"
  xcopy /E /I "%RootDirectory%\Build" "!TempZipDir!\%BuildFolder%"
  
  :: Set the zip file name without the engine version
  set ZipFileName=%RootDirectory%\%BuildFolder%.zip
  echo ZipFileName: !ZipFileName!
  
  :: Debug output to verify ZipFileName
  echo Debug: TempZipDir=!TempZipDir!
  echo Debug: BuildFolder=%BuildFolder%
  echo Debug: RootDirectory=%RootDirectory%
  echo Debug: ZipFileName=!ZipFileName!
  
  powershell -Command "Compress-Archive -Path '!TempZipDir!\%BuildFolder%' -DestinationPath '!ZipFileName!'"
  rmdir /S /Q "!TempZipDir!"
  echo Plugin folder zipped successfully as !ZipFileName!.
)


:ExitWithPause
pause

exit /b 0

endlocal
