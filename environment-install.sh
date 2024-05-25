#!/bin/bash

echo "❓ Checking if snap is installed..."
if ! command -v snap; then
    echo "⬇ Installing snap..."
    sudo apt-get install snapd
    echo "✅ snap has been installed"
else
    echo "✅ Snap is already installed."
fi

echo "❓ Checking if Microk8s is installed..."
if ! snap list | grep -q microk8s; then
    echo "⬇ Installing Microk8s..."
    sudo snap install microk8s --classic
    echo "✅ Microk8s has been installed"
else
    echo "✅ Microk8s is already installed."
fi
echo "🔃 Loading lauch config to Microk8s..."
sudo snap set microk8s config="$(cat microk8s-launch-config.yaml)"

echo "👍 Done!"
