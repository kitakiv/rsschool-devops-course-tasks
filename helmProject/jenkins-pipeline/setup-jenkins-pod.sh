#!/bin/bash

set -e

echo "Create Jenkins namespace..."

kubectl create namespace jenkins-helm

echo "Create a storage claim..."

kubectl apply -f pv-storage.yml
kubectl apply -f pvc-storage.yml

echo "📦 Installing Jenkins Helm chart..."
helm repo add jenkinsci https://charts.jenkins.io
helm repo update

echo "📦 Installing Jenkins Helm chart..."
helm install jenkins jenkinsci/jenkins -n jenkins-helm -f jenkins-values.yaml