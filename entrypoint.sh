#!/bin/bash

set -e

init-var-solr

gosu docker-entrypoint.sh "$@"
