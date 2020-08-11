#!/usr/bin/env bash

set -e

PROVISION_PATH=${PROVISION_PATH:-/vagrant}
SELF_IP=$(ip addr show eth1 | grep "inet\b" | awk '{print $2;}' | cut -d/ -f1)

apt-get update

apt-get install -y \
        curl wget tmux vim openssl unzip \
        unzip tree jq apt-transport-https ca-certificates \
        gnupg-agent software-properties-common

# disable firewall
ufw disable || echo "ufw not installed"

# install binaries
cp ${PROVISION_PATH}/bin/vault /usr/local/bin/vault
cp ${PROVISION_PATH}/bin/consul /usr/local/bin/consul
cp ${PROVISION_PATH}/bin/nomad /usr/local/bin/nomad

# prepare config dirs
mkdir -p /etc/vault.d \
      /etc/consul.d \
      /etc/nomad.d

chmod 0755 /etc/vault.d \
      /etc/consul.d \
      /etc/nomad.d

# prepare configuration


mkdir -p /etc/consul.d

### PROVISION CONSUL
CONSUL_CONF_SRC=${PROVISION_PATH}/nomad-e2e-terraform/shared/consul

cat "${CONSUL_CONF_SRC}/consul_aws.service" | \
    sed "s|172.31.0.2|127.0.0.53|g" \
        > /etc/systemd/system/consul.service

cat "${CONSUL_CONF_SRC}/base.json" | \
    sed "s|{{ GetPrivateIP }}|${SELF_IP}|g" \
        > /etc/consul.d/base.json

cat <<EOF > /etc/consul.d/retry.json
{
  "retry_join": ["10.199.0.11", "10.199.0.12", "10.199.0.13"]
}
EOF

### PROVISION NOMAD
NOMAD_CONF_SRC=${PROVISION_PATH}/nomad-e2e-terraform/shared/nomad

cp "${NOMAD_CONF_SRC}/nomad.service" /etc/systemd/system/nomad.service

cp "${NOMAD_CONF_SRC}/base.hcl" /etc/nomad.d/base.hcl

cat <<EOF > /etc/nomad.d/advertise.hcl
advertise {
  http = "${SELF_IP}"
  rpc  = "${SELF_IP}"
  serf = "${SELF_IP}"
}
EOF
