from django.db import models
from .enums import *
from django.contrib.auth.models import User
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from rest_framework.authtoken.models import Token
from geopy.geocoders import Nominatim



class Person(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, null= True)
    first_name = models.CharField(max_length=50, null=False)
    last_name = models.CharField(max_length=50, null=False)
    phone_number = models.CharField(max_length=20, null=False)
    gender = models.CharField(max_length=10, choices=Gender.choices, null=False)
    date_of_birth = models.DateField()
    address = models.CharField(max_length=255, null=False)
    role = models.CharField(max_length=20, choices=Role.choices, null=False)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    def __str__(self):
        return f"{self.first_name} {self.last_name} {self.role}"


class AppUser(models.Model):
    person = models.OneToOneField(Person, on_delete=models.CASCADE, primary_key=True)
    blood_group = models.CharField(max_length=3, choices=BloodGroup.choices, blank=True, null=True)
    number_of_warnings = models.IntegerField(default=0)
    number_of_bans = models.IntegerField(default=0)

    def __str__(self):
        return f"{self.person.first_name} {self.person.last_name}"
    



class Dispatcher(models.Model):
    person = models.OneToOneField(Person, on_delete=models.CASCADE, primary_key=True)
    shift_start_time = models.TimeField()
    shift_end_time = models.TimeField()
    department = models.CharField(max_length=50)
    wilaya = models.CharField(max_length=50, choices=AlgeriaCities.choices, null=False)
    is_available = models.BooleanField(default=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)

    def __str__(self):
        return f"{self.person.first_name} {self.person.last_name}"

    def save(self, *args, **kwargs):
        if self.wilaya and not self.latitude and not self.longitude:
            geolocator = Nominatim(user_agent="dispatcher_app")
            location = geolocator.geocode(f"{self.wilaya}, Algeria")
            if location:
                self.latitude = location.latitude
                self.longitude = location.longitude
        super().save(*args, **kwargs)



class Disease(models.Model):
    disease_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name


class UserDisease(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    disease = models.ForeignKey(Disease, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.user} - {self.disease}"


class PasswordReset(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    confirmation_code = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Password reset request for {self.user.email}"


"""
class Admin(models.Model):
    person = models.OneToOneField(Person, on_delete=models.CASCADE, primary_key=True)


class Volontaire(models.Model):
    person = models.OneToOneField(Person, on_delete=models.CASCADE, primary_key=True)
"""