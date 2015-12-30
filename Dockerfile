FROM debian:jessie

MAINTAINER "Jorge Corredor" <jorel.c@gmail.com>

ENV APP_DIR /srv/www

# Install PHP-FPM and some php extensions
RUN apt-get update -y && \
    apt-get install -y \
    php5-fpm \
    php5-curl \
    php5-gd \
    php5-json \
    php5-mcrypt \
    php5-redis \
    php5-xmlrpc \
    php5-xcache && \
    rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
COPY config/php.ini /etc/php5/fpm/php.ini
COPY config/php-fpm.conf /etc/php5/fpm/php-fpm.conf
COPY config/conf.d/redis.ini /etc/php5/mods-available/redis.ini
COPY config/pool.d/www.conf /etc/php5/fpm/pool/www.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/php5-fpm.log

# Create WorkDir
RUN /bin/bash -c 'mkdir $APP_DIR'

# Set WorkDir
WORKDIR ${APP_DIR}

VOLUME ["${APP_DIR}"]

EXPOSE 9000

ENTRYPOINT ["/usr/sbin/php5-fpm", "-F"]
