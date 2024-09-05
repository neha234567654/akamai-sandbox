#!/bin/bash
#terraform output -json worker4-kubeconfig | jq -r . | base64 -d > worker4-kubeconfig.yaml
#export KUBECONFIG=worker4-kubeconfig.yaml

for node in $(kubectl get nodes -o name); do 
	kubectl label $node kubeslice.io/node-type=gateway --overwrite 
done

kubectl apply -f metrics-components.yaml

kubectl create ns monitoring

helm install prometheus kubeslice/prometheus -n monitoring