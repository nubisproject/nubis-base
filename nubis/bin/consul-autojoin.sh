#!/bin/sh

# This is an auto-joiner for consul

eval `curl -fq http://169.254.169.254/latest/user-data`

INSTANCE_ID=`curl -fq http://169.254.169.254/latest/meta-data/instance-id`
REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq '.region' -r`

LOGGER="logger --stderr --priority local7.info --tag nubis-startup"

if [ ! -z "$NUBIS_ACCOUNT" ]; then
  CONSUL_DC="${NUBIS_ENVIRONMENT}-${REGION}-${NUBIS_ACCOUNT}"
else
  CONSUL_DC=$REGION
fi

#XXX: For now, default to nubis.allizom.org if not told otherwise, it's a transition path
#XXX: This is more or less a 1-to-1 mapping from environment name to domain, should be
#XXX: made discoverable / derivable somehow
if [ -z "$NUBIS_DOMAIN" ]; then
  NUBIS_DOMAIN="nubis.allizom.org"
fi

# CONSUL_SECRET is a proxy to detect this is a Consul Server starting up
if [ -z "$CONSUL_SECRET" ]; then
  CONSUL_SERVICE_NAME="consul"
else
  CONSUL_SERVICE_NAME="$NUBIS_PROJECT"
fi

# We assume these follow the standard naming scheme...
if [ -z ! "$NUBIS_ACCOUNT" ]; then
  CONSUL_DOMAIN="$REGION.$CONSUL_SERVICE_NAME.$NUBIS_ENVIRONMENT.$NUBIS_DOMAIN"
else
  CONSUL_DOMAIN="$CONSUL_SERVICE_NAME.$NUBIS_ENVIRONMENT.$REGION.$NUBIS_ACCOUNT"
fi

CONSUL_UI="http://ui.$CONSUL_DOMAIN"
CONSUL_JOIN="$CONSUL_DOMAIN"

# Auto-discover secret
SECRET=`curl -f -s $CONSUL_UI/v1/kv/environments/$NUBIS_ENVIRONMENT/global/consul/secret?raw`
if [ "$SECRET" ]; then
  CONSUL_SECRET=$SECRET
fi

cat <<EOF | tee /etc/consul/zzz-startup.json
{
  "encrypt": "$CONSUL_SECRET",
  "datacenter": "$CONSUL_DC",
  "node_name": "$INSTANCE_ID"
}
EOF

# Auto-discover initial servers with fallback to $CONSUL_JOIN
SERVERS=`curl -qfs $CONSUL_UI/v1/status/peers | jq "[ . |= .+ [\"$CONSUL_JOIN\"] | .[] | split(\":\") | .[0] ]"`

#XXX: Wish there was a way to self-discover members of our autoscaling group...
#XXX: For now, this points to the consul bootstrap node (SPOF)
if [ "$SERVERS" ]; then
cat <<EOF | tee /etc/consul/zzz-join.json
{
  "retry_join": $SERVERS
}
EOF
fi

# This is only used by Consul servers (needs moving to nubis-consul)
if [ "$CONSUL_BOOTSTRAP_EXPECT" ]; then
cat <<EOF | tee /etc/consul/zzz-bootstrap.json
{
  "bootstrap_expect": $CONSUL_BOOTSTRAP_EXPECT
}
EOF
fi

# This is only used by Consul servers (needs moving to nubis-consul)
if [ "$CONSUL_MASTER_ACL_TOKEN" ]; then

  # Default to allow all
  if [ -z "$CONSUL_ACL_DEFAULT_POLICY" ]; then
    CONSUL_ACL_DEFAULT_POLICY="allow"
  fi

  # default to cached (and maybe stale) ACLs
  if [ -z "$CONSUL_ACL_DOWN_POLICY" ]; then
    CONSUL_ACL_DOWN_POLICY="extend-cache"
  fi

cat <<EOF | tee /etc/consul/zzz-acl.json
{
  "acl_datacenter": "$CONSUL_DC",
  "acl_master_token": "$CONSUL_MASTER_ACL_TOKEN",
  "acl_default_policy": "$CONSUL_ACL_DEFAULT_POLICY",
  "acl_down_policy": "$CONSUL_ACL_DOWN_POLICY"
}
EOF
fi

# Discover our ACL token (needs moving to nubis-consul)
if [ "$CONSUL_ACL_TOKEN" ]; then

cat <<EOF | tee /etc/consul/zzz-acl-token.json
{
  "acl_token": "$CONSUL_ACL_TOKEN"
}
EOF
fi

# Auto-discover certificate and key
curl -f -s -o /etc/consul/consul.pem $CONSUL_UI/v1/kv/environments/$NUBIS_ENVIRONMENT/global/consul/cert?raw
curl -f -s -o /etc/consul/consul.key $CONSUL_UI/v1/kv/environments/$NUBIS_ENVIRONMENT/global/consul/key?raw

if [ "$CONSUL_CERT" ] && [ ! -f /etc/consul/consul.pem ]; then
  echo $CONSUL_CERT | tr " " "\n" | perl -pe 's/--BEGIN\n/--BEGIN /g' | perl -pe 's/--END\n/--END /g' > /etc/consul/consul.pem
fi

if [ -f /etc/consul/consul.pem ]; then
  chown root:consul /etc/consul/consul.pem
  chmod 640 /etc/consul/consul.pem
fi

if [ "$CONSUL_KEY" ] && [ ! -f /etc/consul/consul.key ]; then
  echo $CONSUL_KEY | tr " " "\n" | perl -pe 's/--(BEGIN|END)\n/--$1 /m' | perl -pe 's/ RSA\n/ RSA /g' | perl -pe 's/ PRIVATE\n/ PRIVATE /g' > /etc/consul/consul.key
fi

if [ -f /etc/consul/consul.key ]; then
  chown root:consul /etc/consul/consul.key
  chmod 640 /etc/consul/consul.key
fi

if [ -f /etc/consul/consul.key ] && [ -f /etc/consul/consul.pem ]; then
cat <<EOF | tee /etc/consul/zzz-tls.json
{
  "ca_file"         : "/etc/consul/consul.pem",
  "cert_file"       : "/etc/consul/consul.pem",
  "key_file"        : "/etc/consul/consul.key",
  "verify_incoming" : true,
  "verify_outgoing" : true
}
EOF
fi

# Perform a clean nuke and restart of Consul
service consul stop
rm -rf /var/lib/consul/serf/*
service consul start

### XXX: Wait for consul to start here

if [ -d /etc/nubis.d ]; then
  run-parts /etc/nubis.d 2>&1 | $LOGGER
fi

exit 0
