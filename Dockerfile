FROM python:3.11-alpine
LABEL maintainer="hesch"

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED 1

# install dependencies
COPY requirements.txt ./requirements.dev.txt /tmp/
# COPY the project files
COPY ./backend /code
WORKDIR /code
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django_user && \
    chown -R django_user:django_user /code && \
    chmod +x /code/wait_for_db.sh

ENV PATH="/py/bin:$PATH"

USER django_user
