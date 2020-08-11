#!/usr/bin/env bash

set -e

apt-get update

apt-get install -y \
        curl wget awk tmux vim openssl unzip \
        dnsmasq unzip tree jq
