#!/usr/bin/env python3
"""
GitHub Webhook을 받아 자동으로 프로젝트를 업데이트하는 확장된 서버
- Push 이벤트 (직접 푸시)
- Pull Request 병합 이벤트 (협업자 PR 병합)
- Release 이벤트 (태그 기반 배포)
포트 3000에서 실행됩니다.
"""

import subprocess
import json
from http.server import HTTPServer, BaseHTTPRequestHandler
import os
import datetime

def log_event(event_type, message, user=None):
    """이벤트 로깅"""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    user_info = f" (by {user})" if user else ""
    print(f"[{timestamp}] {event_type}{user_info}: {message}")

def deploy_application(trigger_info):
    """애플리케이션 배포 실행"""
    print(f"🚀 배포 시작: {trigger_info}")
    
    result = subprocess.run(['./deploy.sh'], 
                          capture_output=True, 
                          text=True, 
                          cwd='/home/dna/project_survey')
    
    if result.returncode == 0:
        print("✅ 자동 배포 완료")
        print("출력:", result.stdout)
        return {"status": "success", "message": f"배포 완료 - {trigger_info}"}
    else:
        print("❌ 배포 실패")
        print("에러:", result.stderr)
        return {"status": "error", "message": f"배포 실패 - {result.stderr}"}

class WebhookHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/webhook':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            
            # GitHub 이벤트 타입 헤더 확인
            github_event = self.headers.get('X-GitHub-Event', 'unknown')
            
            try:
                payload = json.loads(post_data.decode('utf-8'))
                response_data = {"status": "ignored", "message": "이벤트 무시됨"}
                
                # 1. Push 이벤트 처리 (직접 푸시)
                if github_event == 'push' and payload.get('ref') == 'refs/heads/main':
                    pusher = payload.get('pusher', {}).get('name', 'Unknown')
                    commits = payload.get('commits', [])
                    commit_count = len(commits)
                    
                    log_event("PUSH", f"main 브랜치에 {commit_count}개 커밋", pusher)
                    
                    # 최신 커밋 정보 출력
                    if commits:
                        latest_commit = commits[-1]
                        print(f"   최신 커밋: {latest_commit.get('message', 'No message')}")
                        print(f"   작성자: {latest_commit.get('author', {}).get('name', 'Unknown')}")
                    
                    response_data = deploy_application(f"Push by {pusher}")
                
                # 2. Pull Request 병합 이벤트 처리
                elif github_event == 'pull_request':
                    action = payload.get('action')
                    pr = payload.get('pull_request', {})
                    
                    if action == 'closed' and pr.get('merged') == True:
                        # PR이 main 브랜치로 병합된 경우
                        base_branch = pr.get('base', {}).get('ref')
                        if base_branch == 'main':
                            merger = pr.get('merged_by', {}).get('login', 'Unknown')
                            pr_title = pr.get('title', 'No title')
                            pr_number = pr.get('number', 'Unknown')
                            author = pr.get('user', {}).get('login', 'Unknown')
                            
                            log_event("PR_MERGE", f"PR #{pr_number} 병합: {pr_title}", f"{author} → {merger}")
                            response_data = deploy_application(f"PR #{pr_number} 병합 by {merger}")
                        else:
                            log_event("PR_MERGE", f"다른 브랜치({base_branch})로 병합됨, 배포 생략")
                    else:
                        log_event("PR_EVENT", f"PR 액션: {action} (병합 아님)")
                
                # 3. Release 이벤트 처리 (옵션)
                elif github_event == 'release':
                    action = payload.get('action')
                    if action == 'published':
                        release = payload.get('release', {})
                        tag_name = release.get('tag_name', 'Unknown')
                        author = release.get('author', {}).get('login', 'Unknown')
                        
                        log_event("RELEASE", f"릴리즈 {tag_name} 발행", author)
                        response_data = deploy_application(f"Release {tag_name} by {author}")
                
                # 4. 기타 이벤트
                else:
                    log_event("OTHER", f"지원하지 않는 이벤트: {github_event}")
                
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps(response_data).encode())
                    
            except Exception as e:
                error_msg = f"웹훅 처리 중 오류: {e}"
                log_event("ERROR", error_msg)
                self.send_response(500)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"status": "error", "message": error_msg}).encode())
        else:
            self.send_response(404)
            self.end_headers()
    
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b"""
            <html>
            <head>
                <title>Django Board Webhook Server</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 40px; }
                    .status { background: #e8f5e8; padding: 15px; border-radius: 5px; margin: 10px 0; }
                    .event-type { background: #f0f8ff; padding: 10px; margin: 5px 0; border-left: 4px solid #4CAF50; }
                    code { background: #f4f4f4; padding: 2px 4px; border-radius: 3px; }
                </style>
            </head>
            <body>
                <h1>🎣 Django Board Webhook Server</h1>
                
                <div class="status">
                    <h2>✅ 서버 상태</h2>
                    <p>GitHub webhook 서버가 정상 실행 중입니다.</p>
                    <p><strong>Webhook URL:</strong> <code>/webhook</code></p>
                    <p><strong>Django Board:</strong> <a href="http://localhost:5008">http://localhost:5008</a></p>
                </div>
                
                <h2>🔄 지원하는 자동 배포 이벤트</h2>
                
                <div class="event-type">
                    <h3>1. 직접 Push (Direct Push)</h3>
                    <p>• <strong>트리거:</strong> main 브랜치에 직접 푸시</p>
                    <p>• <strong>예시:</strong> <code>git push origin main</code></p>
                </div>
                
                <div class="event-type">
                    <h3>2. Pull Request 병합 (PR Merge)</h3>
                    <p>• <strong>트리거:</strong> main 브랜치로 PR 병합 완료</p>
                    <p>• <strong>예시:</strong> 협업자가 feature 브랜치를 main으로 병합</p>
                </div>
                
                <div class="event-type">
                    <h3>3. Release 발행 (Release)</h3>
                    <p>• <strong>트리거:</strong> GitHub Release 발행</p>
                    <p>• <strong>예시:</strong> 새로운 버전 태그 릴리즈</p>
                </div>
                
                <h2>⚙️ GitHub Webhook 설정</h2>
                <ol>
                    <li>GitHub Repository → Settings → Webhooks</li>
                    <li>Add webhook 클릭</li>
                    <li>Payload URL: <code>http://your-server:3000/webhook</code></li>
                    <li>Content type: <code>application/json</code></li>
                    <li>이벤트 선택:
                        <ul>
                            <li>☑️ Pushes</li>
                            <li>☑️ Pull requests</li>
                            <li>☑️ Releases (선택사항)</li>
                        </ul>
                    </li>
                    <li>Active 체크 후 Add webhook</li>
                </ol>
                
                <p><em>마지막 업데이트: 2025-09-24</em></p>
            </body>
            </html>
            """)
        elif self.path == '/status':
            # 간단한 상태 API
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            
            # Django 서버 상태 확인
            try:
                import urllib.request
                urllib.request.urlopen('http://localhost:5008', timeout=3)
                django_status = "running"
            except:
                django_status = "stopped"
            
            status_info = {
                "webhook_server": "running",
                "django_app": django_status,
                "timestamp": datetime.datetime.now().isoformat(),
                "supported_events": ["push", "pull_request", "release"]
            }
            
            self.wfile.write(json.dumps(status_info, indent=2).encode())
        else:
            self.send_response(404)
            self.end_headers()

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 3000), WebhookHandler)
    print("🎣 GitHub Webhook 서버 시작: http://localhost:3000")
    print("📝 Webhook URL: http://localhost:3000/webhook")
    print("🔄 main 브랜치 push 시 자동으로 배포됩니다.")
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Webhook 서버를 중지합니다.")
        server.shutdown()