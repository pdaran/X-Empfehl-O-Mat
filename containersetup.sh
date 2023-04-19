#!/bin/sh
set -e

rm -f tmp/pids/server.pid
bundle install

# If the database exists, migrate. Otherwise setup (create and migrate)
echo "Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate
echo "Finished running database migrations."

bundle exec rails s -p 3000 -b '0.0.0.0'
