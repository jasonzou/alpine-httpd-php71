FROM jasonzou/alpine-httpd:latest

# Calculate download URL
ENV VERSION 4.7.1
ENV URL https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-english.tar.gz

# Install php 7
RUN apk --no-cache --update --repository=http://dl-4.alpinelinux.org/alpine/edge/testing add \
    curl \
    php7 \
    php7-apache2 \
    php7-xml \
    php7-mysqli \
    php7-pdo_mysql \
    php7-mcrypt \
    php7-opcache \
    php7-gd \
    php7-curl \
    php7-json \
    php7-phar \
    php7-openssl \
    php7-ctype \
    php7-mbstring \
    php7-dom \
    php7-pcntl \
    php7-session && \
  curl --output /tmp/t.tgz --location $URL && \
  cd /tmp && \
  tar xvf /tmp/t.tgz && \
  ls -al && \
  mkdir -p /var/www/localhost/myadmin && \
  cp -R /tmp/phpMyAdmin-${VERSION}-english/* /var/www/localhost/myadmin && \
  rm -rf /var/cache/apk/* && \
  chown -R apache:apache /var/www/localhost/myadmin

#RUN sed -ri 's/#LoadModule mpm_prefork^PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/apache/httpd.conf && \
# Copy configuration
COPY files/config.*.php /var/www/localhost/myadmin/

# Add the files
ADD rootfs /

# Small fixes
RUN ln -s /etc/php7 /etc/php && \
    ln -s /usr/lib/php7 /usr/lib/php && \
    rm -fr /var/cache/apk/*

# EntryPoint
ENTRYPOINT ["/init"]

CMD []

# Expose the ports for nginx
EXPOSE 9999
