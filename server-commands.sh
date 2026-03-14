#!/bin/bash
# Hytale MMO Server - Quick Reference Commands
# These are copy-paste commands for server administration, NOT a runnable script.

PVC_PATH="/var/lib/rancher/k3s/storage/pvc-2a0b4ba5-ac88-4e47-a9b9-6f8278d40263_hytale_hytale-server"

# ============================================
# Pod Management
# ============================================

# Get current pod name
sudo k3s kubectl get pods -n hytale | grep hytale-server

# Find the pod name and namespace
sudo k3s kubectl get pods -A | grep hytale

# Restart the server
sudo k3s kubectl rollout restart deployment/hytale-server -n hytale

# Scale down / up (hard restart)
sudo k3s kubectl scale deployment/hytale-server -n hytale --replicas=0
sudo k3s kubectl scale deployment/hytale-server -n hytale --replicas=1

# Check logs after restart
POD_NAME=$(sudo k3s kubectl get pod -n hytale -l app.kubernetes.io/name=hytale -o jsonpath='{.items[0].metadata.name}')
sudo k3s kubectl logs -n hytale "$POD_NAME" --follow

# ============================================
# Mod Sync (local ~/hytale/Mods → PVC)
# ============================================

# Check what's currently in the PVC mods folder
sudo ls "$PVC_PATH/mods"

# Sync mods: remove old, copy new, restart
LOCAL_PATH="$HOME/hytale/Mods"

# Remove files/folders in PVC that aren't in local folder
for remote_file in $(sudo ls "$PVC_PATH/mods"); do
    if [ ! -e "$LOCAL_PATH/$remote_file" ]; then
        echo "Removing $remote_file..."
        sudo rm -rf "$PVC_PATH/mods/$remote_file"
    fi
done

# Copy all local files to PVC (overwrites existing)
for file in "$LOCAL_PATH"/*; do
    filename=$(basename "$file")
    echo "Copying $filename..."
    sudo cp "$file" "$PVC_PATH/mods/$filename"
done

# Restart
echo "Restarting server..."
sudo k3s kubectl rollout restart deployment/hytale-server -n hytale
echo "Done!"

# ============================================
# Config Deploy (local ~/hytale/configs → PVC)
# ============================================

# Copy configs to PVC mods folder
PVC_PATH="/var/lib/rancher/k3s/storage/pvc-2a0b4ba5-ac88-4e47-a9b9-6f8278d40263_hytale_hytale-server"
sudo cp -r ~/hytale/configs/* "$PVC_PATH/mods/"

# Copy permissions.json to server root
sudo cp ~/hytale/configs/permissions.json "$PVC_PATH/permissions.json"

# ============================================
# Backups
# ============================================

# Backup world
POD_NAME=$(kubectl get pod -n hytale -l app.kubernetes.io/name=hytale -o jsonpath='{.items[0].metadata.name}')
kubectl cp hytale/$POD_NAME:/server/universe ~/hytale-backups/universe-backup-$(date +%Y%m%d-%H%M%S)

# Restore (replace the date with your backup)
POD_NAME=$(kubectl get pod -n hytale -l app.kubernetes.io/name=hytale -o jsonpath='{.items[0].metadata.name}')
kubectl cp ~/hytale-backups/universe-backup-20260130-141600 hytale/$POD_NAME:/server/universe
