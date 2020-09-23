#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

init-var-solr

gosu docker-entrypoint.sh "$@"
