# Minimal Django Backend

This is a Django backend skelenton with 
- Celery beat/worker 
- S3 static file storage
- Dockerfile

## How to run (Docker)

Build the Docker image and run it.

```
docker build . -t django-aws-backend
docker run -p 8000:8000 django-aws-backend gunicorn -b 0.0.0.0:8000 django_ecs_aws.wsgi:application
```
## How to run (no Docker)

Create virtual environment and install Python dependencies.

Run:

```
python manage.py runserver
```
