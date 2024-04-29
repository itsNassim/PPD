from rest_framework import serializers
from django.contrib.auth.models import User
from core.models import *





class PersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = '__all__'

class AppUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = AppUser
        fields = '__all__'

class DispatcherSerializer(serializers.ModelSerializer):
    class Meta:
        model = Dispatcher
        fields = '__all__'


class UserSerializer(serializers.ModelSerializer):
    class Meta(object):
        model = User
        fields = ['id', 'username', 'password', 'email']