#!/bin/bash
# Install script to install both dns-updater.service and dns-updater.timer
set -e

CURRENT_USER=$(whoami)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYSTEMD_DIR="$REPO_ROOT/systemd"
SERVICE_FILE="$SYSTEMD_DIR/dns-updater.service"
TIMER_FILE="$SYSTEMD_DIR/dns-updater.timer"
INSTALL_DIR="/etc/systemd/system"
SCRIPT_FILE="$REPO_ROOT/dns-updater.py"

# Create a temporary file for the modified service
TEMP_SERVICE_FILE=$(mktemp)

# Copy the original service file to the temporary file
cp "$SERVICE_FILE" "$TEMP_SERVICE_FILE"

# Modify the temporary service file
sed -i "s|ExecStart=.*|ExecStart=/usr/bin/python3 $SCRIPT_FILE|" "$TEMP_SERVICE_FILE"
sed -i "s|WorkingDirectory=.*|WorkingDirectory=$REPO_ROOT|" "$TEMP_SERVICE_FILE"
sed -i "s|User=.*|User=$CURRENT_USER|" "$TEMP_SERVICE_FILE"
sed -i "s|Group=.*|Group=$CURRENT_USER|" "$TEMP_SERVICE_FILE"

# Install the modified service file
echo "Installing $(basename "$SERVICE_FILE") to $INSTALL_DIR"
sudo cp "$TEMP_SERVICE_FILE" "$INSTALL_DIR/$(basename "$SERVICE_FILE")"

# Remove the temporary file
rm "$TEMP_SERVICE_FILE"

# Install the timer file
echo "Installing $(basename "$TIMER_FILE") to $INSTALL_DIR"

# Copy the timer file as is
sudo cp "$TIMER_FILE" "$INSTALL_DIR/$(basename "$TIMER_FILE")"

# Reload systemd daemon to recognize new service and timer
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling and starting $(basename "$TIMER_FILE")..."
sudo systemctl enable --now "$(basename "$TIMER_FILE")"

echo "Installation complete. You can check the status of the timer with:"
echo "  systemctl status $(basename "$TIMER_FILE")"

echo "And check the logs of the service with:"
echo "  journalctl -u $(basename "$SERVICE_FILE") -f"

# End of script
