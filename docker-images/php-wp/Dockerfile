FROM wordpress:fpm

RUN apt-get update && apt-get install -y libmemcached-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && apt-get clean
