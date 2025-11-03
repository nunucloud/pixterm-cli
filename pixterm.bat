@echo off
setlocal

cd /d "%~dp0"
set "ROOT=%~dp0"

set "PYTHON=python"
set "VENV=%ROOT%.venv"
set "REQ=%ROOT%requirements.txt"
set "SCRIPT=%ROOT%heartsping.py"
set "IMG=%ROOT%examples\hachuping.png"

if not exist "%VENV%\Scripts\python.exe" (
    echo 📦 Creating virtual environment...
    %PYTHON% -m venv %VENV%
)

echo 📦 Installing dependencies...
call %VENV%\Scripts\python.exe -m pip install --quiet --upgrade pip
call %VENV%\Scripts\python.exe -m pip install --quiet -r %REQ%

echo 💖 Automatically displaying Hachuping image in ANSI colors...
call %VENV%\Scripts\python.exe %SCRIPT% -i "%IMG%" --ansi

pause

endlocal