#!/bin/bash
#INSTALLING PRE REQUISITES ON EACH OF THE WORKER CLUSTERS
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


export KUBECONFIG=us-east1-eks-worker-kubeconfig.yaml

kubectl create ns monitoring

helm install prometheus kubeslice/prometheus -n monitoring

#REGESTRING WORKER CLUSTERS TO THE KUBESLICE CONTROLLER
export KUBECONFIG=miami-controller-kubeconfig.yaml

kubectl apply -f cluster-registration.yaml -n kubeslice-sandbox1



#INSTALLING KUBESLICE WORKER OPERATORS ON EACH WORKER CLUSTER
kubectl get secrets kubeslice-rbac-worker-mia-lke -o yaml -n kubeslice-sandbox1

kubectl get secrets kubeslice-rbac-worker-gru-lke -o yaml -n kubeslice-sandbox1

kubectl get secrets kubeslice-rbac-worker-us-east1-eks -o yaml -n kubeslice-sandbox1

read "waiting for worker-operator-mia.yaml, worker-operator-gru.yaml, and worker-operator-east.yaml to be updated.  hit enter key when ready"



export KUBECONFIG=miami-worker-kubeconfig.yaml

kubectl cluster-info 

read "waiting for worker-operator-mia.yaml to be updated. hit enter key when ready"


helm install kubeslice-worker kubeslice/kubeslice-worker -f worker-operator-mia.yaml -n kubeslice-system --create-namespace


export KUBECONFIG=sao-paulo-worker-kubeconfig.yaml

kubectl cluster-info 

read "waiting for worker-operator-gru.yaml to be updated.  hit enter key when ready"

helm install kubeslice-worker kubeslice/kubeslice-worker -f worker-operator-gru.yaml -n kubeslice-system --create-namespace



export KUBECONFIG=us-east1-eks-worker-kubeconfig.yaml

kubectl cluster-info 

read "waiting for worker-operator-east.yaml to be updated.  hit enter key when ready"

helm install kubeslice-worker kubeslice/kubeslice-worker -f worker-operator-east.yaml -n kubeslice-system --create-namespace
