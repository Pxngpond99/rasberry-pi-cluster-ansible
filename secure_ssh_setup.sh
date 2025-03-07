#!/bin/bash

# Variables
USERNAME="pi"                  # Replace with your actual username
PASSWORD="123456"                  # Password for all remote nodes
KEY_PATH="$HOME/.ssh/pi"       # SSH key path for ed25519 key
INVENTORY_FILE="hosts"              # Inventory file containing the node list

# Ensure sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "sshpass is not installed. Installing it now..."
    sudo apt-get update && sudo apt-get install -y sshpass
fi

# Step 1: Generate SSH key if it doesn't already exist
if [ ! -f "$KEY_PATH" ]; then
    echo "SSH key not found at $KEY_PATH. Generating a new SSH key..."
    ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" # Generate without passphrase
    echo "SSH key generated at $KEY_PATH."
else
    echo "SSH key already exists at $KEY_PATH."
fi

# Step 2: Copy the public key to each target node
echo "Copying SSH public key to remote hosts..."
while read -r line; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^\[[a-zA-Z0-9_-]+\] ]]; then
        continue
    fi

    # Extract the IP address from the ansible_ssh_host field
    IP=$(echo "$line" | grep -oP 'ansible_ssh_host=\K[\d.]+')
    if [ -z "$IP" ]; then
        echo "No IP found for line: $line"
        continue
    fi

    # Define the target as user@IP
    TARGET="$USERNAME@$IP"
    echo "Copying SSH key to $TARGET..."

    # Copy the public SSH key using sshpass
    sshpass -p "$PASSWORD" ssh-copy-id -i "${KEY_PATH}.pub" -o StrictHostKeyChecking=no "$TARGET"
done < "$INVENTORY_FILE"