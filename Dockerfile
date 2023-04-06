FROM ruby:2.7.4-alpine3.13
# FROM ruby:3.2.1-alpine3.17
# FROM ruby:3-alpine

RUN mkdir /app
WORKDIR /app

# add statically required base components
RUN apk --no-cache add \
  libpq postgresql-dev bash make gcc musl-dev sqlite-dev tzdata patch nodejs gcompat git

# copy initial application dependencies
ADD Gemfile Gemfile.lock /app/

# pre-install initial application requirements
RUN gem install bundler && \
  bundle install --jobs=8

# copy the application directory
ADD . /app

# potentially run precompile commands (later: for production)
# RUN rails webpacker:compile

CMD rm -f /app/tmp/pids/server.pid && rails db:migrate && rails server -b 0.0.0.0
EXPOSE 3000
