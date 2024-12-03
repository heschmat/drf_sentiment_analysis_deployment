#!/bin/sh
set -e

# echo "Waiting for PostgreSQL to be ready..."
# while ! nc -z "$DB_HOST" "$DB_PORT"; do
#   sleep 1
# done

# echo "PostgreSQL is ready!"
# exec "$@"

echo "*** checking if db is ready ***"
# wait until the PostgreSQL server is available
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB"; do
  echo "Waiting for database to be ready..."
  sleep 2
done
echo "Database is ready"
