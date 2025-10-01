@echo off
echo Django 프로젝트 테스트 환경 시작...

REM 가상환경 확인 및 생성
if not exist "venv" (
    echo 가상환경을 생성합니다...
    python -m venv venv
)

REM 가상환경 활성화
echo 가상환경을 활성화합니다...
call venv\Scripts\activate.bat

REM 패키지 설치
echo 필요한 패키지를 설치합니다...
pip install -r requirements.txt

REM 데이터베이스 마이그레이션
echo 데이터베이스 마이그레이션을 실행합니다...
python manage.py makemigrations
python manage.py migrate

REM 정적 파일 수집
echo 정적 파일을 수집합니다...
python manage.py collectstatic --noinput

echo.
echo 설정이 완료되었습니다!
echo 이제 'start_server.bat'를 실행하여 서버를 시작할 수 있습니다.
echo.
pause