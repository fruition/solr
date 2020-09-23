#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

sudo init_volumes

mkdir -p /opt/solr/server/solr/configsets

# Symlinks config sets to volume.
for configset in $(ls -d /opt/docker-solr/configsets/*); do
    if [[ ! -d "/opt/solr/server/solr/configsets/${configset##*/}" ]]; then
        ln -s "${configset}" /opt/solr/server/solr/configsets/;
    fi
done

if [[ ! -f /opt/solr/server/solr/solr.xml ]]; then
    ln -s /opt/docker-solr/solr.xml /opt/solr/server/solr/solr.xml
fi

exec docker-entrypoint.sh "$@"
