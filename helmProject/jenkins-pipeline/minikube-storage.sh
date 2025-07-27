#!/bin/bash

set -e

echo "🛠  Creating folder inside Minikube..."

# This runs the commands inside Minikube, then auto-exits
minikube ssh <<EOF
  sudo mkdir -p /home/storage
  sudo chmod 777 /home/storage
  echo "✅ Done setting up inside Minikube"
EOF