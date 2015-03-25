#!/bin/sh

# This is an auto-joiner for consul

eval `ec2metadata --user-data`

INSTANCE_ID=`ec2metadata --instance-id`

LOGGER="logger --stderr --priority local7.info --tag nubis-startup"

cat <<EOF | tee /etc/consul/zzz-startup.json
{
  "encrypt": "$CONSUL_SECRET",
  "datacenter": "$CONSUL_DC",
  "node_name": "$INSTANCE_ID"
}
EOF

#XXX: Wish there was a way to self-discover members of our autoscaling group...
if [ "$CONSUL_JOIN" ]; then
cat <<EOF | tee /etc/consul/zzz-join.json
{
  "retry_join": [ "$CONSUL_JOIN" ]
}
EOF
fi

if [ "$CONSUL_PUBLIC" -eq "1" ]; then
PUBLIC_IP=`ec2metadata --public-ipv4`

cat <<EOF | tee /etc/consul/zzz-public.json
{
  "advertise_addr": "$PUBLIC_IP"
}
EOF
fi

if [ "$CONSUL_BOOTSTRAP_EXPECT" ]; then
cat <<EOF | tee /etc/consul/zzz-bootstrap.json
{
  "bootstrap_expect": $CONSUL_BOOTSTRAP_EXPECT
}
EOF
fi

if [ "$CONSUL_CERT" ]; then
  echo $CONSUL_CERT | tr " " "\n" | perl -pe 's/--BEGIN\n/--BEGIN /g' | perl -pe 's/--END\n/--END /g' > /etc/consul/consul.pem
  chown root:consul /etc/consul/consul.pem
  chmod 640 /etc/consul/consul.pem
fi

if [ "$CONSUL_KEY" ]; then
  echo $CONSUL_KEY | tr " " "\n" | perl -pe 's/--(BEGIN|END)\n/--$1 /m' | perl -pe 's/ PRIVATE\n/ PRIVATE /g' > /etc/consul/consul.key
  chown root:consul /etc/consul/consul.key
  chmod 640 /etc/consul/consul.key
fi

if [ "$CONSUL_KEY" ] && [ "$CONSUL_CERT" ]; then
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
