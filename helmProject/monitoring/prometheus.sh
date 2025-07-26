#!/bin/bash

set -e


echo "📦 Installing Prometheus Helm chart..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "📦 Installing Prometheus Helm chart..."
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring-helm --create-namespace \
  -f monitoring.yaml
echo "✅ Prometheus Helm chart installed successfully!"


echo "Metrics server"
kubectl apply -f metrics.yaml

