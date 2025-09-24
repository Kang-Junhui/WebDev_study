#!/usr/bin/env python3
"""
GitHub Webhook을 받아 자동으로 프로젝트를 업데이트하는 간단한 서버
포트 3000에서 실행됩니다.
"""

import subprocess
import json
from http.server import HTTPServer, BaseHTTPRequestHandler
import os

class WebhookHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/webhook':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            
            try:
                payload = json.loads(post_data.decode('utf-8'))
                
                # GitHub에서 오는 push 이벤트인지 확인
                if 'ref' in payload and payload['ref'] == 'refs/heads/main':
                    print("📨 GitHub webhook 수신: main 브랜치 업데이트")
                    
                    # 배포 스크립트 실행
                    result = subprocess.run(['./deploy.sh'], 
                                          capture_output=True, 
                                          text=True, 
                                          cwd='/home/dna/project_survey')
                    
                    print("✅ 자동 배포 완료")
                    print("출력:", result.stdout)
                    if result.stderr:
                        print("에러:", result.stderr)
                    
                    self.send_response(200)
                    self.send_header('Content-type', 'application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps({"status": "success", "message": "배포 완료"}).encode())
                else:
                    self.send_response(200)
                    self.send_header('Content-type', 'application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps({"status": "ignored", "message": "main 브랜치가 아님"}).encode())
                    
            except Exception as e:
                print(f"❌ 웹훅 처리 중 오류: {e}")
                self.send_response(500)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"status": "error", "message": str(e)}).encode())
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
            <head><title>Django Board Webhook Server</title></head>
            <body>
                <h1>Django Board Webhook Server</h1>
                <p>GitHub webhook 서버가 정상 실행 중입니다.</p>
                <p>Webhook URL: <code>/webhook</code></p>
                <p>Django Board: <a href="http://localhost:5008">http://localhost:5008</a></p>
            </body>
            </html>
            """)
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