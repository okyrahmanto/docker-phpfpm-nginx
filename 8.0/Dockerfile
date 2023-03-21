FROM alpine:3.17

LABEL Maintainer="Oky Rahmanto <oky.rahmanto@gmail.com>" \
      Description="Lightweight container with Nginx 1.18 & PHP-FPM 8.1 based on Alpine Linux (forked from trafex/alpine-nginx-php7)."
# configure base repositories.
#RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.17/main" > /etc/apk/repositories && \
#    echo "http://dl-cdn.alpinelinux.org/alpine/v3.17/community" >> /etc/apk/repositories

# configure php-alpine repository.
#RUN echo "/opt/php-alpine/v3.17/php-8.1" >> /etc/apk/repositories


RUN apk --update add ca-certificates

# Install packages
RUN apk --no-cache add \
        php81 \
        php81-fpm \
        php81-opcache \
        php81-pecl-apcu \
        php81-mysqli \
        php81-pgsql \
        php81-json \
        php81-openssl \
        php81-curl \
        php81-zlib \
        php81-soap \
        php81-xml \
        php81-fileinfo \
        php81-phar \
        php81-intl \
        php81-dom \
        php81-xmlreader \
        php81-ctype \
        php81-session \
        php81-iconv \
        php81-tokenizer \
        php81-zip \
        php81-simplexml \
        php81-mbstring \
        php81-gd \
        nginx \
        supervisor \
        curl

# Install packages
#RUN apk --no-cache add php php-fpm php-opcache php-openssl php-curl \
#    nginx supervisor curl

# https://github.com/codecasts/php-alpine/issues/21
#RUN ln -s /usr/bin/php81 /usr/bin/php

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

#all config in
# /etc/nginx/conf.d/
# Remove default server definition
#RUN rm /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY config/php.ini /etc/php81/conf.d/custom.ini

RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
COPY --chown=nobody src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
