# Stage 1: Build
FROM docker.io/php:8.0.30-fpm-alpine3.16 AS build
COPY --from=composer:2.7.7 /usr/bin/composer /usr/bin/composer
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions bcmath opcache pdo_mysql
RUN docker-php-ext-enable bcmath opcache pdo_mysql
ARG UID=1000
ARG GID=1000
RUN deluser www-data 2>/dev/null || true
RUN addgroup -g ${GID} www-data \
    && adduser -u ${UID} -G www-data -h /home/www-data -s /sbin/nologin -D www-data
USER www-data
EXPOSE 9000
CMD ["php-fpm"]