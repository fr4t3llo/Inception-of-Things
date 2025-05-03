#!/bin/bash
set -xe
# INFO: RUNNING P1 SERVER CONFIG SCRIPT

# Set INSTALL_K3S_EXEC environment variable
echo "***INFO: Setting INSTALL_K3S_EXEC env...***"
if export INSTALL_K3S_EXEC="--node-external-ip=192.168.56.110 --bind-address=192.168.56.110 --flannel-iface=eth1"; then
  echo "***SUCCESS: INSTALL_K3S_EXEC env set successfully***"
else
  echo "***ERROR: Can't set INSTALL_K3S_EXEC env***"
  exit 1
fi

# Install k3s server
echo "***INFO: Installing k3s server...***"
if curl -sfL https://get.k3s.io | sh -; then
  echo "***SUCCESS: Successfully installed k3s server***"
else
  echo "***ERROR: Failed to install k3s server***"
  exit 1
fi

# Save server token
echo "INFO: Saving server token..."
if sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/token.txt; then
  echo "***SUCCESS: Server token saved***"
else
  echo "***ERROR: Failed to save server token***"
  exit 1
fi

echo "Waiting for k3s to be ready..."
sleep 10

if kubectl apply -f /vagrant/web-apps/app1/app1.yaml; then
  echo "app1 deployed"
else
   echo "Error: Failed deploy app1"
fi

if kubectl apply -f /vagrant/web-apps/app2/app2.yaml; then
  echo "app2 deployed"
else
   echo "Error: Failed deploy app2"
fi

if kubectl apply -f /vagrant/web-apps/app3/app3.yaml; then
  echo "app3 deployed"
else
   echo "Error: Failed deploy app3"
fi
 

echo "Waiting for deployments to be ready..."
sleep 10


if kubectl apply -f /vagrant/web-apps/main.yaml; then
  echo "all apps deployed"
else
   echo "Error: Failed deploy apps"
fi



