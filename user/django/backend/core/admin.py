from django.contrib import admin
from .models import *

admin.site.register(Person)
admin.site.register(AppUser)
admin.site.register(Dispatcher)
admin.site.register(Disease)
admin.site.register(UserDisease)
admin.site.register(PasswordReset)
