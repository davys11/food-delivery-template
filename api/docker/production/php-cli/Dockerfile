FROM php:7.4-cli-alpine as buider

RUN apk update && apk add unzip

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet

WORKDIR /app

COPY ./composer.json ./composer.lock ./

RUN composer install --no-dev --prefer-dist --no-progress --no-suggest --no-scripts --optimize-autoloader \
    && rm -rf /root/.composer/cache

###

FROM php:7.4-cli-alpine

RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

COPY ./docker/common/php/conf.d /usr/local/etc/php/conf.d

WORKDIR /app

COPY --from=buider /app ./

COPY ./ ./

