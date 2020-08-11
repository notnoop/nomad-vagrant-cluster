#!/usr/bin/env bash

set -e

product="$1"
version="$2"

echo "Dowloading ${product} v${version}"

tmp="/tmp/download-${product}-$(date +%s)"
curl -SL --fail -o "${tmp}" https://releases.hashicorp.com/${product}/${version}/${product}_${version}_linux_amd64.zip

unzip ${tmp}
rm -rf ${tmp}
