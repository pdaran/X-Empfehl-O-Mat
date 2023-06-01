#!/bin/sh
set -e

rm -f tmp/pids/server.pid
bundle install

# If the database exists, migrate. Otherwise setup (create and migrate)
echo "Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate db:seed
echo "Finished running database migrations."

bundle exec foreman start -f Procfile.dev
