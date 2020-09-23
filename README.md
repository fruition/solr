# Apache Solr Docker Image

## Why this image?

Forked from [`wodby/solr`](https://github.com/wodby/solr). Their build process
has become slightly out of date and is opinionated to their stack. This image
extends [`library/solr`](https://github.com/docker-solr/docker-solr), but
preserves the Wodby-inspired bootstrapping to chown the data directory to the
`solr` user, as well as a build pipeline that imports Drupal's `search_api_solr`
jump-start config sets for immediate use.

## Tags

* `8.6.2`, `8`, `latest` _([Dockerfile](https://github.com/fruition/solr/blob/master/Dockerfile))_

Prior versions of Solr may be configured for builds if demand is demonstrated by
community usage.

This image only builds to "current" Drupal API compatibility as pulled from the
module update API, meaning Drupal 8+.

## Environment Variables

| Variable                  | Default Value | Description                     |
| ------------------------- | ------------- | ------------------------------- |
| `SOLR_HEAP`               | `1024m `      | Default JVM heap size. |

## Usage

### Local development

`docker-compose.yml` service example:
```yaml
services:
  solr:
    image: fruition/solr:8
    volumes:
    - solr:/var/solr
    command:
    - solr-precreate
    - my-core
    - /opt/docker-solr/configsets/search_api_solr_4.1.6
volumes:
  solr: {}
```

### Kubernetes

Deployment container spec excerpt (e.g., running in pod with your application):
```yaml
containers:
- name: solr
  args:
  - solr-precreate
  - my-core
  - /opt/docker-solr/configsets/search_api_solr_4.1.6
  image: fruition/solr:8
  volumeMounts:
  - mountPath: /var/solr
    name: your-pvc
    subPath: solr
```

After the core is created, you _can_ (but don't need to) remove the `args`
section and the container will proceed directly to running Solr in the
foreground.
