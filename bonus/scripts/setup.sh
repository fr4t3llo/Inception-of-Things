#!/bin/bash
set -ex

# Install dependencies
sudo apt update && sudo apt install -y && sudo apt install -y docker.io

# Configure Docker
sudo usermod -aG docker $USER
newgrp docker <<EONG

# Install K3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/

# start docker
sudo systemctl start docker

sleep 5

# Create cluster
k3d cluster create gitlab-cluster 

# Create namespace
kubectl create namespace gitlab


# waiting
sleep 20

kubectl apply -f ../confs/deployment.yaml
kubectl apply -f ../confs/service.yaml

# Wait for GitLab
echo -e "\nWaiting for GitLab pods to start..."
for i in {1..100}; do
  ready_pods=$(kubectl get pods -n gitlab --field-selector=status.phase=Running --no-headers | wc -l)
  if [[ "$ready_pods" -ge 2 ]]; then
    echo "GitLab is ready!"
    break
  fi
  sleep 15
done

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'


sleep 10
# kubectl port-forward --address 0.0.0.0 svc/service-gitlab -n gitlab 8081:80

# kubectl port-forward -n argocd svc/argocd-server -n argocd 8080:443 --address 0.0.0.0

nohup kubectl port-forward --address 0.0.0.0 svc/service-gitlab -n gitlab 8081:80 & 
nohup kubectl port-forward -n argocd svc/argocd-server -n argocd 8080:443 --address 0.0.0.0 &


echo "allllll gooooooooood ;)"
#
EONG


# to enter in container to get password 
# kubectl exec -it gitlab-deployment-bf4ffc6bf-tf7gp -n gitlab -- /bin/bash
# cat /etc/gitlab/initial_root_password
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
#  git clone http://167.172.153.84:8081/root/skasmi.git  skasmi2 
























# #!/bin/bash
# set -ex

# # Install dependencies
# sudo apt update && sudo apt install -y curl git docker.io

# # Configure Docker
# sudo usermod -aG docker $USER
# newgrp docker <<EONG

# # Install K3d
# curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# # Install kubectl
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/

# # Create cluster
# k3d cluster create gitlab-cluster

# # Create namespace
# kubectl create namespace gitlab || true

# # Install Helm
# if ! command -v helm &> /dev/null; then
#   curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#   chmod 700 get_helm.sh
#   ./get_helm.sh
# fi

# # Add GitLab chart repo
# helm repo add gitlab https://charts.gitlab.io/
# helm repo update

# # Install GitLab via Helm with the updated values.yaml
# helm install gitlab gitlab/gitlab -n gitlab -f ../confs/gitlab-values.yaml  # Ensure you specify the correct path to values.yaml

# # Wait for GitLab to be ready
# echo -e "\nWaiting for GitLab pods to start..."
# for i in {1..100}; do
#   ready_pods=$(kubectl get pods -n gitlab --field-selector=status.phase=Running --no-headers | wc -l)
#   if [[ "$ready_pods" -ge 2 ]]; then
#     echo "GitLab is ready!"
#     break
#   fi
#   sleep 15
# done

# # Display access info
# echo "Visit http://167.172.153.84.nip.io:30010 (or http://gitlab.167.172.153.84.nip.io:30010 if DNS is configured)"
# echo -n "Root password: "
# kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}' | base64 --decode || echo "Not available yet"

# EONG
