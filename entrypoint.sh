#!/bin/bash

set -e

init-var-solr

gosu solr docker-entrypoint.sh "$@"
