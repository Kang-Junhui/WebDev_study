from django.urls import path
from . import views

app_name = 'board'

urlpatterns = [
    path('', views.index, name='index'),
    path('write/', views.write, name='write'),
    path('like/<int:post_id>/', views.like_post, name='like_post'),
]