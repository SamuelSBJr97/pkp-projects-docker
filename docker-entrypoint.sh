#!/bin/bash
set -e

# Garante permissões corretas para cache/opcache
done
for app in src/ojs-3.5.0-1 src/omp-3.5.0-1 src/ops-3.4.0-9; do
  if [ -d "$app/cache/opcache" ]; then
    chown -R www-data:www-data "$app/cache"
    chmod -R 775 "$app/cache"
  fi
  # Cria subdiretórios se não existirem
  mkdir -p "$app/cache/opcache"
  # Opcional: cria subdiretórios comuns
  for d in 6f 6f/6f; do
    mkdir -p "$app/cache/opcache/$d"
    chown www-data:www-data "$app/cache/opcache/$d"
    chmod 775 "$app/cache/opcache/$d"
  done
done

# Inicia o Apache
exec apache2-foreground
