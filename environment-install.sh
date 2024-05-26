#!/bin/bash

echo "❓ Checking if snap is installed..."
if ! command -v snap; then
    echo "⬇ Installing snap..."
    apt-get install snapd
    echo "✅ snap has been installed"
else
    echo "✅ Snap is already installed."
fi

echo "❓ Checking if Microk8s is installed..."
if ! snap list | grep -q microk8s; then
    echo "⬇ Installing Microk8s..."
    snap install microk8s --classic
    echo "✅ Microk8s has been installed"
else
    echo "✅ Microk8s is already installed."
fi

echo "❓ Checking if Microk8s is on path..."
if ! command -v microk8s; then
    echo "🚨 microk8s is not on path."
    echo "🔃 Adding microk8s to path..."
    echo "🔃 Checking if your shell is zsh..."
    if [ -n "$ZSH_VERSION" ]; then
        echo "➕ Adding microk8s to .zshrc file"
        echo "export PATH=\$PATH:/snap/bin" >>~/.zshrc
        echo "✅ microk8s has been added to path."
    else
        echo "➕ Adding microk8s to .bashrc file"
        echo "export PATH=\$PATH:/snap/bin" >>~/.bashrc
        echo "✅ microk8s has been added to path."
    fi
fi
echo "🔃 Loading lauch config to Microk8s..."
snap set microk8s config="$(cat microk8s-launch-config.yaml)"

echo "👍 Done!"
