\i ../v290/migrate-db-postgres.sql
\i ../v290/migrate-default.sql
\i ../v2100/migrate-default.sql
\i ../v2110/1-migrate-db-postgres.sql
\i 2-migrate-default-mongeosource.sql
\i ../v2110/3-create-tmp-tables-postgres.sql
\i ../v2110/4-copy-to-tmp-default.sql
\i ../v2110/5-recreate-old-tables-postgres.sql

\i drop-languages.sql
\i migrate-harvesters.sql