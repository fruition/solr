ARG SOLR_VER

# This package was forked from wodby/solr but takes a different approach to
# bringing in the jump-start config sets from Drupal. However, there is still
# compelling reason to use the Wodby base imaege, e.g. it is alpine-based.
FROM wodby/base-solr:${SOLR_VER}

ARG SOLR_VER

ENV SOLR_HEAP="1024m" \
    SOLR_HOME=/opt/solr/server/solr \
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
    chown -R solr:solr /opt/solr /etc/default/ \
    echo "mkdir -p /opt/solr/server/solr && chown solr:solr /opt/solr/server/solr" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'solr ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes' > /etc/sudoers.d/solr; \
    \
    mkdir -p /opt/docker-solr/configsets; \
    bash /tmp/search-api-solr/download.sh; \
    # Move out from volume to always keep them inside of the image.
    mv /opt/solr/server/solr/configsets/* /opt/docker-solr/configsets/; \
    mv /opt/solr/server/solr/solr.xml /opt/docker-solr/solr.xml; \
    if [[ -d /tmp/configsets/"${SOLR_VER:0:1}"/ ]]; then \
        cp -R /tmp/configsets/"${SOLR_VER:0:1}"/* /opt/docker-solr/configsets/; \
    fi; \
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
