import logging

from django.http import HttpResponse

from django_ecs_aws.tasks import web_task


def create_web_task(request):
    web_task.delay()
    return HttpResponse("Web task created.")
