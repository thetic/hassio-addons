FROM rhasspy/rhasspy:2.5.9
LABEL maintainer="Michael Hansen <mike@rhasspy.org>"

ENV \
    LANG="C.UTF-8" \
    DEBIAN_FRONTEND="noninteractive" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    CONFIG_PATH=/data/options.json

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Base system
ARG BASHIO_VERSION=0.12.1
ARG TEMPIO_VERSION=2021.01.0
ARG S6_OVERLAY_VERSION=2.1.0.2

ARG BUILD_ARCH

RUN \
    set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        bash \
        jq \
        tzdata \
        curl \
        ca-certificates \
        nginx \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/share/man/man1 \
    \
    # TODO hardcoded arm arch
    && curl -L -f -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-arm.tar.gz" \
        | tar zxvf - -C / \
    && mkdir -p /etc/fix-attrs.d \
    && mkdir -p /etc/services.d \
    \
    && curl -L -f -s -o /usr/bin/tempio \
        "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}" \
    && chmod a+x /usr/bin/tempio \
    \
    && mkdir -p /tmp/bashio \
    && curl -L -f -s "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" \
        | tar -xzf - --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio

# S6-Overlay
ENTRYPOINT ["/init"]

COPY rootfs /

CMD ["/run.sh"]
