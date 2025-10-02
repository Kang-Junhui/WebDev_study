@echo off
set PORT=%1
set USERNAME=%2

if "%PORT%"=="" set PORT=41414
if "%USERNAME%"=="" set USERNAME=User

echo Django 개발 서버를 시작합니다... (%USERNAME% - Port: %PORT%)

REM 가상환경 활성화
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
) else if exist ".venv\Scripts\activate.bat" (
    call .venv\Scripts\activate.bat
) else (
    echo 가상환경을 찾을 수 없습니다. setup_windows.bat를 먼저 실행하세요.
    pause
    exit /b 1
)

echo 서버를 포트 %PORT%에서 시작합니다... (사용자: %USERNAME%)
echo 브라우저에서 다음 주소로 접속하세요:
echo   - 로컬: http://localhost:%PORT%
echo   - 외부: http://scjune123.iptime.org:%PORT%
echo.
echo 서버를 중지하려면 Ctrl+C를 누르세요.
echo.

python manage.py runserver 0.0.0.0:%PORT%