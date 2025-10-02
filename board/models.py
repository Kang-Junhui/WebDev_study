from django.db import models
from django.utils import timezone

class Post(models.Model):
    title = models.CharField(max_length=200, verbose_name='제목')
    author = models.CharField(max_length=50, verbose_name='작성자')
    content = models.TextField(verbose_name='내용')
    created_at = models.DateTimeField(default=timezone.now, verbose_name='작성일')
    likes_count = models.IntegerField(default=0, verbose_name='추천수')
    
    class Meta:
        ordering = ['-created_at']  # 최신순 정렬
        verbose_name = '게시글'
        verbose_name_plural = '게시글'
    
    def __str__(self):
        return self.title
