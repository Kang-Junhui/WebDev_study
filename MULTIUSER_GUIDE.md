# 🚀 다중 사용자 Django 서버 실행 가이드

## 📋 개요
여러 명이 동시에 같은 PostgreSQL 데이터베이스에 접속하여 Django 서버를 실행할 수 있습니다.
각자 다른 포트를 사용하여 서버를 실행하면 됩니다.

## ⚡ 빠른 시작

### 사용자 1 (기본 포트 사용)
```powershell
# PowerShell
.\start_server.ps1

# 또는 CMD
start_server.bat
```
**접속 주소**: http://localhost:41414

### 사용자 2 (다른 포트 사용)
```powershell
# PowerShell
.\start_server_multiuser.ps1 -Port 41415 -UserName "사용자2"

# 또는 CMD
start_server_multiuser.bat 41415 사용자2
```
**접속 주소**: http://localhost:41415

### 사용자 3 (또 다른 포트 사용)
```powershell
# PowerShell
.\start_server_multiuser.ps1 -Port 41416 -UserName "사용자3"

# 또는 CMD
start_server_multiuser.bat 41416 사용자3
```
**접속 주소**: http://localhost:41416

## 🌐 외부 접속
외부에서 접속할 때는 `scjune123.iptime.org`를 사용:
- 사용자 1: http://scjune123.iptime.org:41414
- 사용자 2: http://scjune123.iptime.org:41415
- 사용자 3: http://scjune123.iptime.org:41416

## 💾 데이터베이스 공유
- **모든 사용자가 같은 PostgreSQL 데이터베이스 사용**
- **실시간 데이터 공유**: 한 사용자가 게시글을 작성하면 다른 사용자들도 즉시 볼 수 있음
- **동시 작업 가능**: 여러 명이 동시에 게시글 작성/수정 가능

## ⚠️ 주의사항

### 포트 충돌 방지
- 같은 포트 번호를 동시에 사용할 수 없음
- 각자 다른 포트 번호 사용 (41414, 41415, 41416, ...)

### 데이터베이스 동시성
- 동시에 같은 데이터를 수정할 때 마지막 저장이 우선됨
- 중요한 작업 시에는 서로 소통하여 충돌 방지

### 추천 포트 번호
- 사용자 1: **41414** (기본)
- 사용자 2: **41415**
- 사용자 3: **41416**
- 사용자 4: **41417**
- 사용자 5: **41418**

## 🔧 문제 해결

### 포트가 이미 사용 중인 경우
```
포트 41414가 이미 사용 중입니다.
```
→ 다른 포트 번호를 사용하세요.

### 데이터베이스 연결 오류
```
django.db.utils.OperationalError
```
→ `scjune123.iptime.org:4141` 서버가 실행 중인지 확인하세요.

## 📱 API 테스트
각 서버에서 REST API도 사용 가능:
- API 문서: http://localhost:[포트번호]/api/
- 게시글 목록: http://localhost:[포트번호]/api/posts/
- 관리자 페이지: http://localhost:[포트번호]/admin/

## 🎯 팀 작업 시나리오
1. **개발자 A**: 게시글 목록 페이지 작업 (포트 41414)
2. **개발자 B**: 게시글 작성 페이지 작업 (포트 41415)  
3. **개발자 C**: API 엔드포인트 테스트 (포트 41416)
4. **QA 담당자**: 전체 기능 테스트 (포트 41417)

모든 작업자가 실시간으로 같은 데이터를 공유하면서 개발할 수 있습니다!