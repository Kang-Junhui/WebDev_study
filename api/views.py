from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from board.models import Post
from .serializers import PostSerializer, PostListSerializer

class PostListCreateAPIView(generics.ListCreateAPIView):
    """
    게시글 목록 조회 및 생성 API
    GET: 게시글 목록 반환
    POST: 새 게시글 생성
    """
    queryset = Post.objects.all()
    
    def get_serializer_class(self):
        if self.request.method == 'GET':
            return PostListSerializer
        return PostSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        
        return Response({
            'message': '게시글이 성공적으로 생성되었습니다.',
            'data': serializer.data
        }, status=status.HTTP_201_CREATED, headers=headers)

class PostDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
    """
    게시글 상세 조회, 수정, 삭제 API
    GET: 특정 게시글 조회
    PUT/PATCH: 게시글 수정
    DELETE: 게시글 삭제
    """
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    
    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        
        return Response({
            'message': '게시글이 성공적으로 수정되었습니다.',
            'data': serializer.data
        })
    
    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response({
            'message': '게시글이 성공적으로 삭제되었습니다.'
        }, status=status.HTTP_200_OK)

@api_view(['GET'])
def api_status(request):
    """
    API 상태 확인 엔드포인트
    """
    post_count = Post.objects.count()
    
    return Response({
        'status': 'active',
        'message': 'Django Board API가 정상적으로 작동 중입니다.',
        'version': '1.0.0',
        'total_posts': post_count,
        'endpoints': {
            'posts': '/api/posts/',
            'post_detail': '/api/posts/{id}/',
            'status': '/api/status/',
        }
    })

@api_view(['GET']) 
def api_docs(request):
    """
    간단한 API 문서
    """
    docs = {
        'title': 'Django Board API Documentation',
        'version': '1.0.0',
        'base_url': request.build_absolute_uri('/api/'),
        'endpoints': [
            {
                'url': '/api/status/',
                'method': 'GET',
                'description': 'API 상태 확인'
            },
            {
                'url': '/api/posts/',
                'method': 'GET',
                'description': '게시글 목록 조회',
                'parameters': {
                    'page': '페이지 번호 (기본: 1)',
                    'page_size': '페이지당 항목 수 (기본: 10)'
                }
            },
            {
                'url': '/api/posts/',
                'method': 'POST',
                'description': '새 게시글 생성',
                'required_fields': ['title', 'author', 'content'],
                'example': {
                    'title': '게시글 제목',
                    'author': '작성자명',
                    'content': '게시글 내용 (최소 10자)'
                }
            },
            {
                'url': '/api/posts/{id}/',
                'method': 'GET',
                'description': '특정 게시글 조회'
            },
            {
                'url': '/api/posts/{id}/',
                'method': 'PUT/PATCH',
                'description': '게시글 수정'
            },
            {
                'url': '/api/posts/{id}/',
                'method': 'DELETE',
                'description': '게시글 삭제'
            }
        ],
        'response_format': {
            'success': {
                'message': 'Success message',
                'data': 'Response data'
            },
            'error': {
                'detail': 'Error message'
            }
        }
    }
    
    return Response(docs)
