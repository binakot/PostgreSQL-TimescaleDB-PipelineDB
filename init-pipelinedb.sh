#!/bin/sh

set -e

# Create the 'template_pipelinedb' template db
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE DATABASE template_pipelinedb;
	UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_pipelinedb';
EOSQL

# Load PipelineDB into both template_database and $POSTGRES_DB
for DB in template_pipelinedb "$POSTGRES_DB"; do
	echo "Loading PipelineDB extensions into $DB"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname="$DB" <<-EOSQL
		CREATE EXTENSION IF NOT EXISTS pipelinedb CASCADE;
	EOSQL
done
