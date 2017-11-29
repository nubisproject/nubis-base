#!/bin/sh

PROXY=proxy.service.consul

# If consul doesn't resolve it for us, fallback to something constructed
if ! host $PROXY >/dev/null 2>&1; then
  echo "Using fall-back proxy" >&2

  REGION=$(nubis-region)
  NUBIS_ARENA=$(nubis-metadata NUBIS_ARENA)
  NUBIS_ACCOUNT=$(nubis-metadata NUBIS_ACCOUNT)
  NUBIS_DOMAIN=$(nubis-metadata NUBIS_DOMAIN)  
  
  PROXY="proxy.${NUBIS_ARENA}.${REGION}.${NUBIS_ACCOUNT}.${NUBIS_DOMAIN}"
fi

if [ ! -z "${PROXY}" ]; then
    export http_proxy="http://${PROXY}:3128/"
    export https_proxy="http://${PROXY}:3128/"
    export no_proxy="localhost,127.0.0.1,.localdomain,.service.consul,service.consul,.consul,consul,169.254.169.254"
    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$https_proxy"
    export NO_PROXY="$no_proxy"
fi
