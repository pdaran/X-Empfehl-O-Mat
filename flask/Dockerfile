# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM python:3.10-alpine AS builder

WORKDIR /flask

COPY requirements.txt /flask
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

COPY . /flask

ENTRYPOINT ["python3"]
CMD ["app.py"]
