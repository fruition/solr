#!/bin/bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

sudo /opt/docker-solr/scripts/solr-fix-permissions

if [[ ! -e /opt/solr/server/solr/solr.xml ]]; then
    cp /opt/docker-solr/solr.xml /opt/solr/server/solr/solr.xml
fi

if [[ ! -d /opt/solr/server/solr/configsets ]]; then
    cp -r /opt/docker-solr/configsets /opt/solr/server/solr/configsets
fi

sed -i 's@^SOLR_HEAP=".*"@'"SOLR_HEAP=${SOLR_HEAP}"'@' /opt/solr/bin/solr.in.sh

if [[ "${1}" == 'make' ]]; then
    exec "$@" -f /opt/docker-solr/scripts/solr.mk -f /opt/docker-solr/scripts/rewrite.mk
else
    exec "$@"
fi

exec docker-entrypoint.sh "$@"