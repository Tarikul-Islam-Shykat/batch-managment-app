@echo off
rem Portable Batch Script to invoke root template.ps1 from ANY folder!
rem Usage: Open integrated terminal in any folder (e.g. features/auth or features/quiz) and run:
rem        ..\..\..\template sign_up  or  F:\bdcalling\jalmas-app-1\template sign_up

if "%~1"=="" (
    echo Usage: template ^<feature_name^>
    exit /b 1
)

set FEATURE_NAME=%~1
powershell -ExecutionPolicy Bypass -File "%~dp0template.ps1" %FEATURE_NAME%
