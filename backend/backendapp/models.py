from django.db import models

# Create your models here.
from django.db import models

class Item(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    image = models.CharField(max_length=255, blank=True, null=True)  # Optionales Feld mit max_length
    ingredients = models.TextField()
    description = models.TextField()
    time = models.IntegerField()
    meat = models.BooleanField(default=True)
    dairy = models.BooleanField(default=True)
    gluten = models.BooleanField(default=True)
    lowsugar = models.BooleanField(default=True)


    def __str__(self):
        return self.name