from django.urls import path
from . import views

app_name = 'api'

urlpatterns = [
    # API 상태 및 문서
    path('status/', views.api_status, name='api_status'),
    path('docs/', views.api_docs, name='api_docs'),
    
    # 게시글 API
    path('posts/', views.PostListCreateAPIView.as_view(), name='post_list_create'),
    path('posts/<int:pk>/', views.PostDetailAPIView.as_view(), name='post_detail'),
]