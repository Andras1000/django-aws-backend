import logging
import time

from django_ecs_aws import celery


@celery.app.task()
def web_task() -> None:
    logging.info("Starting web task...")
    time.sleep(10)
    logging.info("Finished web task.")

@celery.app.task()
def beat_task() -> None:
    logging.info("Starting beat task...")
    time.sleep(10)
    logging.info("Finished beat task.")
