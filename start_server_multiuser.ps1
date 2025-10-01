# 다중 사용자를 위한 Django 서버 시작 스크립트
param(
    [int]$Port = 41414,
    [string]$UserName = "User"
)

Write-Host "Django 개발 서버를 시작합니다... ($UserName - Port: $Port)" -ForegroundColor Green

# 가상환경 활성화
if (Test-Path "venv\Scripts\Activate.ps1") {
    & "venv\Scripts\Activate.ps1"
} elseif (Test-Path ".venv\Scripts\Activate.ps1") {
    & ".venv\Scripts\Activate.ps1"
} else {
    Write-Host "가상환경을 찾을 수 없습니다. setup_windows.ps1을 먼저 실행하세요." -ForegroundColor Red
    exit 1
}

# 포트 사용 여부 확인
$portInUse = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "포트 $Port 가 이미 사용 중입니다." -ForegroundColor Red
    Write-Host "다른 포트를 사용하려면 다음과 같이 실행하세요:" -ForegroundColor Yellow
    Write-Host ".\start_server_multiuser.ps1 -Port 41415 -UserName '사용자2'" -ForegroundColor Cyan
    exit 1
}

# 서버 시작
Write-Host "서버를 포트 $Port 에서 시작합니다... (사용자: $UserName)" -ForegroundColor Yellow
Write-Host "브라우저에서 다음 주소로 접속하세요:" -ForegroundColor Cyan
Write-Host "  - 로컬: http://localhost:$Port" -ForegroundColor Cyan
Write-Host "  - 외부: http://scjune123.iptime.org:$Port" -ForegroundColor Cyan
Write-Host ""
Write-Host "서버를 중지하려면 Ctrl+C를 누르세요." -ForegroundColor Magenta
Write-Host ""

python manage.py runserver 0.0.0.0:$Port