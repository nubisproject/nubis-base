#!/bin/sh

# This is an auto-joiner for consul

eval `ec2metadata --user-data`

INSTANCE_ID=`ec2metadata --instance-id`

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
  "start_join": [ "$CONSUL_JOIN" ]
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

service consul restart

if [ -d /etc/nubis.d ]; then
  run-parts /etc/nubis.d
fi

exit 0
