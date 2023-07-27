FROM alpine:latest

# Update and installation of tools needed to install and run glpi
RUN apk update && apk upgrade
RUN apk add apache2 mariadb-client wget

# Installation of php dependencies
RUN apk add --no-cache \
    apache2 \
    apache2-utils \
    php82-apache2 \
    php82-mysqli \
    php82-json \
    php82-ctype \
    php82-session \
    php82-dom \
    php82-xml \
    php82-xmlwriter \
    php82-xmlreader \
    php82-openssl \
    php82-gd \
    php82-zip \
    php82-curl \
    php82-mbstring \
    php82-tokenizer \
    php82-fileinfo \
    php82-pdo \
    php82-pdo_mysql \
    php82-intl \
    php82-simplexml \
    php82-exif \
    php82-ldap \
    php82-bz2 \
    php82-phar \
    php82-opcache \
    php82-iconv \
    php82-sodium

# clean apk cache
RUN rm -rf /var/cache/apk/*

#Download GLPI from the official site
RUN wget -O glpi.tar.gz https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz && \
tar xzf glpi.tar.gz -C /var/www/localhost/htdocs/ && \
rm glpi.tar.gz

# Installation of the necessary plugins for our glpi
COPY ./plugins/. /var/www/localhost/htdocs/glpi/plugins/

# Permission for glpi directory
RUN chown -R apache:apache /var/www/localhost/htdocs/glpi && \
chmod -R 755 /var/www/localhost/htdocs/glpi

# Configuration of Apache for GLPI
RUN sed -i 's/^#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/apache2/httpd.conf
RUN echo "DocumentRoot /var/www/localhost/htdocs/glpi" > /etc/apache2/conf.d/glpi.conf
RUN echo "DirectoryIndex index.php" >> /etc/apache2/conf.d/glpi.conf

# Apache execution
ENTRYPOINT ["httpd", "-D", "FOREGROUND"]
