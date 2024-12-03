FROM python:3.11-alpine
LABEL maintainer="hesch"

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED 1

# Install dependencies and update Alpine package index
COPY requirements.txt ./requirements.dev.txt /tmp/
# COPY the project files
COPY ./backend /code
# COPY the helper scripts run by the docker app.
COPY ./scripts /scripts
WORKDIR /code
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    apk update && \
    # Install pg_isready:
    apk add --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        # We need a C compiler to build uWSGI:
        build-base \
        musl-dev \
        # `linux-headers is a requirement for the uwsgi installation:
        linux-headers && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    chmod +x /code/wait_for_db.sh && \
    chmod -R +x /scripts && \
    adduser --disabled-password --no-create-home django_user && \
    mkdir -p /vol/web/static && chmod -R 755 /vol && \
    chown -R django_user:django_user /code /vol

ENV PATH="/scripts:/py/bin:$PATH"

USER django_user

CMD ["run.sh"]
