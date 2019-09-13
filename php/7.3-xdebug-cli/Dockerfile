FROM php:7.3-apache

RUN apt-get update -qq  \
# zip
    && apt-get install -y -qq --no-install-recommends unzip \
# chrome driver required
    && apt-get install -y -qq --no-install-recommends libnss3 libgconf-2-4 \
# gd
    && apt-get install -y -qq --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
# iconv
    && docker-php-ext-install -j$(nproc) iconv \
# intl
    && apt-get install -y -qq --no-install-recommends libicu-dev \
    && docker-php-ext-install intl \
# mysql
    && docker-php-ext-install mysqli pdo_mysql \
# composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
# mbstring
    && docker-php-ext-install mbstring \
# soap
    && apt-get install -y -qq --no-install-recommends libxml2-dev \
    && docker-php-ext-install soap \
# opcache
    && docker-php-ext-install opcache \
# zip
    && apt-get install -y -qq --no-install-recommends libzip-dev \
    && docker-php-ext-install zip \
# git
    && apt-get install -y -qq --no-install-recommends git \
# xsl
    && apt-get install -y -qq --no-install-recommends libxslt-dev \
    && docker-php-ext-install xsl \
# bcmath
    && docker-php-ext-install bcmath \
# ldap
    && apt-get install -y -qq --no-install-recommends libldap2-dev \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install ldap \
# redis
    && pecl install redis \
    && docker-php-ext-enable redis \
# memcached
    && apt-get install -y -qq --no-install-recommends libmemcached-dev zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
# Install APCu and APC backward compatibility
    && pecl install apcu \
    && pecl install apcu_bc \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini \
# cron
    && apt-get install -y -qq --no-install-recommends cron \
# supervisor
    && apt-get install -y -qq --no-install-recommends supervisor \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /etc/supervisor/conf.d \
    \
# Enable Apache mod_rewrite
    && a2enmod rewrite \
# iproute - ip command
    && apt-get install -y -qq --no-install-recommends iproute2  \
# cleanup
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && truncate -s 0 /var/log/*log

## Install ssmtp Mail Transfer Agent
#RUN apt-get update -qq  \
#    && apt-get install -y -qq --no-install-recommends ssmtp \
#    && apt-get clean \
#    && echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf \
#    && echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini \
## cleanup
#    && apt-get autoremove -y \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/* \
#    && truncate -s 0 /var/log/*log

RUN apt update -qq \
# wkhtmltopdf
    && apt install -y -qq --no-install-recommends wget xz-utils libxrender1 fontconfig libjpeg62-turbo libxext6  xfonts-base xfonts-75dpi \
    && wget --quiet https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && cp wkhtmltox/bin/wk* /usr/bin/ \
# cleanup
    && rm wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && rm -rf wkhtmltox \
    && apt-get remove -y xz-utils \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && truncate -s 0 /var/log/*log


# Default date.timezone
ENV PHP_TIMEZONE Europe/Bratislava
# Default DocumentRoot
ENV APACHE_DOC_ROOT /var/www/html
# Modified php.ini
COPY ./999-php.ini /usr/local/etc/php/conf.d/


ENV XDEBUG_ENABLE 1
RUN pecl install -o -f xdebug \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable xdebug

COPY ./99-xdebug.ini /usr/local/etc/php/conf.d/

RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=AT/ST=Vienna/L=Vienna/O=Security/OU=Development/CN=example.com"

RUN a2ensite default-ssl
RUN a2enmod ssl

ADD supervisor.conf /etc/supervisor.conf

# For debug
# Debug tools
RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends \
#    mysql-client \
    less \
    vim \
    git \
    mc \
    openssh-client \
    nmap \
    htop \
    curl \
    man \
    wget \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && truncate -s 0 /var/log/*log

COPY ./index.php /var/www/html/index.php

# http, https, xdebug
EXPOSE 80 443 9000


# Start!
COPY ./entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["entrypoint.sh"]







