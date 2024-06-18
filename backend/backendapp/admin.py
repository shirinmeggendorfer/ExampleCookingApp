from django.contrib import admin

# Register your models here.
# backend/backendapp/admin.py

from .models import Item

admin.site.register(Item)
