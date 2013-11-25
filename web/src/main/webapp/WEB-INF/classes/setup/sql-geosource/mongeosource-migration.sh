# Usage: ./mongeosource-migration.sh www-data db_1044
cd migrate
psql -U $1 -f v290/migrate-db-postgres.sql $2
psql -U $1 -f v290/migrate-default.sql $2
psql -U $1 -f v2100/migrate-default.sql $2
psql -U $1 -f v2110/1-migrate-db-postgres.sql $2
psql -U $1 -f v2110/2-migrate-default.sql $2
psql -U $1 -f v2110/3-create-tmp-tables-postgres.sql $2
psql -U $1 -f v2110/4-copy-to-tmp-default.sql $2
psql -U $1 -f v2110/5-recreate-old-tables-postgres.sql $2

