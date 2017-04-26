## https://hub.docker.com/_/php/

```dockerfile
FROM php:7.0-fpm
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
```
```dockerfile

FROM php:7.1-fpm
RUN pecl install redis-3.1.0 \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable redis xdebug
```
```dockerfile

FROM php:5.6-fpm
RUN apt-get update && apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached
```
```dockerfile

FROM php:5.6-apache
RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
    && mkdir -p xcache \
    && tar -xf xcache.tar.gz -C xcache --strip-components=1 \
    && rm xcache.tar.gz \
    && ( \
        cd xcache \
        && phpize \
        && ./configure --enable-xcache \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r xcache \
    && docker-php-ext-enable xcache
```
```dockerfile

FROM php:5.6-apache
RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
    && mkdir -p /tmp/xcache \
    && tar -xf xcache.tar.gz -C /tmp/xcache --strip-components=1 \
    && rm xcache.tar.gz \
    && docker-php-ext-configure /tmp/xcache --enable-xcache \
    && docker-php-ext-install /tmp/xcache \
    && rm -r /tmp/xcache
```

### comments

```dockerfile
FROM php:7-apache
RUN docker-php-source extract \
&& apt-get update \
&& apt-get install libmcrypt-dev libldap2-dev nano -y \
&& rm -rf /var/lib/apt/lists/* \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
&& docker-php-ext-install ldap pdo pdo_mysql \
&& a2enmod rewrite \
&& a2enmod ssl \
&& docker-php-source delete
COPY src/ /var/www/html/
```
```dockerfile

FROM php:7-fpm-alpine
RUN apk upgrade --update && apk add \
  autoconf file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libstdc++ libgcc binutils-libs mpc1 mpfr3 gmp libgomp \
  coreutils \
  freetype-dev \
  libjpeg-turbo-dev \
  libltdl \
  libmcrypt-dev \
  libpng-dev \
&& docker-php-ext-install iconv mcrypt mysqli mysqlnd pdo pdo_mysql zip \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd \
&& apk del autoconf file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libstdc++ libgcc binutils-libs mpc1 mpfr3 gmp libgomp \
&& rm -rf /var/cache/apk/*
```
```dockerfile

FROM php:7.0-fpm

ADD ./laravel.ini /usr/local/etc/php/conf.d
ADD ./laravel.pool.conf /usr/local/etc/php-fpm.d/

RUN apt-get update && apt-get install -y \
libpq-dev \
libmemcached-dev \
libpng-dev \
curl \
--no-install-recommends \
&& rm -r /var/lib/apt/lists/*
Install extensions using the helper script provided by the base image

RUN docker-php-ext-install \
pdo_mysql \
pdo_pgsql \
gd

```
```dockerfile




RUN pecl install -o -f xdebug \
    && rm -rf /tmp/pear \
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1"       >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_handler=dbgp"   >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9000"      >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug.ini

```
```dockerfile


FROM php:5.6-fpm
RUN apt-get update
RUN apt-get install -y php5-imagick imagemagick
RUN apt-get install -y libssl-dev
RUN echo "extension=find /usr/lib/. -name imagick.so" > /usr/local/etc/php/php.ini
CMD ["php-fpm"]

```
```dockerfile

FROM php:5.6-fpm

# Install mbstring Extension
RUN docker-php-ext-install mbstring

# Install Mongo Extension
ADD docker-php-pecl-install /usr/local/bin/
RUN chmod u+x /usr/local/bin/docker-php-pecl-install
RUN apt-get update
RUN apt-get install -y libssl-dev
RUN docker-php-pecl-install mongo

ADD yourapp.ini /usr/local/etc/php/conf.d/
ADD yourapp.pool.conf /etc/php5/fpm/pool.d/

```



Here's a list of all the available extensions via docker-php-ext-install

```
# docker-php-ext-install
usage: /usr/local/bin/docker-php-ext-install ext-name [ext-name ...]
   ie: /usr/local/bin/docker-php-ext-install gd mysqli
       /usr/local/bin/docker-php-ext-install pdo pdo_mysql
if custom ./configure arguments are necessary, see docker-php-ext-configure

Possible values for ext-name:
bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap interbase intl json ldap mbstring mcrypt memcached-2.2.0 mssql mysql mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop simplexml snmp soap sockets spl standard sybase_ct sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip
```





## https://github.com/docker-library/php/issues/75

```
(Incomplete) List of extensions and the debian packages they require to build:

ldap: libldap2-dev (configure: --with-libdir=lib/x86_64-linux-gnu/)
soap: libxml2-dev
mcrypt: libmcrypt-dev
ftp: libssl-dev
intl: libicu-dev
xsl: libxslt-dev
imap: libc-client-dev libkrb5-dev (configure: --with-kerberos --with-imap-ssl)
```

```
You can get at least some hints from apt-cache which packages are needed for building an extension.
I've just created a debian-based image for that, improvements/ideas welcome...

Examples:

$ docker run schmunk42/apt apt-cache depends php5-xsl
php5-xsl
  Depends: libc6
  Depends: libxml2
  Depends: libxslt1.1
  Depends: <phpapi-20131226>
    php5-common
  Depends: php5-common
  Depends: ucf

$ docker run schmunk42/apt apt-cache depends php5-ldap
php5-ldap
  Depends: libc6
  Depends: libldap-2.4-2
  Depends: libsasl2-2
  Depends: <phpapi-20131226>
    php5-common
  Depends: php5-common
  Depends: ucf
```

```
An almost complete list:

RUN apt update
RUN apt upgrade -y
RUN apt install -y apt-utils
RUN a2enmod rewrite
RUN apt install -y libmcrypt-dev
RUN docker-php-ext-install mcrypt
RUN apt install -y libicu-dev
RUN docker-php-ext-install -j$(nproc) intl
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN apt install -y php-apc
RUN apt install -y libxml2-dev
RUN apt install -y libldb-dev
RUN apt install -y libldap2-dev
RUN apt install -y libxml2-dev
RUN apt install -y libssl-dev
RUN apt install -y libxslt-dev
RUN apt install -y libpq-dev
RUN apt install -y postgresql-client
RUN apt install -y mysql-client
RUN apt install -y libsqlite3-dev
RUN apt install -y libsqlite3-0
RUN apt install -y libc-client-dev
RUN apt install -y libkrb5-dev
RUN apt install -y curl
RUN apt install -y libcurl3
RUN apt install -y libcurl3-dev
RUN apt install -y firebird-dev
RUN apt-get install -y libpspell-dev
RUN apt-get install -y aspell-en
RUN apt-get install -y aspell-de
RUN apt install -y libtidy-dev
RUN apt install -y libsnmp-dev
RUN apt install -y librecode0
RUN apt install -y librecode-dev
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
#RUN pecl install apc
RUN docker-php-ext-install opcache
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN docker-php-ext-install soap
RUN docker-php-ext-install ftp
RUN docker-php-ext-install xsl
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install calendar
RUN docker-php-ext-install ctype
RUN docker-php-ext-install dba
RUN docker-php-ext-install dom
RUN docker-php-ext-install zip
RUN docker-php-ext-install session
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap
RUN docker-php-ext-install json
RUN docker-php-ext-install hash
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pdo
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install intl
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mysqli
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-install gd
RUN docker-php-ext-install curl
RUN docker-php-ext-install exif
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install gettext
#RUN apt install -y libgmp-dev # idk
#RUN docker-php-ext-install gmp # idk
RUN docker-php-ext-install iconv
RUN docker-php-ext-install interbase
RUN docker-php-ext-install pdo_firebird
RUN docker-php-ext-install opcache
#RUN docker-php-ext-install oci8 # idk
#RUN docker-php-ext-install odbc # idk
RUN docker-php-ext-install pcntl
#RUN apt install -y freetds-dev # idk
#RUN docker-php-ext-install pdo_dblib  # idk
#RUN docker-php-ext-install pdo_oci # idk
#RUN docker-php-ext-install pdo_odbc # idk
RUN docker-php-ext-install phar
RUN docker-php-ext-install posix
RUN docker-php-ext-install pspell
#RUN apt install -y libreadline-dev # idk
#RUN docker-php-ext-install readline # idk
RUN docker-php-ext-install recode
RUN docker-php-ext-install shmop
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install snmp
RUN docker-php-ext-install sysvmsg
RUN docker-php-ext-install sysvsem
RUN docker-php-ext-install sysvshm
RUN docker-php-ext-install tidy
RUN docker-php-ext-install wddx
RUN docker-php-ext-install xml
#RUN apt install -y libxml2-dev # idk
#RUN docker-php-ext-install xmlreader # idk
RUN docker-php-ext-install xmlrpc
RUN docker-php-ext-install xmlwriter
# idk bz2 enchant
```



```
RUN apt-get update -y \
  && apt-get install -y \
    libxml2-dev \
    php-soap \
  && apt-get clean -y \
  && docker-php-ext-install soap
```



## https://github.com/php-amqplib/php-amqplib/issues/436

```
[PHP Modules]
calendar
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
igbinary
json
libxml
mbstring
mcrypt
memcached
mongodb
msgpack
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
pgsql
Phar
posix
readline
Reflection
session
shmop
SimpleXML
sockets
SPL
sqlite3
standard
sysvmsg
sysvsem
sysvshm
tokenizer
wddx
xml
xmlreader
xmlwriter
xsl
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```


## https://gist.github.com/tristanlins/4c1da2508f0326a042aa


 iconv.docker
```dockerfile
FROM php:5.6-cli

RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install iconv \
    && apt-get remove -y \
        libfreetype6-dev \
    && apt-get install -y \
        libfreetype6 \
    && apt-get autoremove -y

CMD ["php"]
```
imagick.docker
```dockerfile
FROM php:5.6-cli

RUN apt-get update \
    && apt-get install -y \
        libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick-beta \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
    && apt-get remove -y \
        libmagickwand-dev \
    && apt-get install -y \
        libmagickwand-6.q16-2 \
    && apt-get autoremove -y

CMD ["php"]
```
intl.docker
```dockerfile
FROM php:5.6-cli

RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install intl \
    && apt-get remove -y \
        libicu-dev \
    && apt-get install -y \
        libicu52 \
        libltdl7 \
    && apt-get autoremove -y

CMD ["php"]
```
mcrypt.docker
```dockerfile
FROM php:5.6-cli

RUN apt-get update \
    && apt-get install -y \
        libmcrypt-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install mcrypt \
    && apt-get remove -y \
        libmcrypt-dev \
    && apt-get install -y \
        libmcrypt4 \
    && apt-get autoremove -y

CMD ["php"]
```
memcached.docker
```dockerfile
FROM php:5.6-cli

RUN apt-get update \
    && apt-get install -y \
        libmemcached-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/ext-memcached.ini \
    && apt-get remove -y \
        libmemcached-dev \
    && apt-get install -y \
        libmemcached11 \
        libmemcachedutil2 \
    && apt-get autoremove -y

CMD ["php"]
```
pdo_pgsql.docker
```dockerfile
FROM php:5.6-cli

RUN apt-get update \
    && apt-get install -y \
        postgresql-server-dev-9.4 \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_pgsql \
    && apt-get remove -y \
        postgresql-server-dev-9.4 \
    && apt-get install -y \
        libpq5 \
    && apt-get autoremove -y

CMD ["php"]
```
zip.docker
```dockerfile
FROM php:5.6-cli

RUN apt-get update \
    && apt-get install -y \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install zip \
    && apt-get remove -y \
        zlib1g-dev \
    && apt-get install -y \
        zlib1g \
    && apt-get autoremove -y

CMD ["php"]
```































