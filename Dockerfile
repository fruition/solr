ARG SOLR_VER

FROM solr:${SOLR_VER}

ARG SOLR_VER

# Default heap size, set the solr version for tooling and disable large/huge
# pages, which requires an init container/kernel tuning in Linux environments
# and is not required for many small installs. Override at runtime should the
# need arise. See https://github.com/docker-solr/docker-solr/issues/273
ENV SOLR_HEAP="1024m" \
    SOLR_VER="${SOLR_VER}" \
    GC_TUNE="-XX:-UseLargePages"

# We use gosu to drop down at runtime.
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
    pip3 install --no-cache-dir yq; \
    chown -R solr:solr /opt/solr /etc/default/ /var/solr; \
    mkdir -p /opt/docker-solr/configsets; \
    /tmp/search-api-solr/download.sh; \
    chown -R solr:solr /opt/docker-solr/configsets; \
    pip3 uninstall -y yq; \
    apt-get remove -y python3-pip jq; \
    apt-get autoremove -y; \
    rm -rf \
        /tmp/configsets \
        /tmp/search-api-solr \
        /var/lib/apt/lists/*;

COPY entrypoint.sh /

WORKDIR /opt/docker-solr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr-foreground"]
