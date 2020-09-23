#!/usr/bin/env bash

set -e

export SOLR_VER=8.6.2
DOCKER_HUB_IMAGE=fruition/solr

docker build --no-cache \
  --build-arg SOLR_VER=$SOLR_VER \
  -t "$DOCKER_HUB_IMAGE":"$SOLR_VER" \
  .

docker tag "$DOCKER_HUB_IMAGE":"${SOLR_VER}" "$DOCKER_HUB_IMAGE":latest
docker tag "$DOCKER_HUB_IMAGE":"${SOLR_VER}" "$DOCKER_HUB_IMAGE":"${SOLR_VER:0:1}"

docker push "$DOCKER_HUB_IMAGE":"${SOLR_VER}"
docker push "$DOCKER_HUB_IMAGE":"${SOLR_VER:0:1}"
docker push "$DOCKER_HUB_IMAGE":latest
