echo "Username from secret"

kubectl get secret monitoring-grafana -n monitoring-helm -o jsonpath="{.data.admin-user}" | base64 --decode

echo "Password from secret"

kubectl get secret monitoring-grafana -n monitoring-helm -o jsonpath="{.data.admin-password}" | base64 --decode