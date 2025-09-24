# 🤝 Django Board 프로젝트 협업 가이드

이 문서는 Django Board 프로젝트에서 여러 개발자가 협업할 때 자동 배포 시스템을 효율적으로 활용하는 방법을 설명합니다.

## 🎯 자동 배포가 트리거되는 상황

### 1. 직접 Push (Direct Push)
- **언제**: main 브랜치에 직접 커밋을 푸시할 때
- **누가**: 저장소 쓰기 권한이 있는 개발자
- **예시**:
  ```bash
  git add .
  git commit -m "기능 추가"
  git push origin main
  ```

### 2. Pull Request 병합 (PR Merge) ⭐
- **언제**: feature 브랜치의 PR이 main으로 병합될 때
- **누가**: PR을 병합하는 모든 collaborator
- **예시 워크플로우**:
  1. 개발자가 feature 브랜치에서 작업
  2. main으로 PR 생성
  3. 코드 리뷰 후 PR 승인 및 병합
  4. 🚀 **자동 배포 실행!**

### 3. Release 발행 (선택사항)
- **언제**: GitHub에서 새 릴리즈를 발행할 때
- **누가**: 릴리즈 권한이 있는 유지보수자

## 🔄 협업 워크플로우 예시

### 시나리오 1: 새로운 기능 추가
```bash
# 1. 개발자 A: feature 브랜치 생성
git checkout -b feature/user-profile
git push -u origin feature/user-profile

# 2. 개발자 A: 기능 개발 후 커밋
git add .
git commit -m "사용자 프로필 페이지 추가"
git push origin feature/user-profile

# 3. GitHub에서 PR 생성
# Title: "사용자 프로필 페이지 추가"
# Description: 구현 내용 설명

# 4. 개발자 B: 코드 리뷰 후 승인

# 5. 개발자 B 또는 A: PR 병합
# 📨 Webhook 트리거: "PR #123 병합: 사용자 프로필 페이지 추가"
# 🚀 자동 배포 실행!
```

### 시나리오 2: 핫픽스 배포
```bash
# 1. 긴급 수정이 필요한 상황
git checkout -b hotfix/login-bug

# 2. 빠른 수정 후 즉시 배포가 필요한 경우
git add .
git commit -m "로그인 버그 긴급 수정"

# 옵션 A: PR 없이 직접 배포
git checkout main
git merge hotfix/login-bug
git push origin main  # 🚀 즉시 자동 배포

# 옵션 B: 빠른 PR 생성 후 병합
git push origin hotfix/login-bug
# GitHub에서 PR 생성 → 즉시 병합 → 🚀 자동 배포
```

## ⚙️ GitHub Webhook 설정

### Repository 설정자가 해야 할 일:

1. **Webhook 추가**:
   - GitHub Repository → Settings → Webhooks
   - Add webhook 클릭
   - Payload URL: `http://your-server-ip:3000/webhook`
   - Content type: `application/json`

2. **이벤트 선택**:
   ```
   ☑️ Pushes (직접 푸시)
   ☑️ Pull requests (PR 이벤트)
   ☑️ Releases (릴리즈 이벤트, 선택사항)
   ```

3. **Webhook 활성화**:
   - Active 체크박스 선택
   - Add webhook 클릭

### 서버에서 Webhook 서버 실행:
```bash
# 백그라운드에서 실행
nohup python3 webhook_server.py > webhook.log 2>&1 &

# 상태 확인
curl http://localhost:3000/status
```

## 📋 협업 시 주의사항

### ✅ 권장사항
- **Feature 브랜치 사용**: 직접 main에 푸시하지 말고 PR 사용
- **코드 리뷰**: 모든 PR은 최소 1명의 승인 필요
- **테스트 확인**: GitHub Actions가 성공한 후 병합
- **의미있는 커밋 메시지**: 자동 배포 로그에 표시됩니다

### ❌ 주의사항
- **충돌 해결**: 병합 전 conflict 해결 필수
- **테스트 실패**: Actions가 실패하면 병합하지 말 것
- **대량 변경**: 큰 변경사항은 단계적으로 나누어 배포

## 🔍 배포 상태 모니터링

### 1. 실시간 로그 확인
```bash
# 배포 로그 확인
tail -f /home/dna/project_survey/deploy.log

# Django 서버 로그 확인
tail -f /home/dna/project_survey/server.log

# Webhook 로그 확인
tail -f webhook.log
```

### 2. 웹 인터페이스
- **Webhook 서버 상태**: http://localhost:3000
- **Django 앱 상태**: http://localhost:5008
- **API 상태 체크**: http://localhost:3000/status

### 3. 배포 실패 시 대처방안
```bash
# 수동 배포 실행
./deploy.sh

# 서버 상태 확인
ps aux | grep python
netstat -tuln | grep 5008

# 로그 확인으로 문제 파악
tail -50 deploy.log
tail -50 server.log
```

## 🚨 비상 상황 대응

### 배포 실패 시 롤백
```bash
# 1. 이전 커밋으로 롤백
git log --oneline -10  # 이전 커밋 해시 확인
git reset --hard <이전-커밋-해시>
git push --force origin main  # ⚠️ 주의: 강제 푸시

# 2. 수동 재배포
./deploy.sh
```

### 서버 응급 재시작
```bash
# Django 프로세스 강제 종료
pkill -9 -f "python manage.py runserver"

# 수동 서버 시작
source venv/bin/activate
python manage.py runserver 0.0.0.0:5008 &
```

## 📞 문의 및 지원

- **이슈 보고**: GitHub Issues 탭에 버그 리포트 생성
- **기능 요청**: GitHub Issues에 enhancement 라벨로 요청
- **긴급 상황**: 프로젝트 관리자에게 직접 연락

---

**마지막 업데이트**: 2025-09-24  
**문서 버전**: 1.0  
**작성자**: Django Board Team