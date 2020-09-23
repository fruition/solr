ARG SOLR_VER

FROM solr:${SOLR_VER}

ENV SOLR_HEAP="1024m" \
    SOLR_VER="${SOLR_VER}"

USER root

COPY search-api-solr /tmp/search-api-solr

RUN set -ex; \
    \
    apk add --no-cache \
        bash \
        curl \
        grep \
        make \
        sudo; \
    \
    apk add --update --no-cache -t .solr-build-deps \
        jq \
        py3-pip \
        sed; \
    \
    pip3 install yq; \
    \
    chown -R solr:solr /opt/solr /etc/default/; \
    echo "chown solr:solr /var/solr && init-var-solr" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'solr ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes' > /etc/sudoers.d/solr; \
    \
    mkdir -p /opt/docker-solr/configsets; \
    bash /tmp/search-api-solr/download.sh; \
    chown -R solr:solr /opt/docker-solr/configsets; \
    \
    apk del --purge .solr-build-deps; \
    rm -rf \
        /tmp/configsets \
        /tmp/search-api-solr \
        /opt/solr/server/solr/mycores \
        /var/cache/apk/*

COPY entrypoint.sh /

USER solr

VOLUME /opt/solr/server/solr
WORKDIR /opt/solr/server/solr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr-foreground"]
