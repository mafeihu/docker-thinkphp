FROM php:5.6-fpm

ENV LANG=C.UTF-8

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
	libmemcached-dev \
	zlib1g-dev \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng12-dev \
	libbz2-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN pecl install redis-3.1.2 \
	&& docker-php-ext-enable redis

RUN pecl install memcached-2.2.0 \
	&& docker-php-ext-enable memcached

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd mcrypt pdo_mysql bz2


RUN mkdir /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
COPY bin/composer.phar /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
