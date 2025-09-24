# Django 게시판 프로젝트

간단한 게시판 기능을 제공하는 Django 웹 애플리케이션입니다.

## 🚀 주요 기능

- **게시글 작성**: 제목, 작성자, 내용을 입력하여 글 작성
- **게시글 목록**: 작성된 글들을 최신순으로 조회
- **반응형 디자인**: 모바일과 데스크톱 환경 모두 지원
- **관리자 페이지**: Django Admin을 통한 게시글 관리

## 🛠 기술 스택

- **Backend**: Django 5.2.6
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

서버 실행 후 `http://localhost:5008`에서 애플리케이션을 확인할 수 있습니다.

## 📂 프로젝트 구조

```
project_survey/
├── manage.py                    # Django 관리 스크립트
├── requirements.txt             # Python 패키지 의존성
├── board_project/              # Django 프로젝트 설정
│   ├── settings.py             # 프로젝트 설정
│   ├── urls.py                 # URL 라우팅
│   └── wsgi.py                 # WSGI 설정
├── board/                      # 게시판 앱
│   ├── models.py               # 데이터 모델
│   ├── views.py                # 뷰 함수
│   ├── forms.py                # 폼 클래스
│   ├── urls.py                 # 앱 URL 설정
│   └── admin.py                # 관리자 설정
├── templates/                  # HTML 템플릿
│   ├── base.html
│   └── board/
│       ├── index.html
│       └── write.html
└── static/css/                 # CSS 스타일
    └── style.css
```

## 🎯 주요 URL

- **메인 페이지**: `/` - 게시글 목록 조회
- **글쓰기**: `/write/` - 새 게시글 작성
- **관리자**: `/admin/` - Django 관리자 페이지

## 🔧 개발 환경

- Python 3.12+
- Django 5.2.6
- PostgreSQL 16
- Ubuntu 24.04

## 📝 모델 구조

### Post 모델
- `title`: 게시글 제목 (CharField, max_length=200)
- `author`: 작성자 (CharField, max_length=50)
- `content`: 게시글 내용 (TextField)
- `created_at`: 작성일시 (DateTimeField, auto_now_add=True)

## 🤝 기여하기

1. 이 저장소를 포크합니다
2. 새로운 기능 브랜치를 만듭니다 (`git checkout -b feature/AmazingFeature`)
3. 변경사항을 커밋합니다 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시합니다 (`git push origin feature/AmazingFeature`)
5. Pull Request를 생성합니다

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 제공됩니다.

## 📞 문의

프로젝트에 대한 문의사항이 있으시면 이슈를 생성해주세요.