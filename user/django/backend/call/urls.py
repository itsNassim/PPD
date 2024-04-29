from django.urls import path,re_path
from . import views

urlpatterns = [
    re_path('user/', views.getUserLocationn),
    re_path('dispatcher/', views.login),
    re_path('signup/', views.signup),
    re_path('signup2/', views.signup2),
    re_path('test_token/', views.test_token),
]