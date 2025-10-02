from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.http import JsonResponse
from .models import Post
from .forms import PostForm

def index(request):
    """메인 페이지 - 게시글 목록 표시"""
    posts = Post.objects.all()
    return render(request, 'board/index.html', {'posts': posts})

def write(request):
    """글쓰기 페이지"""
    if request.method == 'POST':
        form = PostForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, '글이 성공적으로 등록되었습니다.')
            return redirect('board:index')
    else:
        form = PostForm()
    
    return render(request, 'board/write.html', {'form': form})

def like_post(request, post_id):
    """게시글 추천 기능"""
    if request.method == 'POST':
        post = get_object_or_404(Post, id=post_id)
        post.likes_count += 1
        post.save()
        return JsonResponse({'likes_count': post.likes_count})
    return JsonResponse({'error': 'Invalid request'}, status=400)
