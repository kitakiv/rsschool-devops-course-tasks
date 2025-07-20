#!/bin/bash

set -e

echo "📦 Installing Sonarqube Helm chart..."
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
echo "Create Sonarqube namespace..."
kubectl create namespace sonarqube
echo "Install Sonarqube..."
helm upgrade --install -n sonarqube --version '10.5.0' sonarqube sonarqube/sonarqube
kubectl patch svc sonarqube-sonarqube -p '{"spec":{"type":"NodePort"}}' -n sonarqube
