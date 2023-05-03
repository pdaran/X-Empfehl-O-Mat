#!/bin/bash
set -e

rm -f tmp/pids/server.pid
bundle install
if [ -f ./db/development.sqlite3 ]; then
  echo "DB exists, run migrations"
  bundle exec rails db:migrate
else
  echo "DB does not exist, load schema"
  bundle exec rails db:schema:load
fi
bundle exec foreman start -f Procfile.dev