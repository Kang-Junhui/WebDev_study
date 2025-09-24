#!/bin/bash

# Django 게시판 프로젝트 자동 업데이트 및 재시작 스크립트 (확장 버전)

PROJECT_DIR="/home/dna/project_survey"
VENV_PATH="$PROJECT_DIR/venv"
LOG_FILE="$PROJECT_DIR/deploy.log"

# 로그 함수
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 배포 시작
log_message "� Django Board 자동 업데이트 시작..."

# 프로젝트 디렉토리로 이동
cd $PROJECT_DIR || exit 1

# 배포 전 정보 수집
BEFORE_COMMIT=$(git rev-parse HEAD)
BEFORE_BRANCH=$(git branch --show-current)

log_message "📋 배포 전 상태:"
log_message "   현재 브랜치: $BEFORE_BRANCH"
log_message "   현재 커밋: $BEFORE_COMMIT"

# Git에서 최신 코드 가져오기
log_message "📥 최신 코드 가져오는 중..."
if git pull origin main; then
    log_message "✅ Git pull 성공"
else
    log_message "❌ Git pull 실패"
    exit 1
fi

# 변경사항 확인
AFTER_COMMIT=$(git rev-parse HEAD)
if [ "$BEFORE_COMMIT" != "$AFTER_COMMIT" ]; then
    log_message "📝 감지된 변경사항:"
    git log --oneline --graph --decorate $BEFORE_COMMIT..$AFTER_COMMIT | tee -a "$LOG_FILE"
    
    # 변경된 파일 목록
    log_message "📁 변경된 파일들:"
    git diff --name-only $BEFORE_COMMIT $AFTER_COMMIT | tee -a "$LOG_FILE"
else
    log_message "ℹ️ 새로운 변경사항 없음"
fi

# 가상환경 활성화
log_message "🐍 가상환경 활성화..."
source $VENV_PATH/bin/activate

# 의존성 업데이트 확인
log_message "📦 의존성 확인 및 업데이트..."
if git diff --name-only $BEFORE_COMMIT $AFTER_COMMIT | grep -q "requirements.txt"; then
    log_message "   requirements.txt 변경 감지 - 의존성 업데이트 실행"
    pip install -r requirements.txt
else
    log_message "   requirements.txt 변경 없음 - 의존성 업데이트 생략"
fi

# Django 마이그레이션 확인
log_message "🗄️ 데이터베이스 마이그레이션..."
if find . -name "migrations" -type d -exec find {} -name "*.py" -newer "$LOG_FILE" \; | head -1 | grep -q .; then
    log_message "   새로운 마이그레이션 파일 감지 - 마이그레이션 실행"
    python manage.py migrate
else
    log_message "   새로운 마이그레이션 없음 - 마이그레이션 생략"
    # 안전을 위해 마이그레이션은 항상 실행
    python manage.py migrate --run-syncdb
fi

# 정적 파일 수집 (프로덕션 환경에서)
if [ "$DJANGO_ENV" = "production" ]; then
    log_message "📁 정적 파일 수집..."
    python manage.py collectstatic --noinput
fi

# 기존 서버 프로세스 종료
log_message "🛑 기존 서버 프로세스 종료..."
DJANGO_PID=$(pgrep -f "python manage.py runserver")
if [ ! -z "$DJANGO_PID" ]; then
    kill $DJANGO_PID
    log_message "   PID $DJANGO_PID 종료됨"
    sleep 3
    
    # 강제 종료 확인
    if kill -0 $DJANGO_PID 2>/dev/null; then
        log_message "   강제 종료 실행..."
        kill -9 $DJANGO_PID
    fi
else
    log_message "   실행 중인 Django 프로세스 없음"
fi

# 서버 재시작
log_message "🚀 서버 재시작..."
nohup python manage.py runserver 0.0.0.0:5008 > server.log 2>&1 &
NEW_PID=$!
log_message "   새 서버 PID: $NEW_PID"

log_message "✅ Django Board 자동 업데이트 완료!"
log_message "🌐 서버가 http://localhost:5008 에서 실행 중입니다."

# 서버 상태 확인 (최대 30초 대기)
log_message "🔍 서버 상태 확인 중..."
for i in {1..10}; do
    sleep 3
    if curl -f -s http://localhost:5008 > /dev/null 2>&1; then
        log_message "✅ 서버가 정상적으로 실행되고 있습니다! (${i}번째 시도에서 성공)"
        
        # 배포 완료 알림
        log_message "🎉 배포 성공 요약:"
        log_message "   이전 커밋: $BEFORE_COMMIT"
        log_message "   현재 커밋: $AFTER_COMMIT"
        log_message "   서버 PID: $NEW_PID"
        log_message "   배포 시간: $(date)"
        
        exit 0
    fi
    log_message "   서버 응답 대기 중... (${i}/10)"
done

log_message "❌ 서버 시작에 문제가 있습니다. server.log를 확인하세요."
log_message "🔧 디버깅 정보:"
log_message "   Django 프로세스: $(pgrep -f 'python manage.py runserver' || echo 'None')"
log_message "   포트 5008 상태: $(netstat -tuln | grep :5008 || echo 'Not listening')"

exit 1