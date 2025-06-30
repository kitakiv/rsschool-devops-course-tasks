#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y curl

curl  -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--token ${K3S_TOKEN}" sh -