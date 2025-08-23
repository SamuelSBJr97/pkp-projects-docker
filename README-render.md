# Deploy OJS (PKP) on Render via Docker

## Estrutura
- `src/Dockerfile` imagem PHP Apache com extensões (pgsql, etc.)
- `render.yaml` define serviço web
- Disk montado em `/var/www/ojs-files` para uploads

## Passos
1. Crie Postgres no Render.
2. Adicione secret `DB_PASSWORD` no dashboard.
3. Ajuste `DB_HOST` no render.yaml ou dashboard.
4. Deploy (autoDeploy ativado).
5. Acesse URL e finalize instalação (escolha PostgreSQL e `files_dir` = `/var/www/ojs-files`).
6. Edite `config.inc.php` pós-instalação se precisar mudar `base_url`.

## Variáveis principais
PHP_MEMORY_LIMIT, PHP_UPLOAD_MAX_FILESIZE, PHP_POST_MAX_SIZE, OPCACHE_VALIDATE_TIMESTAMPS, OPCACHE_REVALIDATE_FREQ, DB_* , FILES_DIR.

## Tarefas agendadas
Render não executa cron nativo. Use um worker separado ou GitHub Action chamando script CLI `php tools/runScheduledTasks.php`.
