#!/bin/sh
set -e

rm -f tmp/pids/server.pid
bundle config set --local path 'vendor'
bundle install
if [ -f ./db/development.sqlite3 ]; then
  echo "DB exists, run migrations"
  bundle exec rails db:migrate
else
  echo "DB does not exist, load schema"
  bundle exec rails db:schema:load
fi
bundle exec rails s -p 3000 -b '0.0.0.0'
