#!/bin/bash

set -e

# Don't recursively chown since it is very slow, and this is only necessary on
# first start.
chown solr:solr /var/solr

gosu solr docker-entrypoint.sh "$@"
