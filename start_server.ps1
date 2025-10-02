# PowerShell 스크립트로 Django 서버 시작
Write-Host "Django 서버 시작..." -ForegroundColor Green
Write-Host ""

# 가상환경 확인
if (-not (Test-Path "venv")) {
    Write-Host "오류: 가상환경이 없습니다." -ForegroundColor Red
    Write-Host "먼저 'setup_windows.ps1'를 실행하여 가상환경을 설정해주세요." -ForegroundColor Yellow
    Read-Host "계속하려면 Enter를 누르세요"
    exit 1
}

# .env 파일 확인
if (-not (Test-Path ".env")) {
    Write-Host "경고: .env 파일이 없습니다." -ForegroundColor Yellow
    Write-Host "DB 연결을 위해 .env 파일을 생성해주세요." -ForegroundColor Yellow
    Write-Host ""
}

# 가상환경 활성화
Write-Host "가상환경을 활성화합니다..." -ForegroundColor Cyan
& ".\venv\Scripts\Activate.ps1"

# 데이터베이스 연결 테스트
Write-Host "데이터베이스 연결을 테스트합니다..." -ForegroundColor Cyan
python manage.py check --database default
if ($LASTEXITCODE -ne 0) {
    Write-Host "경고: 데이터베이스 연결에 문제가 있을 수 있습니다." -ForegroundColor Yellow
    Write-Host ".env 파일의 DB 설정을 확인해주세요." -ForegroundColor Yellow
    Write-Host ""
}

# 마이그레이션 확인 및 실행
Write-Host "마이그레이션을 확인합니다..." -ForegroundColor Cyan
python manage.py makemigrations
python manage.py migrate

# 정적 파일 수집
Write-Host "정적 파일을 수집합니다..." -ForegroundColor Cyan
python manage.py collectstatic --noinput

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "Django 서버를 시작합니다..." -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "서버 주소: http://localhost:41414" -ForegroundColor White
Write-Host "외부 접속: http://scjune123.iptime.org:41414" -ForegroundColor White
Write-Host "관리자 페이지: http://localhost:41414/admin" -ForegroundColor White
Write-Host ""
Write-Host "서버를 중지하려면 Ctrl+C를 누르세요." -ForegroundColor Yellow
Write-Host ""

# Django 서버 실행 (포트 41414에서 실행)
python manage.py runserver 0.0.0.0:41414