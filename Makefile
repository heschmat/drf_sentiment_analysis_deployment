# Variables
DOCKER_COMPOSE=docker compose
SERVICE=web
SERVICE_DB=db

# Commands
startapp:
	$(DOCKER_COMPOSE) run --rm $(SERVICE) sh -c "python manage.py startapp $(name)"

makemigrations:
	$(DOCKER_COMPOSE) run --rm $(SERVICE) sh -c "python manage.py makemigrations"

showmigrations:
	$(DOCKER_COMPOSE) run --rm $(SERVICE) sh -c "python manage.py showmigrations"

shell:
	$(DOCKER_COMPOSE) run --rm $(SERVICE) sh -c "python manage.py shell"

su:
	$(DOCKER_COMPOSE) run --rm $(SERVICE) sh -c "python manage.py createsuperuser"

lint:
	$(DOCKER_COMPOSE) run --rm $(SERVICE) flake8

down:
	$(DOCKER_COMPOSE) down --volumes

up:
	$(DOCKER_COMPOSE) up

build:
	$(DOCKER_COMPOSE) build

build_no_cache:
	$(DOCKER_COMPOSE) build --no-cache

app:
	$(DOCKER_COMPOSE) run --rm $(SERVICE) sh

db:
	$(DOCKER_COMPOSE) run --rm $(SERVICE_DB) sh
