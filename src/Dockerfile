#############################################
# Base Image para PKP (OJS / OMP / OPS)
# Foco: disponibilizar runtime PHP + Apache
# O código das aplicações é montado via volume
#############################################

ARG PHP_VERSION=8.2
FROM php:${PHP_VERSION}-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html \
        PHP_MEMORY_LIMIT=512M \
        PHP_UPLOAD_MAX_FILESIZE=50M \
        PHP_POST_MAX_SIZE=60M \
        OPCACHE_VALIDATE_TIMESTAMPS=1 \
        OPCACHE_REVALIDATE_FREQ=2

# Dependências e extensões PHP necessárias para PKP
RUN set -eux; \
                apt-get update; \
                DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
                        libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
                        libzip-dev zip unzip \
                        libonig-dev libxml2-dev libicu-dev libxslt1-dev \
                        libpq-dev git ca-certificates; \
                docker-php-ext-configure gd --with-freetype --with-jpeg; \
                docker-php-ext-install -j"$(nproc)" gd intl mbstring zip opcache bcmath xsl ftp pgsql pdo_pgsql; \
                docker-php-ext-enable opcache; \
                a2enmod rewrite headers expires; \
                rm -rf /var/lib/apt/lists/*;

# Instala Composer (usado apenas se o código precisar de atualização de vendor)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Ajusta VirtualHost para permitir .htaccess (Friendly URLs)
RUN set -eux; \
        { \
            echo "<Directory ${APACHE_DOCUMENT_ROOT}>"; \
            echo "  AllowOverride All"; \
            echo "  Require all granted"; \
            echo "</Directory>"; \
        } > /etc/apache2/conf-available/pkp.conf; \
        printf 'ServerName localhost\n' > /etc/apache2/conf-available/servername.conf; \
        a2enconf pkp servername;

WORKDIR /var/www/html

# Copia o código do OJS para dentro da imagem (necessário em plataformas como Render onde não há volume bind)
# Estrutura atual: build context aponta para diretório externo 'src', e o código está em 'src/ojs-3.5.0-1/' dentro dele.
COPY src/ojs-3.5.0-1/ /var/www/html/

# Script de entrada que aplica permissões e inicia o Apache
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

EXPOSE 80

# Dica: para alterar a versão do PHP, usar build arg: --build-arg PHP_VERSION=8.2
