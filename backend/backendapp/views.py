# backendapp/views.py
from rest_framework import generics
from .models import Item
from .serializers import ItemSerializer
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password



class ItemListCreate(generics.ListCreateAPIView):
    queryset = Item.objects.all()
    serializer_class = ItemSerializer

class ItemDetail(generics.RetrieveAPIView):
    queryset = Item.objects.all()
    serializer_class = ItemSerializer


@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_username(request):
    user = request.user
    new_username = request.data.get('username')
    if new_username:
        user.username = new_username
        user.save()
        return Response({'status': 'username updated'})
    return Response({'error': 'invalid request'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_password(request):
    user = request.user
    new_password = request.data.get('password')
    if new_password:
        user.password = make_password(new_password)
        user.save()
        return Response({'status': 'password updated'})
    return Response({'error': 'invalid request'}, status=status.HTTP_400_BAD_REQUEST)