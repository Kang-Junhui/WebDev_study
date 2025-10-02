@echo off
echo Django 개발 서버를 시작합니다...

REM 가상환경 활성화
call venv\Scripts\activate.bat

REM 서버 시작 (포트 41414에서 실행)
echo 서버를 포트 41414에서 시작합니다...
echo 브라우저에서 http://localhost:41414 또는 http://scjune123.iptime.org:41414 로 접속하세요.
echo.
python manage.py runserver 0.0.0.0:41414