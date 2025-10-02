# PowerShell 스크립트로 Django 프로젝트 환경 설정
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "Django 프로젝트 테스트 환경 설정 시작..." -ForegroundColor Green
Write-Host ""

# Python 설치 확인
try {
    $pythonVersion = py --version 2>$null
    if ($pythonVersion) {
        Write-Host "Python 버전 확인: $pythonVersion" -ForegroundColor Cyan
    } else {
        throw "Python not found"
    }
} catch {
    Write-Host "오류: Python이 설치되지 않았거나 PATH에 추가되지 않았습니다." -ForegroundColor Red
    Write-Host "Python을 설치하고 PATH에 추가한 후 다시 실행해주세요." -ForegroundColor Yellow
    Read-Host "계속하려면 Enter를 누르세요"
    exit 1
}

Write-Host ""

# 기존 가상환경 삭제 확인
if (Test-Path "venv") {
    Write-Host "기존 가상환경이 발견되었습니다." -ForegroundColor Yellow
    $choice = Read-Host "기존 가상환경을 삭제하고 새로 만드시겠습니까? (y/N)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        Write-Host "기존 가상환경을 삭제합니다..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force "venv"
    } else {
        Write-Host "기존 가상환경을 사용합니다." -ForegroundColor Cyan
        goto ActivateVenv
    }
}

# 가상환경 생성
Write-Host "가상환경을 생성합니다..." -ForegroundColor Cyan
py -m venv venv
if ($LASTEXITCODE -ne 0) {
    Write-Host "오류: 가상환경 생성에 실패했습니다." -ForegroundColor Red
    Read-Host "계속하려면 Enter를 누르세요"
    exit 1
}

:ActivateVenv
# PowerShell 실행 정책 확인 및 설정
$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($currentPolicy -eq "Restricted") {
    Write-Host "PowerShell 실행 정책을 변경합니다..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
}

# 가상환경 활성화
Write-Host "가상환경을 활성화합니다..." -ForegroundColor Cyan
try {
    & ".\venv\Scripts\Activate.ps1"
    if ($LASTEXITCODE -ne 0) {
        throw "Virtual environment activation failed"
    }
} catch {
    Write-Host "오류: 가상환경 활성화에 실패했습니다." -ForegroundColor Red
    Read-Host "계속하려면 Enter를 누르세요"
    exit 1
}

# pip 업그레이드
Write-Host "pip을 최신 버전으로 업그레이드합니다..." -ForegroundColor Cyan
python -m pip install --upgrade pip

# 패키지 설치
Write-Host "필요한 패키지를 설치합니다..." -ForegroundColor Cyan
pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "오류: 패키지 설치에 실패했습니다." -ForegroundColor Red
    Read-Host "계속하려면 Enter를 누르세요"
    exit 1
}

# .env 파일 확인
if (-not (Test-Path ".env")) {
    Write-Host "경고: .env 파일이 없습니다." -ForegroundColor Yellow
    Write-Host "DB 연결을 위해 .env 파일을 생성해주세요." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "가상환경 설정이 완료되었습니다!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "다음 단계:" -ForegroundColor White
Write-Host "1. .env 파일이 있는지 확인하세요" -ForegroundColor Yellow
Write-Host "2. '.\start_server.ps1'를 실행하여 서버를 시작하세요" -ForegroundColor Yellow
Write-Host "3. 또는 수동으로 다음 명령어를 실행하세요:" -ForegroundColor Yellow
Write-Host "   - .\venv\Scripts\Activate.ps1" -ForegroundColor Gray
Write-Host "   - python manage.py makemigrations" -ForegroundColor Gray
Write-Host "   - python manage.py migrate" -ForegroundColor Gray
Write-Host "   - python manage.py runserver 0.0.0.0:41414" -ForegroundColor Gray
Write-Host ""
Read-Host "계속하려면 Enter를 누르세요"