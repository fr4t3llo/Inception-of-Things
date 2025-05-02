#!/bin/bash

# set -xe

# INFO: RUNNING P1 WORKER CONFIG SCRIPT

# Set INSTALL_K3S_EXEC environment variable
echo "***INFO: Setting INSTALL_K3S_EXEC env...***"
if export INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 -t $(cat /vagrant/token.txt) --node-ip=192.168.56.111 --flannel-iface=eth1"; then
  echo "***SUCCESS: INSTALL_K3S_EXEC env set successfully***"
else
  echo "***ERROR: Can't set INSTALL_K3S_EXEC env***"
  exit 1
fi

# Install k3s worker
echo "***INFO: Installing k3s worker...***"
if curl -sfL https://get.k3s.io | sh -; then
  echo "***SUCCESS: Successfully installed k3s worker***"
else
  echo "***ERROR: Failed to install k3s worker***"
  exit 1
fi

# Remove the server token
echo "***INFO: Removing server token...***"
rm /vagrant/token.txt
