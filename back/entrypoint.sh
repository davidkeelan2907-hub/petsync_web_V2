#!/bin/sh
set -e

echo "Waiting for database..."
until python -c "import psycopg2; psycopg2.connect(dbname='${POSTGRES_DB}', user='${POSTGRES_USER}', password='${POSTGRES_PASSWORD}', host='${POSTGRES_HOST}', port=${POSTGRES_PORT})" 2>/dev/null; do
  echo "Database not ready, sleeping..."
  sleep 2
done

echo "Database ready. Running migrations..."
python manage.py migrate --noinput

echo "Starting Gunicorn..."
gunicorn core.wsgi:application --bind 0.0.0.0:8000 --workers 3
