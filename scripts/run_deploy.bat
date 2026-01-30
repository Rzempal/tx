@echo off
REM Skrypt uruchamiający deploy_template.ps1 z obejściem polityki wykonywania skryptów
REM Kliknij 2x ten plik, aby uruchomić deployment

echo Uruchamianie deploymentu APK (Production)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0deploy_template.ps1" -Channel production -SkipUpload:$false
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Wystąpił błąd podczas uruchamiania skryptu PowerShell.
    pause
)
REM Skrypt PS1 ma własny "Exit-WithPause", więc tu nie musimy pauzować, chyba że PS w ogóle nie ruszył
