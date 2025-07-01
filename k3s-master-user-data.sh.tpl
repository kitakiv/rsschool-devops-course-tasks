 #!/bin/bash
set -euxo pipefail

echo "=== Setting hostname to ${hostname} ==="
hostnamectl set-hostname ${hostname}

apt-get update -y
apt-get install -y curl

echo "=== Installing K3s master node ==="
curl -sfL https://get.k3s.io | \
  INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" \
  K3S_TOKEN="${k3s_token}" sh -

echo "=== K3s install script finished ==="

echo "=== Waiting for K3s API server to become available... ==="
until KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl get node &>/dev/null; do
  echo "[INFO] K3s is not ready yet... sleeping for 5s"
  sleep 5
done

echo "K3s API server is now available!"

echo "=== Applying test pod ==="
KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml

echo "Test pod applied successfully!"