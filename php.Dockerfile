FROM php:7.4-fpm
RUN apt-get update && apt-get install -y \
		libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd
RUN apt-get update && apt-get install -y libzip-dev libxml2-dev libxslt-dev
RUN apt update && apt install -y libicu-dev && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install zip intl mysqli pdo pdo_mysql soap xsl sockets


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1

ARG MAGENTO_PUBLIC_KEY
ARG MAGENTO_PRIVATE_KEY
ENV MAGENTO_PUBLIC_KEY=$MAGENTO_PUBLIC_KEY
ENV MAGENTO_PRIVATE_KEY=$MAGENTO_PRIVATE_KEY
RUN composer config -g http-basic.repo.magento.com $MAGENTO_PUBLIC_KEY $MAGENTO_PRIVATE_KEY

ENV NODE_VERSION=14
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"