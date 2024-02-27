FROM --platform=linux/amd64 python:3.12.2-bullseye

# Open http port
EXPOSE 8000

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV DEBIAN_FRONTEND noninteractive

# pycurl requirement
RUN apt-get update  \
    && apt-get --no-install-recommends install -y \
        build-essential \
        libssl-dev \
        libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pip and gunicorn web server
RUN pip install --no-cache-dir --upgrade pip
RUN pip install gunicorn==20.1.0

# pg_config requirement
RUN apt-get install libpq-dev -y

# Install requirements.txt
COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

# Moving application files
WORKDIR /app
COPY . /app

RUN ./manage.py collectstatic --noinput