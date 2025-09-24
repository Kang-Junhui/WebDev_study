# Django 게시판 프로젝트

간단한 게시판 기능을 제공하는 Django 웹 애플리케이션 + REST API

## 🚀 주요 기능

### 웹 애플리케이션
- **게시글 작성**: 제목, 작성자, 내용을 입력하여 글 작성
- **게시글 목록**: 작성된 글들을 최신순으로 조회
- **반응형 디자인**: 모바일과 데스크톱 환경 모두 지원
- **관리자 페이지**: Django Admin을 통한 게시글 관리

### REST API ⭐ NEW!
- **게시글 CRUD API**: 생성, 조회, 수정, 삭제
- **페이지네이션**: 10개씩 페이지 분할
- **API 문서**: 자체 문서 페이지 제공
- **JSON 응답**: 표준 REST API 형태

## 🛠 기술 스택

- **Backend**: Django 5.2.6, Django REST Framework 3.16.1
- **Database**: PostgreSQL
- **Frontend**: HTML5, CSS3, Django Templates
- **Server**: Django Development Server (포트 5008)

## 📦 설치 및 실행

### 1. 필수 소프트웨어 설치

```bash
# PostgreSQL 설치
sudo apt install postgresql postgresql-contrib

# Python 가상환경 도구 설치
sudo apt install python3-venv python3-full
```

### 2. 프로젝트 클론 및 설정

```bash
# 프로젝트 클론
git clone https://github.com/Kang-Junhui/WebDev_study.git
cd WebDev_study

# 가상환경 생성 및 활성화
python3 -m venv venv
source venv/bin/activate

# 의존성 설치
pip install -r requirements.txt
```

### 3. 데이터베이스 설정

```bash
# PostgreSQL 서비스 시작
sudo systemctl start postgresql

# 데이터베이스 및 사용자 설정
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo -u postgres createdb board_db
```

### 4. Django 설정

```bash
# 마이그레이션 실행
python manage.py makemigrations
python manage.py migrate

# 관리자 계정 생성 (선택사항)
python manage.py createsuperuser
```

### 5. 서버 실행

```bash
# 개발 서버 실행
python manage.py runserver 0.0.0.0:5008
```

서버 실행 후 다음 URL에서 확인할 수 있습니다:
- **웹 애플리케이션**: http://localhost:5008
- **REST API**: http://localhost:5008/api/
- **관리자 페이지**: http://localhost:5008/admin

## 📂 프로젝트 구조

```
project_survey/
├── manage.py                    # Django 관리 스크립트
├── requirements.txt             # Python 패키지 의존성
├── board_project/              # Django 프로젝트 설정
│   ├── settings.py             # 프로젝트 설정
│   ├── urls.py                 # URL 라우팅
│   └── wsgi.py                 # WSGI 설정
├── board/                      # 게시판 웹 앱
│   ├── models.py               # 데이터 모델
│   ├── views.py                # 웹 뷰 함수
│   ├── forms.py                # 폼 클래스
│   ├── urls.py                 # 웹 URL 설정
│   └── admin.py                # 관리자 설정
├── api/                        # REST API 앱 ⭐ NEW!
│   ├── views.py                # API 뷰 클래스
│   ├── serializers.py          # API 시리얼라이저
│   └── urls.py                 # API URL 설정
├── templates/                  # HTML 템플릿
│   ├── base.html
│   └── board/
│       ├── index.html
│       └── write.html
├── static/css/                 # CSS 스타일
│   └── style.css
├── .github/workflows/          # GitHub Actions CI/CD
├── deploy.sh                   # 자동 배포 스크립트
├── webhook_server.py          # GitHub 웹훅 서버
└── COLLABORATION.md           # 협업 가이드
```

## 🎯 주요 URL

### 웹 애플리케이션
- **메인 페이지**: `/` - 게시글 목록 조회
- **글쓰기**: `/write/` - 새 게시글 작성
- **관리자**: `/admin/` - Django 관리자 페이지

### REST API
- **API 문서**: `/api/docs/` - API 사용법 문서
- **API 상태**: `/api/status/` - API 서버 상태 확인
- **게시글 목록**: `/api/posts/` - GET (조회), POST (생성)
- **게시글 상세**: `/api/posts/{id}/` - GET (조회), PUT (수정), DELETE (삭제)

## 🔧 API 사용 예시

### 1. 게시글 목록 조회
```bash
curl http://localhost:5008/api/posts/
```

### 2. 새 게시글 생성
```bash
curl -X POST http://localhost:5008/api/posts/ \
  -H "Content-Type: application/json" \
  -d '{
    "title": "API로 작성한 글",
    "author": "API 사용자",
    "content": "REST API를 통해 게시글을 생성했습니다."
  }'
```

### 3. 특정 게시글 조회
```bash
curl http://localhost:5008/api/posts/1/
```

### 4. 게시글 수정
```bash
curl -X PUT http://localhost:5008/api/posts/1/ \
  -H "Content-Type: application/json" \
  -d '{
    "title": "수정된 제목",
    "author": "API 사용자",
    "content": "수정된 내용입니다."
  }'
```

### 5. 게시글 삭제
```bash
curl -X DELETE http://localhost:5008/api/posts/1/
```

## 🔄 협업 및 자동 배포

### Repository 내 Branch 협업 ⭐ 추천 방식
이 프로젝트는 **fork 없이** repository 내에서 branch를 생성하여 협업하는 방식을 지원합니다:

1. **Feature 브랜치 생성**:
   ```bash
   git checkout -b feature/new-api-endpoint
   git push -u origin feature/new-api-endpoint
   ```

2. **개발 후 Pull Request 생성**:
   - GitHub에서 PR 생성
   - 팀원 코드 리뷰

3. **PR 병합 시 자동 배포**:
   - main 브랜치로 병합되면 자동으로 서버 배포
   - GitHub Actions로 테스트 자동 실행

### 자동 배포 설정
자세한 내용은 [COLLABORATION.md](./COLLABORATION.md) 참조

## 📝 모델 구조

### Post 모델
- `title`: 게시글 제목 (CharField, max_length=200)
- `author`: 작성자 (CharField, max_length=50)
- `content`: 게시글 내용 (TextField)
- `created_at`: 작성일시 (DateTimeField, auto_now_add=True)

## 🤝 기여하기

1. Repository를 클론합니다
2. 새로운 기능 브랜치를 만듭니다 (`git checkout -b feature/AmazingFeature`)
3. 변경사항을 커밋합니다 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시합니다 (`git push origin feature/AmazingFeature`)
5. Pull Request를 생성합니다
6. 🚀 **PR 병합 시 자동 배포됩니다!**

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 제공됩니다.

## 📞 문의

프로젝트에 대한 문의사항이 있으시면 이슈를 생성해주세요.