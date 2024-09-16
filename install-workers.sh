#!/bin/bash

export KUBECONFIG=miami-worker-kubeconfig.yaml

for node in $(kubectl get nodes -o name); do 
	kubectl label $node kubeslice.io/node-type=gateway --overwrite 
done

kubectl create ns monitoring

helm install prometheus kubeslice/prometheus -n monitoring


export KUBECONFIG=sao-paulo-worker-kubeconfig.yaml

for node in $(kubectl get nodes -o name); do 
	kubectl label $node kubeslice.io/node-type=gateway --overwrite 
done

kubectl create ns monitoring

helm install prometheus kubeslice/prometheus -n monitoring


export KUBECONFIG=miami-controller-kubeconfig.yaml

kubectl apply -f cluster-registration.yaml -n kubeslice-sandbox1




kubectl get secrets kubeslice-rbac-worker-mia-lke -o yaml -n kubeslice-sandbox1

kubectl get secrets kubeslice-rbac-worker-gru-lke -o yaml -n kubeslice-sandbox1

read "waiting for worker-operator-mia.yaml and worker-operator-mia.yaml to be updated.  hit enter key when ready"



export KUBECONFIG=miami-worker-kubeconfig.yaml

kubectl cluster-info 

read "waiting for worker-operator-mia.yaml to be updated. hit enter key when ready"


helm install kubeslice-worker kubeslice/kubeslice-worker -f worker-operator-mia.yaml -n kubeslice-system --create-namespace


export KUBECONFIG=sao-paulo-worker-kubeconfig.yaml

kubectl cluster-info 

read "waiting for worker-operator-gru.yaml to be updated.  hit enter key when ready"

helm install kubeslice-worker kubeslice/kubeslice-worker -f worker-operator-gru.yaml -n kubeslice-system --create-namespace
