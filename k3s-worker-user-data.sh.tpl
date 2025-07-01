#!/bin/bash
set -euxo pipefail

echo "=== Setting hostname to ${hostname} ==="
hostnamectl set-hostname ${hostname}

echo "=== Installing K3s agent to join master at ${k3s_url} ==="
curl -sfL https://get.k3s.io | \
  K3S_URL="https://${k3s_url}:6443" \
  K3S_TOKEN="${k3s_token}" sh -

echo "=== K3s agent install script finished ==="

echo "=== Waiting to connect to K3s master... ==="
until systemctl is-active --quiet k3s-agent; do
  echo "[INFO] Waiting for k3s-agent service to become active..."
  sleep 5
done

echo "K3s agent is now active and connected to the cluster!"