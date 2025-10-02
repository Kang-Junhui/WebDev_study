@echo off
chcp 65001 > nul
echo Django 프로젝트 테스트 환경 설정 시작...
echo.

REM Python 설치 확인
python --version > nul 2>&1
if errorlevel 1 (
    echo 오류: Python이 설치되지 않았거나 PATH에 추가되지 않았습니다.
    echo Python을 설치하고 PATH에 추가한 후 다시 실행해주세요.
    pause
    exit /b 1
)

echo Python 버전 확인:
python --version
echo.

REM 기존 가상환경 삭제 확인
if exist "venv" (
    echo 기존 가상환경이 발견되었습니다.
    set /p choice="기존 가상환경을 삭제하고 새로 만드시겠습니까? (y/N): "
    if /i "%choice%"=="y" (
        echo 기존 가상환경을 삭제합니다...
        rmdir /s /q venv
    ) else (
        echo 기존 가상환경을 사용합니다.
        goto :activate_venv
    )
)

REM 가상환경 생성
echo 가상환경을 생성합니다...
python -m venv venv
if errorlevel 1 (
    echo 오류: 가상환경 생성에 실패했습니다.
    pause
    exit /b 1
)

:activate_venv
REM 가상환경 활성화
echo 가상환경을 활성화합니다...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo 오류: 가상환경 활성화에 실패했습니다.
    pause
    exit /b 1
)

REM pip 업그레이드
echo pip을 최신 버전으로 업그레이드합니다...
python -m pip install --upgrade pip

REM 패키지 설치
echo 필요한 패키지를 설치합니다...
pip install -r requirements.txt
if errorlevel 1 (
    echo 오류: 패키지 설치에 실패했습니다.
    pause
    exit /b 1
)

REM .env 파일 확인
if not exist ".env" (
    echo 경고: .env 파일이 없습니다.
    echo DB 연결을 위해 .env 파일을 생성해주세요.
    echo.
)

echo.
echo ================================================
echo 가상환경 설정이 완료되었습니다!
echo ================================================
echo.
echo 다음 단계:
echo 1. .env 파일이 있는지 확인하세요
echo 2. 'start_server.bat'를 실행하여 서버를 시작하세요
echo 3. 또는 수동으로 다음 명령어를 실행하세요:
echo    - call venv\Scripts\activate.bat
echo    - python manage.py makemigrations
echo    - python manage.py migrate
echo    - python manage.py runserver
echo.
pause