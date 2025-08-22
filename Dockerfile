# Dockerfile para PKP (OJS, OMP, OPS)
FROM php:8.2-apache

# Instala extensões necessárias
RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev zip unzip mariadb-client libicu-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd mysqli pdo pdo_mysql zip bcmath intl ftp

# Habilita mod_rewrite
RUN a2enmod rewrite

# Configura diretório de trabalho
WORKDIR /var/www/html

# Script de inicialização para garantir permissões e subdiretórios de cache
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 80
