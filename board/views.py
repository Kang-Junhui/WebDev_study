from django.shortcuts import render, redirect
from django.contrib import messages
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
