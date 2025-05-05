#!/bin/bash
set -ex

# Create a new namespace for the deployment
kubectl create namespace dev

# Apply the Argo CD application definition (assuming you have the updated `argocd.yaml` in the specified location)
kubectl apply -f ../confs/argocd.yaml -n argocd

# Verify sync status
echo "Waiting for Argo CD to sync..."
until kubectl get application playground-app -n argocd -o jsonpath='{.status.sync.status}' | grep -q "Synced"; do
  sleep 5
done

echo "Argo CD application synced successfully!"
