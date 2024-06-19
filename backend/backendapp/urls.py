from django.urls import path, include
from .views import ItemListCreate, ItemDetail, FavoriteListCreate,FavoriteStatus, FavoriteDelete
from .views import update_username, update_password

urlpatterns = [
    path('items/', ItemListCreate.as_view(), name='item-list-create'),
    path('items/<int:pk>/', ItemDetail.as_view(), name='item-detail'),
    path('auth/', include('dj_rest_auth.urls')),
    path('auth/registration/', include('dj_rest_auth.registration.urls')),
    path('auth/update-username/', update_username, name='update-username'),
    path('auth/update-password/', update_password, name='update-password'),
    path('favorites/', FavoriteListCreate.as_view(), name='favorite-list-create'),
    path('favorites/<int:item_id>/', FavoriteDelete.as_view(), name='favorite-delete'),
    path('favorites/status/<int:item_id>/', FavoriteStatus.as_view(), name='favorite-status'),
]
