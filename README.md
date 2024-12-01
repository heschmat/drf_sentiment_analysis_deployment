# drf_sentiment_analysis_deployment

## Setup the initial files:

```sh
touch Dockerfile .dockerignore docker-compose.yml .env requirements.txt requirements.dev.txt .flake8
mkdir backend  # the django app goes here
```

Next we have to think about the database being ready

```sh
touch ./backend/wait_for_db.sh
```
