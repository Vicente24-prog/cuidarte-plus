#!/bin/sh
set -eu

echo "========================================="
echo "Inicializando base de datos cuidarteplus..."
echo "========================================="

PROCESSED_DUMP="/tmp/dump-processed.sql"

echo "Procesando dump-cuidarteplus.sql..."

grep -v "^DROP DATABASE" /tmp/dump-cuidarteplus.sql | \
grep -v "^CREATE DATABASE" | \
grep -v "^ALTER DATABASE cuidarteplus" | \
grep -v "^CREATE SCHEMA public" | \
grep -v "^ALTER SCHEMA public OWNER" | \
sed "s/\\\\connect cuidarteplus/\\\\c $POSTGRES_DB/g" | \
sed "s/\\\\connect $POSTGRES_DB/\\\\c $POSTGRES_DB/g" \
> "$PROCESSED_DUMP"

echo "Cargando dump procesado en la base de datos $POSTGRES_DB..."

psql \
  -v ON_ERROR_STOP=1 \
  --username "$POSTGRES_USER" \
  --dbname "$POSTGRES_DB" \
  < "$PROCESSED_DUMP"

echo "Verificando tablas creadas..."

TABLE_COUNT=$(
  psql -t -A \
    --username "$POSTGRES_USER" \
    --dbname "$POSTGRES_DB" \
    -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"
)

echo "Tablas creadas: $TABLE_COUNT"

if [ "$TABLE_COUNT" -eq 0 ]; then
  echo "ERROR: No se crearon tablas."
  exit 1
fi

echo "========================================="
echo "Base de datos inicializada correctamente."
echo "========================================="