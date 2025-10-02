# Django 프로젝트 테스트 환경 설정
Write-Host "Django 프로젝트 테스트 환경 시작..." -ForegroundColor Green

# 가상환경 확인 및 생성
if (-not (Test-Path "venv")) {
    Write-Host "가상환경을 생성합니다..." -ForegroundColor Yellow
    python -m venv venv
}

# 가상환경 활성화
Write-Host "가상환경을 활성화합니다..." -ForegroundColor Yellow
& "venv\Scripts\Activate.ps1"

# 패키지 설치
Write-Host "필요한 패키지를 설치합니다..." -ForegroundColor Yellow
pip install -r requirements.txt

# 데이터베이스 마이그레이션
Write-Host "데이터베이스 마이그레이션을 실행합니다..." -ForegroundColor Yellow
python manage.py makemigrations
python manage.py migrate

# 정적 파일 수집
Write-Host "정적 파일을 수집합니다..." -ForegroundColor Yellow
python manage.py collectstatic --noinput

Write-Host ""
Write-Host "설정이 완료되었습니다!" -ForegroundColor Green
Write-Host "이제 'start_server.ps1'을 실행하여 서버를 시작할 수 있습니다." -ForegroundColor Green
Write-Host ""
Read-Host "계속하려면 Enter를 누르세요"