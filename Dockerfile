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
	rm -rf /var/lib/apt/lists/*; \
    pip3 install yq; \
    \
    chown -R solr:solr /opt/solr /etc/default/ /var/solr; \
    \
    mkdir -p /opt/docker-solr/configsets; \
    bash /tmp/search-api-solr/download.sh; \
    chown -R solr:solr /opt/docker-solr/configsets; \
    \
    rm -rf \
        /tmp/configsets \
        /tmp/search-api-solr

COPY entrypoint.sh /

USER solr

VOLUME /opt/solr/server/solr
WORKDIR /opt/solr/server/solr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr-foreground"]
