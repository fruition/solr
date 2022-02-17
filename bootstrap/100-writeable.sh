#!/usr/bin/env bash

set -e

# If there are directories to ensure are writable, make them so; don't do this if we mark the host OS as Mac
# given these directories should be mounted over NFS and file permissions cannot be set for non-bind-mount directories.

if [[ ! -z "$WRITEABLE_DIRS" ]] && [[ "${HOST_OS:-undefined}" != "Darwin" ]]; then
    printf "Changing ownership of configured writeable directories; this is sometimes slow.\n"
    printf "See https://github.com/docker/for-linux/issues/388 - this functionality may change in the future.\nDirectories: \n"
    IFS='|' read -ra DIR <<< "$WRITEABLE_DIRS"
    for dn in "${DIR[@]}"; do
        printf "\t$dn\n"
        mkdir -p dn
        chown -R solr:solr $dn
    done
    printf "\n"
fi
