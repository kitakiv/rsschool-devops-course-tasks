#!/bin/bash

set -e

echo "📦 Installing Prometheus Helm chart..."

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install prometheus oci://registry-1.docker.io/bitnamicharts/prometheus \
     --namespace monitoring-helm \
     --create-namespace \
     -f prometheus-values.yaml


echo "Create secret for Grafana..."

kubectl apply -f grafana-secret.yaml

echo "📦 Installing Grafana Helm chart..."

helm upgrade --install grafana oci://registry-1.docker.io/bitnamicharts/grafana \
    --namespace monitoring-helm \
    -f grafana-values.yaml

echo "📦 Installing Node Exporter Helm chart..."

helm install kube-state-metrics oci://registry-1.docker.io/bitnamicharts/kube-state-metrics -n monitoring-helm

kubectl get svc -n monitoring-helm

echo " password for grafana"
kubectl get secret --namespace monitoring-helm grafana-admin-secret -o jsonpath="{.data.password}" | base64 --decode

echo " username for grafana"
kubectl get secret --namespace monitoring-helm grafana-admin-secret -o jsonpath="{.data.user}" | base64 --decode

echo "node_port and node_ip for prometheus"

NODE_PORT=$(kubectl get svc prometheus-server --namespace monitoring-helm -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes --namespace monitoring-helm -o jsonpath='{.items[0].status.addresses[0].address}')

echo "http://$NODE_IP:$NODE_PORT"

echo "node_port and node_ip for grafana"

NODE_PORT_GRAFANA=$(kubectl get svc grafana --namespace monitoring-helm -o jsonpath='{.spec.ports[0].nodePort}')

echo "http://$NODE_IP:$NODE_PORT_GRAFANA"
