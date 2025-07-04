 #!/bin/bash
  set -euxo pipefail

  apt-get update -y
  apt-get install -y curl
  sleep 60
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" K3S_URL="https://${k3s_master_ip}:6443" K3S_TOKEN="${k3s_token}" sh -