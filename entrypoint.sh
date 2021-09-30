#!/bin/bash

application_name="${APPLICATION_NAME:-helios}"
port="${PORT:-8000}"
address="${ADDRESS:-0.0.0.0}"
operation_mode="${OPERATION_MODE:-develop}"
function celery_worker() {
    celery -A ${application_name} -l info
}

function setup_django() {
    python3 manage.py wait_for_db
    python3 manage.py makemigrations helios
    python3 manage.py migrate
}
function development() {
    ./reset.sh;
    setup_django;
    python manage.py runserver ${address}:${port}
}
function production() {
    setup_django;
    export DEBUG="${DEBUG:-0}"
    python3 manage.py collectstatic --noinput
    gunicorn wsgi:application --workers 2 --timeout 600 -b :${port}

}

case ${operation_mode} in
    DEVELOPMENT ) development ;;
    PRODUCTION  ) production  ;;
    CELERY      ) celery_worker ;;
esac
