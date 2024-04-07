FROM debian:bookworm

SHELL ["/bin/bash", "-c"]

RUN apt-get -qq update
RUN apt-get -qq install --no-install-recommends --no-install-suggests -y \
    apt-transport-https \
    ca-certificates \
    bzip2 \
    curl \
    git \
    gnupg \
    less \
    lsb-release \
    procps \
    tree \
    vim \
    wget

# Variables
ARG PHP_VERSION="7.4"
ENV PHP_VERSION=$PHP_VERSION
ARG NODE_VERSION="14"
ENV NODE_VERSION=$NODE_VERSION

ENV php74_amd64="apcu apcu-bc bcmath bz2 curl cli common fpm gd imagick intl json ldap mbstring memcached mysql opcache pgsql readline redis soap sqlite3 uploadprogress xdebug xml xmlrpc zip"

RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && apt-get update

#nginx
RUN apt-get -qq install --no-install-recommends --no-install-suggests -y \
    nginx \
    supervisor

#php
RUN ext=$(echo "$php74_amd64" | awk -v v="php7.4" ' BEGIN {RS=" "; }  { printf "%s-%s ",v,$0 ; }') && \
    apt-get -qq install --no-install-recommends --no-install-suggests -y $ext

RUN ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm

ADD server/etc /etc

EXPOSE 8080 8585 80 8025
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisor.conf"]
