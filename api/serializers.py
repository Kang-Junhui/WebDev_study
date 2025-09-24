from rest_framework import serializers
from board.models import Post

class PostSerializer(serializers.ModelSerializer):
    """게시글 시리얼라이저"""
    
    class Meta:
        model = Post
        fields = ['id', 'title', 'author', 'content', 'created_at']
        read_only_fields = ['id', 'created_at']
    
    def validate_title(self, value):
        """제목 유효성 검사"""
        if len(value.strip()) < 2:
            raise serializers.ValidationError("제목은 최소 2자 이상이어야 합니다.")
        return value.strip()
    
    def validate_author(self, value):
        """작성자 유효성 검사"""
        if len(value.strip()) < 1:
            raise serializers.ValidationError("작성자명을 입력해주세요.")
        return value.strip()
    
    def validate_content(self, value):
        """내용 유효성 검사"""
        if len(value.strip()) < 10:
            raise serializers.ValidationError("내용은 최소 10자 이상이어야 합니다.")
        return value.strip()

class PostListSerializer(serializers.ModelSerializer):
    """게시글 목록용 시리얼라이저 (간소화)"""
    
    content_preview = serializers.SerializerMethodField()
    
    class Meta:
        model = Post
        fields = ['id', 'title', 'author', 'content_preview', 'created_at']
    
    def get_content_preview(self, obj):
        """내용 미리보기 (50자 제한)"""
        return obj.content[:50] + '...' if len(obj.content) > 50 else obj.content