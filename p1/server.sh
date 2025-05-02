#!/bin/bash

# Define colors
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${GREEN}Updating package lists...${RESET}"
sudo apt update -y

echo -e "${GREEN}Installing snapd (Snap)...${RESET}"
sudo apt install -y snapd

echo -e "${GREEN}Installing kubectl via Snap...${RESET}"
sudo snap install kubectl --classic

# SSH key setup
SSH_KEY="/home/vagrant/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
  echo -e "${GREEN}Generating SSH keys...${RESET}"
  sudo -u vagrant ssh-keygen -t rsa -N "" -f "$SSH_KEY"
else
  echo -e "${GREEN}SSH key already exists.${RESET}"
fi

echo -e "${GREEN}Configuring authorized_keys...${RESET}"
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh

echo -e "${GREEN}Provisioning complete!${RESET}"
