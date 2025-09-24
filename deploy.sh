#!/bin/bash

# Django 게시판 프로젝트 자동 업데이트 및 재시작 스크립트

PROJECT_DIR="/home/dna/project_survey"
VENV_PATH="$PROJECT_DIR/venv"

echo "🔄 Django Board 자동 업데이트 시작..."

# 프로젝트 디렉토리로 이동
cd $PROJECT_DIR

# Git에서 최신 코드 가져오기
echo "📥 최신 코드 가져오는 중..."
git pull origin main

# 가상환경 활성화
echo "🐍 가상환경 활성화..."
source $VENV_PATH/bin/activate

# 의존성 업데이트
echo "📦 의존성 업데이트..."
pip install -r requirements.txt

# Django 마이그레이션
echo "🗄️ 데이터베이스 마이그레이션..."
python manage.py migrate

# 정적 파일 수집 (프로덕션 환경에서)
# python manage.py collectstatic --noinput

# 기존 서버 프로세스 종료
echo "🛑 기존 서버 프로세스 종료..."
pkill -f "python manage.py runserver"

# 잠시 대기
sleep 2

# 서버 재시작
echo "🚀 서버 재시작..."
nohup python manage.py runserver 0.0.0.0:5008 > server.log 2>&1 &

echo "✅ Django Board 자동 업데이트 완료!"
echo "🌐 서버가 http://localhost:5008 에서 실행 중입니다."

# 서버 상태 확인
sleep 3
if curl -f http://localhost:5008 > /dev/null 2>&1; then
    echo "✅ 서버가 정상적으로 실행되고 있습니다!"
else
    echo "❌ 서버 시작에 문제가 있습니다. server.log를 확인하세요."
fi