# drf_sentiment_analysis_deployment

## Setup the initial files:

```sh
touch Dockerfile .dockerignore docker-compose.yml .env requirements.txt requirements.dev.txt
mkdir backend  # the django app goes here
```

Next we have to think about the database being ready

```sh
cd ./backend
touch .flake8 wait_for_db.sh

# give `wait_for_db.sh` executable permission:
chmode +x wait_for_db.sh
```

Start the django project:

```sh
docker compose run --rm web sh -c "django-admin startproject config ."

```

Create `Makefile` to have alias for long commands:

```sh
touch Makefile
make startapp name=ml_api
```

Register our local app, `ml_api` & `rest_framework` app in the `config/settings.py`

```py
INSTALLED_APPS += [
    # 3rd-party apps:
    'rest_framework',

    # local apps:
    'ml_api',
]
```

Next fill out the `view` and `model` in the app level, `ml_api`. Don't forget to register the model in the `admin.py`.
After that we have to create the migrations file for our created model:

```sh
docker compose run --rm web sh -c "python manage.py makemigrations"

# or simply, if you created the Makefile
make makemigrations
```

Finally, we have to sort out the urls. Create a `url.py` in the `ml_api` app:

```py
# ml_api/urls.py

from django.urls import path

from .views import SentimentAnalysisView

urlpatterns = [
    path('analyze/', SentimentAnalysisView.as_view(), name='sentiment-analysis')
]

```

And then add the url to the `config/urls.py` file:

```py
# config/urls.py
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('ml_api.urls')),
]

```

Now we can finally got to the endpoint at `http://127.0.0.1:8000/api/analyze/` and test our app:

```md
# The expected payload is sth like this:

{"text": "ML is so cool & fun"}

# And we'll be recieving a Response like so:

{
"id": 1,
"text": "ML is so cool & fun",
"label": "POS",
"score": 0.793340083761663
}
```

NOTE: The **score** is for now a random number that's seeded to the number of words in the the text/request. We'll be using an actuall model later on - like the `sentiment_analysis` model from the **HuggingFace Transformers** library.

# File Permissions of the `wait_for_db.sh`

Use the following command to investigate the files inside the app container:

```sh
docker compose run --rm web sh
```

And then run `ls -l` to see the `file permissions` info for `wait_for_db.sh`; you should be inside the `code` direcotry.

```md
## You should see something like this:

-rwxrwxr-- 1 django_u django_u 157 Dec 1 21:09 wait_for_db.sh
```

If the file permission is like `-rw-rw-r--`, then manually run:

```sh
chmod +x
```

## Removing a volume:

```sh
docker volume ls

docker volume rm <volume_name>
# In case the volume is in use, rm the corresponding container.
# Find the name/id of the container via:
docker ps -a

```

```sh
#
# Using psql From Your Host Machine:
psql -h localhost -p 5432 -U localadmin -d ml_db

# ------------------------------------------------------------

# Using docker exec to Run Commands Directly in the Container:

docker exec -it sa_postgres_db /bin/sh
psql -U localadmin -d ml_db

SELECT * FROM ml_api_sentimentanalysis;  # Do NOT forget the `;` at the end.

```

You can Check migrations status with the followings:

```sh
docker compose run --rm web sh -c "python manage.py showmigrations"

# The [X] next to each migration indicates that the migration has been executed.
```
