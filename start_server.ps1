# Django 개발 서버 시작
Write-Host "Django 개발 서버를 시작합니다..." -ForegroundColor Green

# 가상환경 활성화
& "venv\Scripts\Activate.ps1"

# 서버 시작 (포트 41414에서 실행)
Write-Host "서버를 포트 41414에서 시작합니다..." -ForegroundColor Yellow
Write-Host "브라우저에서 http://localhost:41414 또는 http://scjune123.iptime.org:41414 로 접속하세요." -ForegroundColor Cyan
Write-Host ""
python manage.py runserver 0.0.0.0:41414