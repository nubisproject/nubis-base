#!/bin/sh

host proxy.service.consul >/dev/null 2>&1

RV=$?

if [ "${RV}" = 0 ]; then
  PROXY=proxy.service.consul
fi

# Fallback
if [ -z "${PROXY}" ]; then
  REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq '.region' -r)
  NUBIS_ENVIRONMENT=$(nubis-metadata NUBIS_ENVIRONMENT)
  NUBIS_ACCOUNT=$(nubis-metadata NUBIS_ACCOUNT)
  NUBIS_DOMAIN=$(nubis-metadata NUBIS_DOMAIN)
  PROXY_FALLBACK="proxy.${NUBIS_ENVIRONMENT}.${REGION}.${NUBIS_ACCOUNT}.${NUBIS_DOMAIN}"

  host "$PROXY_FALLBACK" >/dev/null 2>&1
  RV=$?

  if [ "${RV}" = 0 ]; then
    PROXY="${PROXY_FALLBACK}"
  fi
fi

if [ ! -z "${PROXY}" ]; then
    # For now, we safely assume every instance we could care about are in a /24 network
    NETWORK_IPS=$(/usr/local/bin/nubis-network-ips 24)
    export http_proxy="http://${PROXY}:3128/"
    export https_proxy="http://${PROXY}:3128/"
    export no_proxy="localhost,127.0.0.1,.localdomain,.service.consul,169.254.169.254,$NETWORK_IPS"
    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$https_proxy"
    export NO_PROXY="$no_proxy"
fi
