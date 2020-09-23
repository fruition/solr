#!/usr/bin/env bash

export SOLR_VER=8
DOCKER_HUB_IMAGE=fruition/solr

docker build \
  --build-arg SOLR_VER=$SOLR_VER \
  -t "$DOCKER_HUB_IMAGE":"$SOLR_VER" \
  .

docker tag "$DOCKER_HUB_IMAGE":"${SOLR_VER:0:1}" "$DOCKER_HUB_IMAGE":latest

docker push "$DOCKER_HUB_IMAGE":"${SOLR_VER:0:1}"
docker push "$DOCKER_HUB_IMAGE":latest
