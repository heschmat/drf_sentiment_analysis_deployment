FROM python:3.11-alpine
LABEL maintainer="hesch"

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED 1

# Install dependencies and update Alpine package index
COPY requirements.txt ./requirements.dev.txt /tmp/
# COPY the project files
COPY ./backend /code
WORKDIR /code
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    apk update && \
    # Install pg_isready:
    apk add --no-cache postgresql-client && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    chmod +x /code/wait_for_db.sh && \
    adduser --disabled-password --no-create-home django_user && \
    chown -R django_user:django_user /code

ENV PATH="/py/bin:$PATH"

USER django_user
