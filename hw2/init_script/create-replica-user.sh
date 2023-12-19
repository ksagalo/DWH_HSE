psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    DROP ROLE IF EXISTS replicator;
    CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'my_replicator_password';
    DO
    \$\$
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM pg_replication_slots WHERE slot_name = 'replication_slot_slave1'
        ) THEN
            PERFORM pg_create_physical_replication_slot('replication_slot_slave1');
        END IF;
    END
    \$\$;
EOSQL

