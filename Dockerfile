FROM alpine

ARG USER=webuser
ENV HOME /home/$USER
RUN apk add --update sudo
RUN adduser -D $USER \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER
# Install packages
RUN apk --no-cache add \
    php81 \
    php81-fpm \
    php81-opcache \
    php81-pecl-apcu \
    php81-pdo \
    php81-mysqli \
    php81-pgsql \
    php81-pdo_pgsql \
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
    runit \
    curl \
    #    postgresql-client \
    # Bring in gettext so we can get `envsubst`, then throw
    # the rest away. To do this, we need to install `gettext`
    # then move `envsubst` out of the way so `gettext` can
    # be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    && runDeps="$( \
    scanelf --needed --nobanner /tmp/envsubst \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u \
    | xargs -r apk info --installed \
    | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
    # Remove alpine cache
    && rm -rf /var/cache/apk/* \
    # Remove default server definition
    && rm /etc/nginx/http.d/default.conf \
    # Make sure files/folders needed by the processes are accessable when they run under the webuser user
    && chown -R $USER.$USER /run \
    && chown -R $USER.$USER /var/lib/nginx \
    && chown -R $USER.$USER /var/log/nginx \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir /var/www/vendor \
    && chown -R $USER.$USER /var/www/vendor \
    && mkdir /var/log/php \
    && chown -R $USER.$USER /var/log/php

# Add configuration files
COPY --chown=$USER rootfs/ / 
COPY --chown=$USER larademo/ /var/www/

# Switch to use a non-root user from here on
USER $USER

ENV client_max_body_size=2M \
    clear_env=no \
    allow_url_fopen=On \
    allow_url_include=Off \
    display_errors=Off \
    file_uploads=On \
    max_execution_time=0 \
    max_input_time=-1 \
    max_input_vars=1000 \
    memory_limit=128M \
    post_max_size=8M \
    upload_max_filesize=2M \
    zlib_output_compression=On

# Add application
WORKDIR /var/www/

RUN sudo mv .env.minikube .env \
    && composer install --no-dev --no-scripts \
    && composer clear-cache \
    && composer dump-autoload -a \
    && php artisan optimize \
    && php artisan route:cache \
    && php artisan view:cache

# Expose the port nginx is reachable on
EXPOSE 8080

# Let runit start nginx & php-fpm
CMD [ "/bin/docker-entrypoint.sh" ]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping

