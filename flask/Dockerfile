# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM python:3.10.8 AS builder
WORKDIR /flask

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y build-essential

# hdf5 needed for pytables installation
RUN apt-get install -y libhdf5-dev

RUN python -m pip install --upgrade pip

COPY requirements.txt /flask
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

COPY . /flask

ENTRYPOINT ["flask"]
CMD [ "--app", "app.py", "--debug", "run", "--host=0.0.0.0" ,"-p" ,"8000"]
