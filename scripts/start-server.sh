#!/usr/bin/env bash

set -e

PROVISION_PATH=${PROVISION_PATH:-/vagrant}
SELF_IP=$(ip addr show eth1 | grep "inet\b" | awk '{print $2;}' | cut -d/ -f1)

mkdir -p /etc/consul.d

### PROVISION CONSUL
CONSUL_CONF_SRC=${PROVISION_PATH}/nomad-e2e-terraform/shared/consul

cat "${CONSUL_CONF_SRC}/server.json" | \
    sed "s|{{ GetPrivateIP }}|${SELF_IP}|g" | \
    sed "s|SERVER_COUNT|${SERVER_COUNT}|g" \
        > /etc/consul.d/server.json

systemctl enable consul.service
systemctl daemon-reload
systemctl restart consul.service

### PROVISION NOMAD
NOMAD_CONF_SRC=${PROVISION_PATH}/nomad-e2e-terraform/shared/nomad

cat "${NOMAD_CONF_SRC}/server.hcl" | \
    sed "s|bootstrap_expect.*|bootstrap_expect = ${SERVER_COUNT}|g" | \
    sed "s|http://active.vault.service.consul:8200|http://127.0.0.1:8200|g" \
        > /etc/nomad.d/server.hcl

systemctl enable nomad.service
systemctl daemon-reload
systemctl restart nomad.service
