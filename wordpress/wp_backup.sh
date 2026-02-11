#!/usr/bin/env bash
set -euo pipefail

# ===== Config you MAY override at runtime (defaults match your compose) =====
ENV_FILE="${ENV_FILE:-./.env}"     # path to your compose .env
DB_CONTAINER="${DB_CONTAINER:-wp-db}"
WP_CONTAINER="${WP_CONTAINER:-wp-app}"
WP_VOLUME="${WP_VOLUME:-wp_data}"
BACKUP_DIR="${BACKUP_DIR:-$PWD/backups}"

# ===== Load .env (same vars used by docker-compose) =====
if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ .env not found at $ENV_FILE (set ENV_FILE=... if needed)"; exit 1
fi
set -a
# shellcheck disable=SC1090
. "$ENV_FILE"
set +a

# ===== Resolve DB creds/params from .env (with sensible fallbacks) =====
DB_ROOT="${MARIADB_ROOT_PASSWORD:-${MYSQL_ROOT_PASSWORD:-}}"
DB_NAME="${WORDPRESS_DB_NAME:-${MYSQL_DATABASE:-wordpress}}"
DB_USER="${WORDPRESS_DB_USER:-${MYSQL_USER:-wpuser}}"
DB_PASS="${WORDPRESS_DB_PASSWORD:-${MYSQL_PASSWORD:-}}"

[[ -n "$DB_ROOT" ]] || { echo "❌ DB root password not found in .env (MYSQL_ROOT_PASSWORD or MARIADB_ROOT_PASSWORD)"; exit 1; }

TS="$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "▶ Dumping database '$DB_NAME' from container '$DB_CONTAINER' ..."
docker exec "$DB_CONTAINER" sh -lc \
  "mariadb-dump -uroot -p'$DB_ROOT' --databases '$DB_NAME'" \
  > "$BACKUP_DIR/db_${DB_NAME}_${TS}.sql"

echo "▶ Archiving WordPress files from volume '$WP_VOLUME' ..."
docker run --rm -v "$WP_VOLUME":/data -v "$BACKUP_DIR":/backup alpine \
  sh -lc "cd /data && tar czf /backup/wp_data_${TS}.tgz ."

echo "✅ Backup complete:"
echo "  - DB dump : $BACKUP_DIR/db_${DB_NAME}_${TS}.sql"
echo "  - Files   : $BACKUP_DIR/wp_data_${TS}.tgz"

