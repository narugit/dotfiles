FROM ubuntu:20.04
MAINTAINER narugit

RUN apt update && apt install -y \
  curl \
  sudo \
  tzdata

ARG TEST_USER
ARG TEST_USER_PASS

RUN useradd \
  -m --uid 1000 --groups sudo ${TEST_USER} -s /bin/bash \
  && echo ${TEST_USER}:${TEST_USER_PASS} | chpasswd

