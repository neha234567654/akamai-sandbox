terraform output -json controller4-kubeconfig | jq -r . | base64 -d > controller4-kubeconfig.yaml
export KUBECONFIG=controller4-kubeconfig.yaml

kubectl cluster-info

echo "update the controller.yaml file with the endpoint informaiton from the above output"
read blank-input


helm repo add kubeslice https://kubeslice.aveshalabs.io/repository/kubeslice-helm-ent-prod/

helm install kubeslice-controller kubeslice/kubeslice-controller -f controller.yaml --namespace kubeslice-controller --create-namespace

helm install kubeslice-ui kubeslice/kubeslice-ui -f kubeslice-ui.yaml -n kubeslice-controller

kubectl apply -f project.yaml -n kubeslice-controller

kubectl get svc -n kubeslice-controller | grep kubeslice-ui-proxy

kubectl get secrets -n kubeslice-sandbox1

kubectl describe secret kubeslice-rbac-rw-sandbox1 -n kubeslice-sandbox1
