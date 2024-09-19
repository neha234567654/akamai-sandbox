terraform init
terraform plan
terraform apply

terraform output -json miami-controller-kubeconfig | jq -r . | base64 -d > miami-controller-kubeconfig.yaml
terraform output -json miami-worker-kubeconfig | jq -r . | base64 -d > miami-worker-kubeconfig.yaml
terraform output -json sao-paulo-worker-kubeconfig | jq -r . | base64 -d > sao-paulo-worker-kubeconfig.yaml

export KUBECONFIG=miami-controller-kubeconfig.yaml

kubectl cluster-info

echo "update the controller.yaml file with the endpoint informaiton from the above output"
read blank-input


helm repo add kubeslice https://kubeslice.aveshalabs.io/repository/kubeslice-helm-ent-prod/

helm repo update

helm search repo kubeslice

helm install kubeslice-controller kubeslice/kubeslice-controller -f controller.yaml --namespace kubeslice-controller --create-namespace

helm install kubeslice-ui kubeslice/kubeslice-ui -f kubeslice-ui.yaml -n kubeslice-controller

sleep 60

kubectl apply -f project.yaml -n kubeslice-controller

sleep 30

kubectl get svc -n kubeslice-controller | grep kubeslice-ui-proxy | awk '{print $4}' > ui-creds.txt

kubectl describe secret kubeslice-rbac-rw-sandbox1 -n kubeslice-sandbox1 >> ui-creds.txt

cat ui-creds.txt