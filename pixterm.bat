@echo off
setlocal

REM pixterm-cli minimal launcher (Windows)
REM 하츄핑 이미지를 ANSI 컬러로 출력

set "PYTHON=python"
set "VENV=.venv"
set "REQ=requirements.txt"
set "SCRIPT=heartsping.py"
set "IMG=examples\hachuping.png"

REM 가상환경 없으면 생성
if not exist "%VENV%\Scripts\python.exe" (
    echo 📦 Creating virtual environment...
    %PYTHON% -m venv %VENV%
)

REM Pillow 설치 확인 및 설치
echo 📦 Installing dependencies...
call %VENV%\Scripts\python.exe -m pip install --quiet --upgrade pip
call %VENV%\Scripts\python.exe -m pip install --quiet -r %REQ%

REM 이미지 실행
echo 💖 Showing Hachuping ANSI demo...
call %VENV%\Scripts\python.exe %SCRIPT% -i "%IMG%" --ansi

endlocal