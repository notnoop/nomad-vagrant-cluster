#!/usr/bin/env bash

set -e

PROVISION_PATH=${PROVISION_PATH:-/vagrant}
SELF_IP=$(ip addr show eth1 | grep "inet\b" | awk '{print $2;}' | cut -d/ -f1)

mkdir -p /etc/consul.d

### PROVISION CONSUL
CONSUL_CONF_SRC=${PROVISION_PATH}/nomad-e2e-terraform/shared/consul

cat "${CONSUL_CONF_SRC}/consul_client.json" | \
    sed "s|{{ GetPrivateIP }}|${SELF_IP}|g" | \
    sed "s|RETRY_JOIN|10.199.0.11|g" | \
        > /etc/consul.d/client.json

systemctl enable consul.service
systemctl daemon-reload
systemctl restart consul.service

### PROVISION NOMAD
NOMAD_CONF_SRC=${PROVISION_PATH}/nomad-e2e-terraform/shared/nomad

cat <<EOF > /etc/nomad.d/client.hcl
client {
  enabled = true
}
EOF

systemctl enable nomad.service
systemctl daemon-reload
systemctl restart nomad.service
