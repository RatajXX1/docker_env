FROM debian:bookworm

SHELL ["/bin/bash", "-c"]

RUN apt-get -qq update
RUN dpkg --configure -a
RUN apt install -f
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
    wget \
    pv

# Variables
ARG PHP_VERSION="8.2"
ENV PHP_VERSION=$PHP_VERSION

ARG PHP_VERSIONS="php7.4 php8.0 php8.1 php8.2 php8.3 php8.4"
ENV PHP_VERSIONS=$PHP_VERSIONS

ARG NODE_VERSION="22"
ENV NODE_VERSION=$NODE_VERSION

ARG MAGENTO_PUBLIC_KEY
ARG MAGENTO_PRIVATE_KEY
ENV MAGENTO_PUBLIC_KEY=$MAGENTO_PUBLIC_KEY
ENV MAGENTO_PRIVATE_KEY=$MAGENTO_PRIVATE_KEY

ENV MYSQL_VERSION="8.0"

ENV php74_amd64="apcu apcu-bc bcmath bz2 curl cli common fpm gd imagick intl json ldap mbstring memcached mysql opcache pgsql readline redis soap sqlite3 uploadprogress xdebug xml xmlrpc zip"
ENV php80_amd64="apcu bcmath bz2 curl cli common fpm gd imagick intl ldap mbstring memcached mysql opcache pgsql readline redis soap sqlite3 uploadprogress xdebug xhprof xml xmlrpc zip"
ENV php84_amd64="bcmath bz2 cli common curl fpm gd intl ldap mbstring mysql opcache pgsql readline soap sqlite3 xml zip"

ARG php74_arm64=$php74_amd64
ARG php81_amd64=$php80_amd64
ARG php81_arm64=$php81_amd64
ARG php82_amd64=$php81_amd64
ARG php82_arm64=$php82_amd64
ARG php83_amd64=$php82_amd64
ARG php83_arm64=$php83_amd64
ARG php84_arm64=$php84_amd64

RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && apt-get update

# RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb -O /tmp/mysql-apt-config
# RUN DEBIAN_FRONTEND=noninteractiv dpkg -i /tmp/mysql-apt-config && rm /tmp/mysql-apt-config

#nginx
RUN apt-get -qq install --no-install-recommends --no-install-suggests -y \
    nginx \
    supervisor \
    mariadb-client

RUN echo $PHP_VERSIONS;
#php
RUN for v in $PHP_VERSIONS; do \
      pkgvar=${v//.}_amd64; \
      ext=$(echo ${!pkgvar} | awk -v v="$v" ' BEGIN {RS=" "; }  { printf "%s-%s ",v,$0 ; }') && \
      apt-get -qq install --no-install-recommends --no-install-suggests -y $ext ;\
    done

#Set default php-fpm
RUN ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm
RUN ln -sf /usr/bin/php${PHP_VERSION} /usr/bin/php
RUN ln -sf /bin/php${PHP_VERSION} /bin/php

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer config -g http-basic.repo.magento.com $MAGENTO_PUBLIC_KEY $MAGENTO_PRIVATE_KEY

#nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN . "$NVM_DIR/nvm.sh" && npm install --global yarn
ADD server/etc /etc

EXPOSE 8080 8585 80 8025
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisor.conf"]