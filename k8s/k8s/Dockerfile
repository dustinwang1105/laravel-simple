FROM php:8.1-alpine

WORKDIR /source

# 安裝環境、安裝工具
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN apk add --no-cache unzip
RUN docker-php-ext-install bcmath
RUN apk add --no-cache --virtual .build-deps autoconf g++ make && pecl install redis && apk del .build-deps
RUN docker-php-ext-enable redis

# 加速套件下載的套件
#RUN composer global require hirak/prestissimo && composer clear-cache

# 安裝程式依賴套件
COPY composer.* ./
RUN composer install --no-dev --no-scripts && composer clear-cache

# 複製程式碼
COPY . .
RUN composer run post-autoload-dump

CMD ["php", "artisan", "serve", "--host", "0.0.0.0"]