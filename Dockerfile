FROM php:8.1.1-fpm-alpine

LABEL maintainer="krich.al.vl@gmail.com"

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
ENV PHP_CUSTOM_INI "$PHP_INI_DIR/conf.d/custom.ini"
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv \
&& apk add --update --no-cache zip tzdata zlib libpng freetype libjpeg-turbo libzip zstd-libs icu-libs libxml2 rabbitmq-c $PHPIZE_DEPS \
&& apk add --update --no-cache --virtual .devdeps zlib-dev libpng-dev freetype-dev libjpeg-turbo-dev libzip-dev zstd-dev icu-dev libxml2-dev rabbitmq-c-dev \
&& pecl install igbinary \
&& yes | pecl install redis \
&& pecl install amqp-1.11.0 \
&& docker-php-ext-configure gd -with-jpeg= --with-freetype \
&& docker-php-ext-install -j$(nproc) gd zip pdo_mysql gd intl opcache soap bcmath pcntl \
&& docker-php-ext-enable igbinary redis amqp \
&& cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
&& echo -e "; maximum memory that OPcache can use to store compiled PHP files\n\
opcache.memory_consumption=256\n\
; maximum number of files that can be stored in the cache\n\
opcache.max_accelerated_files=20000\n\
opcache.validate_timestamps=0\n\
; maximum memory allocated to store the results\n\
realpath_cache_size=4096K\n\
; save the results for 10 minutes (600 seconds)\n\
realpath_cache_ttl=600\n\
date.timezone=Europe/Kiev\n\
;opcache.preload=\n\
;opcache.preload_user=\n\
pcov.enabled=0" > $PHP_CUSTOM_INI \
&& cp /usr/share/zoneinfo/Europe/Kiev /etc/localtime \
&& echo "Europe/Kiev" >  /etc/timezone \
&& apk del --purge .devdeps $PHPIZE_DEPS && rm -rf /tmp/* /var/cache/apk/*

WORKDIR /app
