#!/usr/bin/env bash

set -e

if [[ -z ${APACHE_DOC_ROOT} ]] ; then
    APACHE_DOC_ROOT="/var/www/html"
fi
if [[ -z ${PHP_TIMEZONE} ]] ; then
    PHP_TIMEZONE="Europe/Bratislava"
fi
if [[ -z ${XDEBUG_ENABLE} ]] ; then
    XDEBUG_ENABLE=1
fi

printenv | grep -v "no_proxy" >> /etc/environment

if [[ ! -z $1 ]] && [[ "$1" = "cron" ]] ; then
    if [[ -z ${CRON_DEFINITION_FILE} ]] ; then
        echo "Empty CRON_DEFINITION_FILE env variable" > /proc/1/fd/1 2>/proc/1/fd/2
        exit 1
    fi
    if [[ ! -f "${CRON_DEFINITION_FILE}" ]] ; then
        echo "Missing file ${CRON_DEFINITION_FILE}" > /proc/1/fd/1 2>/proc/1/fd/2
        exit 1
    fi

    cp "${CRON_DEFINITION_FILE}" /etc/cron.d/user_cron
    chmod 0644 /etc/cron.d/user_cron
    crontab /etc/cron.d/user_cron

    cron -f
    exit 0
fi

if [[ ! -z $1 ]] && [[ "$1" = "supervisor" ]] ; then
    if [[ -z ${SUPERVISOR_CONF} ]] ; then
        echo "Empty CRON_DEFINITION_FILE env variable" > /proc/1/fd/1 2>/proc/1/fd/2
        exit 1
    fi
    if [[ ! -f "${SUPERVISOR_CONF}" ]] ; then
        echo "Missing file ${SUPERVISOR_CONF}" > /proc/1/fd/1 2>/proc/1/fd/2
        exit 1
    fi

    cp "${SUPERVISOR_CONF}" /etc/supervisor/conf.d/user_def.conf

    supervisord -c /etc/supervisor.conf
    exit 0
fi

# Configure PHP date.timezone
echo "date.timezone = $PHP_TIMEZONE" > /usr/local/etc/php/conf.d/timezone.ini

# Configure Apache Document Root
mkdir -p $APACHE_DOC_ROOT
chown www-data:www-data $APACHE_DOC_ROOT
sed -i "s|DocumentRoot /var/www/html\$|DocumentRoot $APACHE_DOC_ROOT|" /etc/apache2/sites-available/000-default.conf
sed -i "s|DocumentRoot /var/www/html\$|DocumentRoot $APACHE_DOC_ROOT|" /etc/apache2/sites-available/default-ssl.conf
echo "<Directory $APACHE_DOC_ROOT>" > /etc/apache2/conf-available/document-root-directory.conf
echo "	AllowOverride All" >> /etc/apache2/conf-available/document-root-directory.conf
echo "	Require all granted" >> /etc/apache2/conf-available/document-root-directory.conf
echo "</Directory>" >> /etc/apache2/conf-available/document-root-directory.conf
a2enconf "document-root-directory.conf"

# Enable XDebug if needed
if [ "$XDEBUG_ENABLE" = "1" ]; then
#    docker-php-ext-enable xdebug
    # Configure XDebug remote host
    if [ -z "$HOST_IP" ]; then
        # Allows to set HOST_IP by env variable because could be different from the one which come from ip route command
        HOST_IP=$(/sbin/ip route|awk '/default/ { print $3 }')
    fi;
    echo "xdebug.client_host=$HOST_IP" > /usr/local/etc/php/conf.d/xdebug_remote_host.ini
fi;
if [ "$XDEBUG_ENABLE" = "0" ]; then
    docker-php-ext-disable xdebug
fi;

# Configure sSMTP
if [ "$SSMTP_MAILHUB" ]; then
    echo "mailhub=$SSMTP_MAILHUB" >> /etc/ssmtp/ssmtp.conf
fi;
if [ "$SSMTP_AUTH_USER" ]; then
    echo "AuthUser=$SSMTP_AUTH_USER" >> /etc/ssmtp/ssmtp.conf
fi;
if [ "$SSMTP_AUTH_PASS" ]; then
    echo "AuthPass=$SSMTP_AUTH_PASS" >> /etc/ssmtp/ssmtp.conf
fi;

if [ ! -z "${EXTRA_EXEC_SCRIPT}" ] && [ -f "${EXTRA_EXEC_SCRIPT}" ]; then
    . "${EXTRA_EXEC_SCRIPT}"
fi;

# exec entrypoint of php:x.x-apache
exec "apache2-foreground"

if [ ! -z "${DOCKER_DEBUG}" ]; then
    sleep 600;
fi;
