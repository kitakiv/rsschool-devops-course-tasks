kubectl create namespace monitoring

kubectl apply -f grafana-secret.yaml
helm install prometheus \
    --namespace monitoring \
    oci://REGISTRY_NAME/REPOSITORY_NAME/prometheus
helm install grafana \
    --values values.yaml \
    --namespace monitoring \
    oci://REGISTRY_NAME/REPOSITORY_NAME/grafana