# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="Z2M" \
        org.opencontainers.image.description="Zigbee Coodrination Software" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/z2m" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-z2m/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-z2m.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    Z2M_VERSION="2.7.0" \
    Z2M_REPO_URL="https://github.com/koenkk/zigbee2mqtt"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    NGINX_SITE_ENABLED=z2m \
    NGINX_WEBROOT=/var/lib/nginx/wwwroot \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_LOG_ACCESS_LOCATION=/logs/nginx \
    NGINX_LOG_ERROR_LOCATION=/logs/nginx \
    NGINX_WORKER_PROCESSES=1 \
    NODE_ENVIRONMENT=production \
    IMAGE_NAME="nfrastack/z2m" \
    IMAGE_REPO_URL="https://github.com/nfrastack/docker-z2m/"

RUN echo "" && \
    Z2M_BUILD_DEPS_ALPINE=" \
                            g++ \
                            gcc \
                            git \
                            linux-headers \
                            make \
                            nodejs \
                            npm \
                            python3 \
                        " \
                    && \
    Z2M_RUN_DEPS_ALPINE=" \
                            eudev \
                            moreutils \
                            nodejs \
                        " \
                    && \
    \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user z2m 2323 z2m 2323 /dev/null && \
    package update && \
    package upgrade && \
    package install \
                        Z2M_BUILD_DEPS \
                        Z2M_RUN_DEPS \
                    && \
    package build go && \
    package build yq && \
    \
    clone_git_repo "${Z2M_REPO_URL}" "${Z2M_VERSION}" /usr/src/z2m && \
    npm install && \
    npm run build && \
    mkdir /app && \
    mv \
        dist \
        index.js \
        LICENSE \
        package*.* \
            /app/ && \
    mkdir -p /container/data/z2m/ && \
    mv data/*.yaml /container/data/z2m/ && \
    \
    cd /app && \
    npm ci \
            --omit=dev \
            --no-audit \
            --no-optional \
            --no-update-notifier \
            && \
    \
    npm rebuild --build-from-source && \
    \
    container_build_log add "Zigbee2MQTT" "${Z2M_VERSION}" "${Z2M_REPO_URL}" && \
    package remove \
                    Z2M_BUILD_DEPS \
                    && \
    package cleanup

COPY rootfs /
