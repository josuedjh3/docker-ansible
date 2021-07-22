FROM python:3.8.3-alpine as base

RUN set -eux \
# Packages from testing
    && apk add \
        --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
# Docker tools
        gosu \
        tini

RUN set -eux \
    && apk add \
        --no-cache  \
# Common tools for development and building
        gettext \
        tzdata \
        build-base \
        bash \
# Library headers to build python packages
        musl-dev \
        bzip2-dev \
        libffi-dev \
        openssl-dev \
        readline-dev \
        zlib-dev \
        libxml2-dev \
        libxslt-dev \
        jansson-dev \
        pcre-dev \
        bzip2-dev \
        xz-dev \
        libffi-dev

RUN set -eux \
    && apk add \
        --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
# Installing fonts and libraries
        msttcorefonts-installer \
        ttf-opensans \
# Post install for the fonts
    && update-ms-fonts \
    && fc-cache -f

ENV LANG="C.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_COLLATE="C" \
    LC_ALL="en_US.UTF-8" \
    TERM="xterm-256color" \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

# Setup non-root user
RUN set -eux \
    \
    && addgroup -g 1000 app \
    && adduser -u 1000 -G app -H -D app \
    \
    && mkdir -p /app \
    && mkdir -p /python \
    && chown -R app /app \
    && chown -R app /python

ENV PATH="/python/bin:${PATH}" \
    XDG_CACHE_HOME="/python/cache" \
    DEFAULT_LOCAL_TMP="/python/cache" \
    PYTHONENV="/python" \
    PYTHONUNBUFFERED=0 \
    PYTHONHASHSEED=random

WORKDIR "/app"

EXPOSE 8081

COPY entrypoint-base.sh /sbin/docker-entrypoint.sh

ENTRYPOINT ["tini", "--", "/sbin/docker-entrypoint.sh"]

FROM base as develop

RUN set -eux \
    && apk add --no-cache \
        openssh-client \
        groff \
        curl \
        unzip \
        gnupg

COPY ./skel /etc/skel

RUN set -eux \
    && mkdir /home/app \
    && chown app:app -R /home/app

VOLUME /home/app

COPY entrypoint-development.sh /sbin/docker-entrypoint.sh