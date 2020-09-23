#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

cd /opt/docker-solr/

api_url="https://updates.drupal.org/release-history/search_api_solr"
search_api_url="https://ftp.drupal.org/files/projects/search_api_solr"

for drupal in "current" "7.x"; do
    versions=($(curl -s "${api_url}/${drupal}" | xq -r '.project.releases[] | .[] | select (has("version_extra") | not).version'))

    for version in "${versions[@]}"; do
        tmp_dir="search_api_solr_${version}"
        mkdir -p "${tmp_dir}"
        wget -qO- "${search_api_url}-${version}.tar.gz" | tar xz -C "${tmp_dir}"

        dir="${tmp_dir}/search_api_solr/"

        echo -n "Search Api Solr ${version}: "

        if [[ -d "${dir}/jump-start/solr${SOLR_VER}" ]]; then
            echo "adding jump-start config set for ${SOLR_VER:0:1}.x"
            conf_dir="configsets/search_api_solr_${version}"
            mkdir -p "${conf_dir}"
            mv "${dir}/jump-start/solr${SOLR_VER:0:1}/config-set" "${conf_dir}/conf"
        elif [[ -d "${dir}/solr-conf/${SOLR_VER:0:1}.x" ]]; then
            echo "adding config set for ${SOLR_VER:0:1}.x"
            conf_dir="configsets/search_api_solr_${version}"
            mkdir -p "${conf_dir}"
            mv "${dir}/solr-conf/${SOLR_VER:0:1}.x" "${conf_dir}/conf"
        elif [[ -d "${dir}/solr-conf-templates" ]]; then
            echo "This version of solr does not provide full or jump-start configsets. They should be generated via the module and added manually."
        else
            echo "does not support Solr ${SOLR_VER:0:1}.x"
        fi

        rm -rf "${tmp_dir}"
    done
done
