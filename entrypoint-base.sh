#!/usr/bin/env bash
set -eo pipefail
shopt -s nullglob

cd /app

echo "Running: $@"

exec "$@"

exit 0
