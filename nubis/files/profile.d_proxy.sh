#!/bin/sh

# If we do not have metadata this is likely a build
#+ therefore we do not want any proxy configuration
if [ "$(nubis-metadata status)" = 'ready' ]; then
    PROXY=proxy.service.consul
    # If consul doesn't resolve it for us, fallback to something constructed
    if ! host $PROXY >/dev/null 2>&1; then
        REGION=$(nubis-metadata INSTANCE_IDENTITY_REGION)
        NUBIS_ARENA=$(nubis-metadata NUBIS_ARENA)
        NUBIS_ACCOUNT=$(nubis-metadata NUBIS_ACCOUNT)
        NUBIS_DOMAIN=$(nubis-metadata NUBIS_DOMAIN)

        if [ ! -z "$REGION" ] && [ ! -z "$NUBIS_ARENA" ] && [ ! -z "$NUBIS_ACCOUNT" ] && [ ! -z "$NUBIS_DOMAIN" ]; then
            echo "Using fall-back proxy" >&2
            PROXY="proxy.${NUBIS_ARENA}.${REGION}.${NUBIS_ACCOUNT}.${NUBIS_DOMAIN}"
        else
            echo "No proxy available" >&2
            unset PROXY
        fi
    fi
    if [ ! -z "${PROXY}" ]; then
        export http_proxy="http://${PROXY}:3128/"
        export https_proxy="http://${PROXY}:3128/"
        export no_proxy="localhost,127.0.0.1,.localdomain,.service.consul,service.consul,.consul,consul,169.254.169.254"
        export HTTP_PROXY="$http_proxy"
        export HTTPS_PROXY="$https_proxy"
        export NO_PROXY="$no_proxy"
    fi
fi
