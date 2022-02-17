FROM php:7.4-fpm
ARG DIRECTORY_PROJECT=/var/www/public

WORKDIR $DIRECTORY_PROJECT

# Install Packages
RUN apt-get update && apt-get install -y \
        libxml2-dev \
        git \
	libzip-dev \
        zip \
        unzip \
        zlib1g-dev \
        libpng-dev \
        --no-install-recommends \
        cron \
        supervisor \
        libonig-dev \
    # Docker extension install
    && docker-php-ext-install \
            opcache \
            pdo_mysql \
            pdo \
            mbstring \
            xml \
            soap \
            dom \
            simplexml \
            json \
            zip \
            gd \
            bcmath
    # error to stderr php-fpm
    # && { \
    #     echo "log_errors = On"; \
    #     echo "error_log = /dev/stderr"; \
    #     echo "error_reporting = E_ALL"; \
    #     # echo "memory_limit = 256M"; \
    # } > /usr/local/etc/php/php.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
 
COPY ./app/ $DIRECTORY_PROJECT


# Install dependencies  from project
#RUN composer install --ignore-platform-reqs && composer clearcache 

# Permissions
RUN find $DIRECTORY_PROJECT -type f -exec chmod 644 {} \; \
    && find $DIRECTORY_PROJECT -type d -exec chmod 755 {} \; \
    && chown -R www-data:www-data $DIRECTORY_PROJECT

# RUN php artisan migrate

# Reduce image size
RUN apt-get remove --purge -y git \
    && apt-get autoremove -y \
    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove -y

ENV LANG es_CL.UTF-8
ENV LANGUAGE es_CL:es
ENV LC_ALL es_CL.UTF-8
ENV TZ America/Santiago


EXPOSE 9000

