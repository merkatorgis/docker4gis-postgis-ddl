#!/bin/bash
set -e

exec psql \
    --host "${PGHOST:?PGHOST is required}" \
    --port "${PGPORT:-5432}" \
    --username "${PGUSER:-postgres}" \
    --dbname "${PGDATABASE:-postgres}" \
    "$@"
