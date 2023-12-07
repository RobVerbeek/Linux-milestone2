#!/bin/bash

# Function to wait for pod readiness to avoid errors while installing the ingress
wait_for_pods() {
    echo "Waiting for pods to be ready..."
    while [[ $(kubectl get pods --no-headers | awk '{print $3}' | grep -c -E '^Running|^Completed') -lt 5 ]]; do
        sleep 5
    done
    echo "All pods are ready."
}
sudo apt-get update
#install kubectl
sudo apt-get install -y ca-certificates curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
#install docker
sudo apt-get install -y docker.io
# Install KIND
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
# Create Kubernetes cluster with a name and attach the correct config file.
cd milestone2
kind create cluster --name milestone2-rv --config=kindconfig.yaml
# install ingress and apply the kubernetes configuration  
kubectl apply -f application.yaml
wait_for_pods
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
      