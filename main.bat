@echo off

:install_loop
echo Choose an installation type:
echo 1. Haxelib
echo 2. Git
set /p INSTALL_TYPE=Enter your choice (1/2): 

if "%INSTALL_TYPE%"=="1" goto install_haxelib
if "%INSTALL_TYPE%"=="2" goto install_git
echo Invalid choice. Please enter 1 or 2.
goto install_loop

:install_haxelib
set /p LIBRARY_NAME=Enter the Haxe library name: 
set /p LIBRARY_VERSION=Enter the Haxe library version (must provide): 

if "%LIBRARY_VERSION%"=="" (
    set HAXELIB_URL=https://lib.haxe.org/p/%LIBRARY_NAME%/
    powershell -Command "Invoke-WebRequest -Uri '%HAXELIB_URL%' | Select-Object -ExpandProperty Content | Select-String -Pattern 'href=[\'"]?([^\'" >]+)' | ForEach-Object {$_.Matches} | ForEach-Object {$_.Groups[1].Value} | Select-Object -First 1" > latest_version.txt
    set /p LIBRARY_VERSION=<latest_version.txt
    del latest_version.txt
)

set HAXELIB_URL=https://lib.haxe.org/p/%LIBRARY_NAME%/%LIBRARY_VERSION%/download/
powershell -Command "Invoke-WebRequest -Uri '%HAXELIB_URL%' -OutFile '%LIBRARY_NAME%-%LIBRARY_VERSION%.zip'"
haxelib install %LIBRARY_NAME%-%LIBRARY_VERSION%.zip
del %LIBRARY_NAME%-%LIBRARY_VERSION%.zip

set /p INSTALL_AGAIN=Do you want to install another library? (y/n): 
if "%INSTALL_AGAIN%"=="y" goto install_loop
goto end

:install_git
set /p LIBRARY_NAME=Enter the Haxe library name: 
set /p LIBRARY_URL=Enter the Git URL: 
haxelib git %LIBRARY_NAME% %LIBRARY_URL%

set /p INSTALL_AGAIN=Do you want to install another library? (y/n): 
if "%INSTALL_AGAIN%"=="y" goto install_loop
goto end

:end
echo Goodbye!