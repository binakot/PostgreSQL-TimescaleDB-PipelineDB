# https://github.com/docker-library/postgres/blob/master/11/alpine/Dockerfile
FROM postgres:11.3-alpine

MAINTAINER Ivan Muratov, binakot@gmail.com

# https://docs.timescale.com/v1.3/getting-started/installation/ubuntu/installation-source
# https://github.com/timescale/timescaledb-docker
ENV TIMESCALEDB_VERSION 1.3.0
ENV TIMESCALEDB_SHA256 9a773f40c7109694ffb9f2eb2c306e70dd04079c010d276c4d60ae88433a6b4c
RUN set -ex \
    && apk add --no-cache --virtual .fetch-deps \
        ca-certificates \
        openssl \
        openssl-dev \
        tar \
    && apk add --no-cache --virtual .build-deps \
        make \
        cmake \
        gcc \
        dpkg \
        dpkg-dev \
        util-linux-dev \
        libc-dev \
        coreutils \
    \
    && wget -O timescaledb.tar.gz "https://github.com/timescale/timescaledb/archive/$TIMESCALEDB_VERSION.tar.gz" \
    && echo "$TIMESCALEDB_SHA256 *timescaledb.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/timescaledb \
    && tar \
        --extract \
        --file timescaledb.tar.gz \
        --directory /usr/src/timescaledb \
        --strip-components 1 \
    && rm timescaledb.tar.gz \
    \
    && cd /usr/src/timescaledb \
    && ./bootstrap -DPROJECT_INSTALL_METHOD="docker" \
    && cd ./build && make install \
    \
    && cd / \
    && rm -rf /usr/src/timescaledb \
    && apk del .fetch-deps .build-deps \
    && sed -r -i "s/[#]*\s*(shared_preload_libraries)\s*=\s*'(.*)'/\1 = 'timescaledb,\2'/;s/,'/'/" /usr/local/share/postgresql/postgresql.conf.sample

# http://docs.pipelinedb.com/installation.html
# https://github.com/pipelinedb/docker
ENV PIPELINEDB_VERSION 1.0.0-13
ENV PIPELINEDB_SHA256 b97142df8d6a9dff90e7233abe3d9c2005ff9c6b5deee32ce2f4262344f5efa0
RUN set -ex \
    && apk add --no-cache --virtual .fetch-deps \
        ca-certificates \
        openssl \
        openssl-dev \
        tar \
    && apk add --no-cache --virtual .build-deps \
        make \
        g++ \
        libc-dev \
        libexecinfo-dev \
        postgresql-dev \
        zeromq-dev \
    \
    && wget -O pipelinedb.tar.gz "https://github.com/pipelinedb/pipelinedb/archive/$PIPELINEDB_VERSION.tar.gz" \
    && echo "$PIPELINEDB_SHA256 *pipelinedb.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/pipelinedb \
    && tar \
        --extract \
        --file pipelinedb.tar.gz \
        --directory /usr/src/pipelinedb \
        --strip-components 1 \
    && rm pipelinedb.tar.gz \
    \
    && cd /usr/src/pipelinedb \
    \
    # Hotfix to support Alpine compilation https://github.com/pipelinedb/pipelinedb/pull/1989
    && sed -i -e 's#/usr/lib/libzmq.a -lstdc++#-lzmq -lstdc++ -fPIC#g' Makefile \
    && sed -i -e '/^\s*size_t size = backtrace(array, 32);$/i #ifdef GLIBC' src/scheduler.c \
    && sed -i -e '/^\s*backtrace_symbols_fd(array, size, STDERR_FILENO);$/a #endif' src/scheduler.c \
    && sed -n 126,138p src/scheduler.c \
    \
    && make USE_PGXS=1 \
    && make install \
    \
    && cd / \
    && rm -rf /usr/src/pipelinedb \
    && apk del .fetch-deps .build-deps \
    && apk add --no-cache libexecinfo libzmq \
    && sed -r -i "s/[#]*\s*(shared_preload_libraries)\s*=\s*'(.*)'/\1 = 'pipelinedb,\2'/;s/,'/'/" /usr/local/share/postgresql/postgresql.conf.sample

COPY ./init-timescaledb.sh /docker-entrypoint-initdb.d/1.timescaledb.sh
COPY ./init-pipelinedb.sh /docker-entrypoint-initdb.d/2.pipelinedb.sh
COPY ./init-postgres.sh /docker-entrypoint-initdb.d/3.postgres.sh
