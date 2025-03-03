@echo off
setlocal enabledelayedexpansion

rem Change this to the path to your Unreal Engine's "UnrealVersionSelector.exe"
set "UEVersionSelector=C:\Program Files (x86)\Epic Games\Launcher\Engine\Binaries\Win64\UnrealVersionSelector.exe"

rem Change this to the path to your UnrealBuildTool
set "UnrealBuildTool=C:\Program Files\Epic Games\UE_5.4\Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.exe"

rem Get the directory of the batch file
set "BatchFileDir=%~dp0"

rem Find the .uproject file in the batch file directory
for %%i in ("%BatchFileDir%*.uproject") do set "UProjectFile=%%i"

if not defined UProjectFile (
    echo.
    echo [31m.uproject file not found in the batch file directory.[0m
    echo Please put this .bat next to the .uproject and execute it again
    pause
    exit /b
)

echo This tool will delete every cache data for your unreal project
echo - Close UE, close VS/Rider, proceed with care
echo - Wait for the compilation to end before closing this window.

setlocal
:PROMPT
SET /P AREYOUSURE=Do you want to nuke your solution? (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

rem Extract the project name from the .uproject file
for %%i in ("%UProjectFile%") do set "ProjectName=%%~ni"

echo Cleaning project files...

:: Save the current directory
set "CurrentDir=%cd%"

:: Display detected project name
echo [34mDetected project: %ProjectName%[0m

:: Delete specific folders
echo Deleting Intermediate, DerivedDataCache, Build, .vs, and Binaries folders...
for %%d in (Intermediate DerivedDataCache Build .vs Binaries) do (
    rmdir /s /q "%CurrentDir%\%%d"
)

:: Delete the .sln and .vsconfig files
echo Deleting .sln and .vsconfig files...
del /q "%CurrentDir%\%ProjectName%.sln"
del /q "%CurrentDir%\.vsconfig"

echo [32mCleaning completed.[0m

echo [34mGenerating project files...[0m

rem Generate project files using UnrealVersionSelector
"%UEVersionSelector%" -projectfiles "%UProjectFile%"

echo [34mGenerating Visual Studio project files...[0m
echo [31m PLEASE WAIT UNTIL THE PROJECT IS COMPILED!.[0m
rem Generate Visual Studio project files using UnrealBuildTool
"%UnrealBuildTool%" Development Win64 -Project="%UProjectFile%" -TargetType=Editor

echo [32mGeneration completed.[0m

rem Pause the script so you can see the output before it closes
pause

echo ... rest of file ...


:END
endlocal
