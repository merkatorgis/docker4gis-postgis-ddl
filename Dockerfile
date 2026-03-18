# check=skip=InvalidDefaultArgInFrom

FROM ubuntu:24.04

ARG POSTGRESQL_CLIENT_VERSION=17
ENV POSTGRESQL_CLIENT_VERSION=${POSTGRESQL_CLIENT_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    ca-certificates \
    postgresql-client \
    gettext-base \
    && apt clean

COPY conf/schema.sh /usr/local/bin/
COPY conf/last.sh /usr/local/bin/
COPY conf/pg.sh /usr/local/bin/
COPY ["conf/subconf.sh", "conf/onstart.sh", "conf/entrypoint", "/"]

COPY conf/mail /tmp/mail
COPY conf/web /tmp/web
COPY conf/admin /tmp/admin
COPY conf/wms /tmp/wms

RUN chmod +x /usr/local/bin/schema.sh \
    /usr/local/bin/last.sh \
    /usr/local/bin/pg.sh \
    /subconf.sh \
    /onstart.sh \
    /entrypoint

ENTRYPOINT ["/entrypoint"]
CMD ["ddl"]

# Make this image work with dg build & dg push.
COPY build.sh run.sh /.docker4gis/

# Set environment variables.
ONBUILD ARG DOCKER_REGISTRY
ONBUILD ENV DOCKER_REGISTRY=$DOCKER_REGISTRY
ONBUILD ARG DOCKER_USER
ONBUILD ENV DOCKER_USER=$DOCKER_USER
ONBUILD ARG DOCKER_REPO
ONBUILD ENV DOCKER_REPO=$DOCKER_REPO

# Make this an extensible base component; see
# https://github.com/merkatorgis/docker4gis/tree/npm-package/docs#extending-base-components.
COPY template /template/

