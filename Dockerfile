FROM php:8.1-fpm

ENV PHP_INI_MEMORY_LIMIT 256M

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libjpeg62-turbo \
        libpng-dev \
        libpng16-16 \
        libldap2-dev \
        libxml2-dev \
        libzip-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
        default-mysql-client \
        unzip \
        curl \
        apt-utils \
        msmtp \
        msmtp-mta \
        mailutils \
        libc-client-dev \
        libkrb5-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) calendar intl mysqli pdo_mysql soap zip exif \
    && docker-php-ext-configure gd --with-jpeg=/usr/ --with-freetype=/usr/ \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-enable exif \
    && docker-php-ext-install -j$(nproc) gd ldap imap && \
    mv ${PHP_INI_DIR}/php.ini-development ${PHP_INI_DIR}/php.ini

RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN echo 'xdebug.mode=develop' >> ${PHP_INI_DIR}/php.ini
RUN echo 'xdebug.start_with_request=yes' >> ${PHP_INI_DIR}/php.ini
RUN echo 'xdebug.log="/tmp/xdebug.log"' >> ${PHP_INI_DIR}/php.ini
RUN echo 'xdebug.show_local_vars=1' >> ${PHP_INI_DIR}/php.ini
RUN echo 'xdebug.var_display_max_depth=10' >> ${PHP_INI_DIR}/php.ini

#set change max value
RUN sed -E -i -e 's/max_execution_time = 30/max_execution_time = 9999/' ${PHP_INI_DIR}/php.ini \
 && sed -E -i -e 's/memory_limit = 128M/memory_limit = 512M/' ${PHP_INI_DIR}/php.ini \
 && sed -E -i -e 's/post_max_size = 8M/post_max_size = 64M/' ${PHP_INI_DIR}/php.ini \
 && sed -E -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 64M/' ${PHP_INI_DIR}/php.ini \
 && sed -E -i -e 's/;max_input_vars = 1000/max_input_vars = 5000/' ${PHP_INI_DIR}/php.ini

RUN echo "date.timezone = 'Europe/Paris'" >> ${PHP_INI_DIR}/php.ini
