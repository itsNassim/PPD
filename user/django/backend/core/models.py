from django.db import models
from .enums import Gender, Role, BloodGroup
from django.contrib.auth.models import User
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from rest_framework.authtoken.models import Token




class Person(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, null= True)
    # Add additional fields from the Person model
    first_name = models.CharField(max_length=50, null=False)
    last_name = models.CharField(max_length=50, null=False)
    phone_number = models.CharField(max_length=20, null=False)
    gender = models.CharField(max_length=10, choices=Gender.choices, null=False)
    date_of_birth = models.DateField()
    place_of_birth = models.CharField(max_length=50, null=False)
    address = models.CharField(max_length=255, null=False)
    role = models.CharField(max_length=20, choices=Role.choices, null=False)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)




"""class Diseases(models.Model):
    name = models.CharField(max_length=100)

    class Meta:
        verbose_name = "Disease"
        verbose_name_plural = "Diseases"

class User(models.Model):
    person = models.OneToOneField(Person, on_delete=models.CASCADE, primary_key=True)
    blood_group = models.CharField(max_length=3, choices=BloodGroup.choices, blank=True, null=True)
    number_of_warnings = models.IntegerField(default=0)
    number_of_bans = models.IntegerField(default=0)
    last_connection_date = models.DateTimeField(blank=True, null=True)
    registration_date = models.DateField(auto_now_add=True)
 
    class Meta:
        verbose_name = "User"
        verbose_name_plural = "Users"



class Admin(models.Model):
    person = models.OneToOneField(Person, on_delete=models.CASCADE, primary_key=True)

class Dispatcher(models.Model):
    person = models.OneToOneField(Person, on_delete=models.CASCADE, primary_key=True)

class Volontaire(models.Model):
    person = models.OneToOneField(Person, on_delete=models.CASCADE, primary_key=True)
"""