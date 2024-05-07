from django.urls import path,re_path
from . import views

urlpatterns = [
    #log in
    re_path('login/', views.login),
    re_path('login/dispatcher/', views.login),
    #sign up
    re_path('signup/', views.signup),
    re_path('signup2/', views.signup2),
    #get info
    re_path('getUserInfo/', views.get_user_info),
    re_path('getPersonInfo/', views.get_person_info),
    re_path('getAppUserInfo/', views.get_appuser_info),
    re_path('getDiseases/', views.get_diseases),
    re_path('getUserDiseases/', views.get_user_diseases),
    re_path('addUserDiseases/', views.add_user_diseases),
    re_path('deleteUserDiseases/', views.delete_user_disease),
    #modify info
    re_path('modifyUserInfo/', views.update_user_info),
    re_path('modifyPersonInfo/', views.update_person_info),
    re_path('modifyAppUserInfo/', views.update_appuser_info),
    #delete acount
    re_path('deleteUser/', views.deleteAccount),
    #password reset
    re_path('sendcode/', views.request_password_recovery),
    re_path('resend/', views.resend),
    re_path('confirmcode/', views.confirm_password_reset),
    re_path('restpassword/', views.change_password), 

]