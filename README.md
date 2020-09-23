# Apache Solr Docker Image

Forked from [`wodby/solr`](https://github.com/wodby/solr). Their build process
has become slightly out of date and is opinionated to their stack.

## Why this image?

This image extends [`wodby/base-solr`](https://github.com/wodby/base-solr),
an Alpine-based implementation of the upstream solr image. It diverges to
include ["jump-start" config sets](https://www.drupal.org/node/3070455) from the
Drupal `search_api_solr` module.

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
    - solr:/opt/solr/server/solr
    command:
    - solr-precreate
    - my-core
    - search_api_solr_8.x-4.0
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
  - search_api_solr_8.x-4.0
  image: fruition/solr:8
  volumeMounts:
  - mountPath: /opt/solr
    name: your-pvc
    subPath: solr
```

After the core is created, you _can_ (but don't need to) remove the `args`
section and the container will proceed directly to running Solr in the
foreground.
