# backendapp/serializers.py
from rest_framework import serializers
from .models import Item
from rest_framework.authtoken.models import Token



class ItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = Item
        fields = '__all__'

class CustomTokenSerializer(serializers.ModelSerializer):
    class Meta:
        model = Token
        fields = ('key', 'user')