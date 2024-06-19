# backendapp/views.py
from rest_framework import generics,permissions
from django.db.utils import IntegrityError
from .serializers import ItemSerializer
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from .models import Favorite, Item
from .serializers import FavoriteSerializer



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

class FavoriteListCreate(generics.ListCreateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = FavoriteSerializer

    def get_queryset(self):
        return Favorite.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        item_id = self.request.data.get('item')
        item = Item.objects.get(id=item_id)
        favorite, created = Favorite.objects.get_or_create(user=self.request.user, item=item)
        if created:
            serializer.instance = favorite
        else:
            raise IntegrityError("This item is already in the favorites.")

class FavoriteDelete(generics.DestroyAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = FavoriteSerializer
    lookup_field = 'item_id'

    def get_object(self):
        item_id = self.kwargs.get(self.lookup_field)
        return Favorite.objects.get(user=self.request.user, item_id=item_id)

class FavoriteStatus(generics.RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = FavoriteSerializer
    lookup_field = 'item_id'

    def get_object(self):
        item_id = self.kwargs.get(self.lookup_field)
        return Favorite.objects.filter(user=self.request.user, item_id=item_id).first()
class FavoriteList(generics.ListAPIView):
    serializer_class = FavoriteSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Favorite.objects.filter(user=self.request.user)