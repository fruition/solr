#!/bin/bash

set -e

# Don't recursively chown since it is very slow, and this is only necessary on
# first start.

run-parts --exit-on-error --regex='.*' /usr/lib/fruition/bootstrap

gosu solr docker-entrypoint.sh "$@"
