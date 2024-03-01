#!/bin/bash

# Vérifier si sudo est installé, sinon l'installer
if ! command -v sudo &> /dev/null; then
    apt-get update
    apt-get install -y sudo
fi

# Vérifier si curl est installé, sinon l'installer
if ! command -v curl &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y curl
fi

# Mettre à jour le système
sudo apt-get update
sudo apt-get upgrade -y

# Installer les prérequis
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2

# Ajouter la clé GPG de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajouter le dépôt Docker à APT
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installer Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Ajouter l'utilisateur au groupe Docker
sudo usermod -aG docker $USER

# Installer Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Installation terminée. Veuillez vous déconnecter puis vous reconnecter pour que les modifications prennent effet."
