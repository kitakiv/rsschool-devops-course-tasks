#!/bin/bash
  set -euxo pipefail

  apt-get update -y
  apt-get install -y curl

  curl  -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" K3S_TOKEN="${k3s_token}" sh -
  sleep 60
  kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml

  mkdir -p /home/ubuntu/.kube
  cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
  chown ubuntu:ubuntu /home/ubuntu/.kube/config
  chmod 600 /home/ubuntu/.kube/config


  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  mv kubectl /usr/local/bin/