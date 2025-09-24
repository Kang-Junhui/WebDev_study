# 🤝 Django Board 프로젝트 협업 가이드

이 문서는 Django Board 프로젝트에서 **Repository 내 Branch 협업**을 통해 자동 배포 시스템을 효율적으로 활용하는 방법을 설명합니다.

## 🎯 협업 방식: Repository 내 Branch 협업

이 프로젝트는 **Fork 방식이 아닌** **Repository 내에서 Branch를 생성하여 협업**하는 방식을 사용합니다.

### ✅ 장점
- 모든 개발자가 같은 Repository에서 작업
- Branch 간 동기화 쉬움
- PR 병합 시 자동 배포 즉시 적용
- 프로젝트 히스토리 통합 관리

### 🔄 기본 워크플로우
```bash
# 1. 최신 main 브랜치로 업데이트
git checkout main
git pull origin main

# 2. 새 기능 브랜치 생성
git checkout -b feature/api-enhancement

# 3. 개발 작업
# ... 코드 작성 ...

# 4. 커밋 및 푸시
git add .
git commit -m "API 기능 개선"
git push -u origin feature/api-enhancement

# 5. GitHub에서 PR 생성 및 리뷰
# 6. PR 병합 → 🚀 자동 배포!
```

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

### 시나리오 1: API 엔드포인트 추가
```bash
# 1. 개발자 A: API 기능 브랜치 생성
git checkout main
git pull origin main
git checkout -b feature/user-profile-api
git push -u origin feature/user-profile-api

# 2. 개발자 A: API 개발
# api/views.py에 새 뷰 추가
# api/serializers.py에 시리얼라이저 추가
# api/urls.py에 URL 패턴 추가

git add .
git commit -m "사용자 프로필 API 엔드포인트 추가

- GET /api/users/profile/ 추가
- 사용자 정보 시리얼라이저 구현
- API 문서 업데이트"

git push origin feature/user-profile-api

# 3. GitHub에서 PR 생성
# Title: "사용자 프로필 API 엔드포인트 추가"
# Description: API 구현 내용 상세 설명

# 4. 개발자 B: 코드 리뷰 및 승인
# GitHub에서 Files changed 탭에서 코드 리뷰
# Approve 후 "Merge pull request"

# 5. 🚀 자동 배포 실행!
# 📨 Webhook: "PR #124 병합: 사용자 프로필 API 엔드포인트 추가"
# � 서버 자동 재시작 및 새 API 엔드포인트 활성화
```

### 시나리오 2: 웹 UI 개선
```bash
# 1. 개발자 C: UI 개선 브랜치 생성
git checkout main
git pull origin main
git checkout -b feature/responsive-design
git push -u origin feature/responsive-design

# 2. CSS 및 템플릿 개선 작업
# static/css/style.css 수정
# templates/ 파일들 개선
# 모바일 반응형 디자인 구현

git add .
git commit -m "모바일 반응형 디자인 구현

- 모바일 화면 최적화
- 태블릿 중간 크기 지원  
- 터치 친화적 버튼 크기 조정"

git push origin feature/responsive-design

# 3. 개발자 D: 리뷰 및 병합
# UI 변경사항 확인 후 승인
# 🚀 병합 시 자동 배포로 즉시 UI 업데이트!
```

### 시나리오 3: 데이터베이스 변경 (마이그레이션)
```bash
# 1. 개발자 E: 모델 변경 브랜치 생성
git checkout -b feature/post-category
git push -u origin feature/post-category

# 2. 모델 필드 추가
# board/models.py에서 Post 모델에 category 필드 추가

git add .
git commit -m "게시글 카테고리 기능 추가

- Post 모델에 category 필드 추가
- 마이그레이션 파일 생성
- 관리자 페이지 업데이트"

# 3. 마이그레이션 파일도 함께 커밋
python manage.py makemigrations
git add board/migrations/
git commit -m "카테고리 필드 마이그레이션 추가"
git push origin feature/post-category

# 4. PR 생성 및 병합
# 🚀 자동 배포 시 마이그레이션 자동 실행!
# deploy.sh가 migrate 명령 자동 수행
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

## 📋 Branch 협업 규칙

### ✅ 권장 Branch 명명 규칙
```bash
feature/기능명          # 새 기능 개발
bugfix/버그명           # 버그 수정
hotfix/긴급수정명       # 긴급 수정
improve/개선사항명      # 기능 개선
docs/문서명             # 문서 작업
```

### ✅ 권장 협업 방식
1. **main 브랜치 보호**: 직접 푸시 금지, PR을 통해서만 병합
2. **Feature 브랜치 사용**: 모든 작업은 별도 브랜치에서
3. **코드 리뷰 필수**: 최소 1명의 승인 후 병합
4. **테스트 통과 확인**: GitHub Actions 성공 후 병합
5. **의미있는 커밋**: 자동 배포 로그에 표시되므로 명확하게 작성

### ❌ 지양해야 할 것들
- **main 브랜치 직접 수정**: 항상 PR을 통해 병합
- **거대한 PR**: 작은 단위로 나누어 리뷰 용이하게
- **테스트 실패 무시**: Actions 실패 시 원인 파악 후 해결
- **의미없는 커밋 메시지**: "수정", "변경" 같은 모호한 메시지 지양

## 🔧 Repository 설정 (관리자용)

### Branch Protection Rules 설정
1. **GitHub Repository → Settings → Branches**
2. **Add rule**으로 main 브랜치 보호 규칙 추가:
   ```
   ☑️ Require pull request reviews before merging
   ☑️ Require status checks to pass before merging  
   ☑️ Require up-to-date branches before merging
   ☑️ Include administrators (관리자도 규칙 적용)
   ```

### Collaborator 추가
1. **GitHub Repository → Settings → Collaborators**
2. **Add people**로 팀원 초대
3. **Write** 권한 부여 (Repository 내 브랜치 생성 가능)

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