# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM python:3.10-alpine AS builder

WORKDIR /flask

COPY requirements.txt /flask
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

COPY . /flask

ENTRYPOINT ["flask"]
CMD [ "--app", "app.py", "--debug", "run", "--host=0.0.0.0" ,"-p" ,"8000"]
