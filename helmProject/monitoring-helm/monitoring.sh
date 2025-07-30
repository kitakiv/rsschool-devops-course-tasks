#!/bin/bash

# set -e

# echo "📦 Installing Prometheus Helm chart..."

# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo update

# echo "create secret for Grafana..."

# kubectl apply -f grafana-secret.yaml

# echo "📦 Installing Prometheus Helm chart..."

# helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
#  --namespace monitoring-helm \
#   --create-namespace \
#   -f values.yaml

# NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')
# NODE_PORT=$(kubectl get svc kube-prometheus-stack-grafana --namespace monitoring-helm -o jsonpath='{.spec.ports[0].nodePort}')

# echo "http://$NODE_IP:$NODE_PORT"

# # $ kubectl describe pod kube-prometheus-stack-grafana-554d6c9bc4-csq7j -n monitoring-helm


#!/bin/bash

set -e

echo "Installing Prometheus Helm chart..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create configmap prometheus-alert-rules \
  --from-file=alert-rules.yaml=alert-rules.yaml -n monitoring-helm

echo "Install Prometheus"

helm upgrade  --install prometheus prometheus-community/prometheus -f prometheus-values.yaml -n monitoring-helm --create-namespace

echo "Create secret for Grafana..."

kubectl apply -f grafana-secret.yaml

echo "Installing Grafana Helm Chart..."

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "Install Grafana"

helm upgrade  --install grafana grafana/grafana -f grafana-values.yaml -n monitoring-helm


