FROM alpine:3.6
LABEL Maintainer="Nikolay Volkov <gitkv@ya.ru>" \
      Description="This file for production. Nginx & PHP-FPM 7.1 & Composer based on Alpine Linux."

COPY ["./docker/entrypoint.sh", "/root/"]

# Install packages
RUN apk update && apk --no-cache add bash php7 php7-fpm php7-pgsql php7-json php7-openssl \
    php7-curl php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlwriter php7-xmlreader php7-ctype \
    php7-mbstring php7-gd php7-tokenizer php7-pdo php7-pdo_pgsql php7-simplexml php7-fileinfo php7-bcmath php7-pcntl nginx supervisor curl tzdata \
    nodejs nodejs-npm && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    composer global require hirak/prestissimo && \
    adduser -D -g 'www' www && \
    mkdir -p /var/www/app && \
    chown -R www:www /var/www/app && \
    chmod 755 /root/entrypoint.sh

# Configure nginx
COPY ["./docker/config/nginx.conf", "/etc/nginx/nginx.conf"]

# Configure PHP-FPM
COPY ["./docker/config/fpm-pool.conf", "/etc/php7/php-fpm.d/zzz_custom.conf"]
COPY ["./docker/config/php.ini", "/etc/php7/conf.d/zzz_custom.ini"]

# Configure supervisord
COPY ["./docker/config/supervisord.conf", "/etc/supervisor/conf.d/supervisord.conf"]

# Add application
COPY ["./", "/var/www/app/"]

WORKDIR "/var/www/app/"

ENTRYPOINT ["/root/entrypoint.sh"]

# Run container
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 80

# Add healthcheck
HEALTHCHECK CMD curl --fail http://127.0.0.1/ping || exit 1