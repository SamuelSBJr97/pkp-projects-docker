#!/bin/bash
set -euo pipefail

APP_ROOT="/var/www/html"
CACHE_DIRS=(cache cache/_db cache/t_cache cache/t_compile cache/t_config cache/opcache)

echo "[entrypoint] Ajustando permissões em ${APP_ROOT}"

if [ -d "$APP_ROOT" ]; then
  for d in "${CACHE_DIRS[@]}"; do
    mkdir -p "$APP_ROOT/$d"
  done
  # Subdir extra para opcache (estrutura que alguns scripts esperam)
  mkdir -p "$APP_ROOT/cache/opcache/6f/6f"
  chown -R www-data:www-data "$APP_ROOT/cache"
  chmod -R 775 "$APP_ROOT/cache"
fi

# Define ini customizado via env vars
PHP_INI_DIR="/usr/local/etc/php/conf.d"
CUSTOM_INI="${PHP_INI_DIR}/zz-pkp.ini"
cat > "$CUSTOM_INI" <<EOF
memory_limit = ${PHP_MEMORY_LIMIT:-512M}
upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE:-50M}
post_max_size = ${PHP_POST_MAX_SIZE:-60M}
opcache.validate_timestamps = ${OPCACHE_VALIDATE_TIMESTAMPS:-1}
opcache.revalidate_freq = ${OPCACHE_REVALIDATE_FREQ:-2}
EOF

echo "[entrypoint] Iniciando Apache"
exec "$@"
