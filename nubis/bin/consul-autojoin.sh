#!/bin/sh

# This is an auto-joiner for consul

eval `ec2metadata --user-data`

INSTANCE_ID=`ec2metadata --instance-id`
REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq '.region' -r`

LOGGER="logger --stderr --priority local7.info --tag nubis-startup"

# For now, we assume CONSUL_DC == REGION
# XXX: but will need to eventually change to REGION + ENVIRONMENT (i.e. sandbox-us-west-2)
CONSUL_DC=$REGION

#XXX: For now, default to nubis.allizom.org if not told otherwise, it's a transition path
#XXX: This is more or less a 1-to-1 mapping from environment name to domain, should be
#XXX: made discoverable / derivable somehow
if [ "$NUBIS_DOMAIN" ]; then
  NUBIS_DOMAIN="nubis.allizom.org"
fi

# We assume these follow the standard naming scheme...
CONSUL_UI="http://ui.$REGION.consul.$NUBIS_ENVIRONMENT.$NUBIS_DOMAIN"
CONSUL_JOIN="$REGION.consul.$NUBIS_ENVIRONMENT.$NUBIS_DOMAIN"

# Auto-discover secret
SECRET=`curl -s $CONSUL_UI/v1/kv/environments/$NUBIS_ENVIRONMENT/global/consul/secret?raw`
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

#XXX: Wish there was a way to self-discover members of our autoscaling group...
#XXX: For now, this points to the consul bootstrap node (SPOF)
if [ "$CONSUL_JOIN" ]; then
cat <<EOF | tee /etc/consul/zzz-join.json
{
  "retry_join": [ "$CONSUL_JOIN" ]
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

# Auto-discover certificate and key
curl -s -o /etc/consul/consul.pem $CONSUL_UI/v1/kv/environments/$NUBIS_ENVIRONMENT/global/consul/cert?raw
curl -s -o /etc/consul/consul.key $CONSUL_UI/v1/kv/environments/$NUBIS_ENVIRONMENT/global/consul/key?raw

if [ "$CONSUL_CERT" ] && [ ! -f /etc/consul/consul.pem ]; then
  echo $CONSUL_CERT | tr " " "\n" | perl -pe 's/--BEGIN\n/--BEGIN /g' | perl -pe 's/--END\n/--END /g' > /etc/consul/consul.pem
fi

if [ -f /etc/consul/consul.pem ]; then
  chown root:consul /etc/consul/consul.pem
  chmod 640 /etc/consul/consul.pem
fi

if [ "$CONSUL_KEY" ] && [ ! -f /etc/consul/consul.key ]; then
  echo $CONSUL_KEY | tr " " "\n" | perl -pe 's/--(BEGIN|END)\n/--$1 /m' | perl -pe 's/ PRIVATE\n/ PRIVATE /g' > /etc/consul/consul.key
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

service consul restart

### XXX: Wait for consul to start here

if [ -d /etc/nubis.d ]; then
  run-parts /etc/nubis.d 2>&1 | $LOGGER
fi

exit 0
