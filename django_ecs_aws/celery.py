import os

from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_ecs_aws.settings')

app = Celery('django_ecs_aws')

app.config_from_object('django.conf:settings', namespace='CELERY')

app.autodiscover_tasks()
