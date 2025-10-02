@echo off
chcp 65001 > nul
echo Django 서버 시작...
echo.

REM 가상환경 확인
if not exist "venv" (
    echo 오류: 가상환경이 없습니다.
    echo 먼저 'setup_windows.bat'를 실행하여 가상환경을 설정해주세요.
    pause
    exit /b 1
)

REM .env 파일 확인
if not exist ".env" (
    echo 경고: .env 파일이 없습니다.
    echo DB 연결을 위해 .env 파일을 생성해주세요.
    echo.
)

REM 가상환경 활성화
echo 가상환경을 활성화합니다...
call venv\Scripts\activate.bat

REM 데이터베이스 연결 테스트
echo 데이터베이스 연결을 테스트합니다...
python manage.py check --database default
if errorlevel 1 (
    echo 경고: 데이터베이스 연결에 문제가 있을 수 있습니다.
    echo .env 파일의 DB 설정을 확인해주세요.
    echo.
)

REM 마이그레이션 확인 및 실행
echo 마이그레이션을 확인합니다...
python manage.py makemigrations
python manage.py migrate

REM 정적 파일 수집
echo 정적 파일을 수집합니다...
python manage.py collectstatic --noinput

echo.
echo ================================================
echo Django 서버를 시작합니다...
echo ================================================
echo.
echo 서버 주소: http://localhost:41414
echo 외부 접속: http://scjune123.iptime.org:41414
echo 관리자 페이지: http://localhost:41414/admin
echo.
echo 서버를 중지하려면 Ctrl+C를 누르세요.
echo.

REM Django 서버 실행 (포트 41414에서 실행)
python manage.py runserver 0.0.0.0:41414