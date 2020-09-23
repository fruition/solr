#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

sudo init_volumes

if [[ ! -f /opt/solr/server/solr/solr.xml ]]; then
    ln -s /opt/docker-solr/solr.xml /opt/solr/server/solr/solr.xml
fi

if [[ -f /opt/solr/bin/solr.in.sh ]]; then
    conf_file=/opt/solr/bin/solr.in.sh
else
    conf_file=/etc/default/solr.in.sh
fi

sed -E -i 's@^#SOLR_HEAP=".*"@'"SOLR_HEAP=${SOLR_HEAP}"'@' "${conf_file}"

exec docker-entrypoint.sh "$@"
