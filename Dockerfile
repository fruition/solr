ARG SOLR_VER

FROM solr:${SOLR_VER}

ENV SOLR_HEAP="1024m" \
    SOLR_VER="${SOLR_VER}"

USER root

COPY search-api-solr /tmp/search-api-solr

RUN set -eux; \
	apt-get update; \
	apt-get install -y \
	    gosu \
	    curl \
	    jq \
	    python3-pip \
	; \
    pip3 install yq; \
    \
    chown -R solr:solr /opt/solr /etc/default/ /var/solr; \
    \
    mkdir -p /opt/docker-solr/configsets; \
    /tmp/search-api-solr/download.sh; \
    chown -R solr:solr /opt/docker-solr/configsets; \
    \
    pip3 uninstall yq; \
    apt-get remove python3-pip jq; \
    rm -rf \
        /tmp/configsets \
        /tmp/search-api-solr \
        ~/.cache/pip \
        /var/lib/apt/lists/*; \


COPY entrypoint.sh /

WORKDIR /opt/docker-solr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr-foreground"]
