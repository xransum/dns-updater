#!/bin/bash
# Install script to install both dns-updater.service and dns-updater.timer
set -e

CURRENT_USER=$(whoami)
SERVICE_FILE="dns-updater.service"
TIMER_FILE="dns-updater.timer"
INSTALL_DIR="/etc/systemd/system"
SCRIPT_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_FILE="dns-updater.py"
SCRIPT_SOURCE_PATH="$SCRIPT_SOURCE_DIR/$SCRIPT_FILE"

# Create a temporary file for the modified service
TEMP_SERVICE_FILE=$(mktemp)

# Copy the original service file to the temporary file
cp "$SCRIPT_SOURCE_DIR/$SERVICE_FILE" "$TEMP_SERVICE_FILE"

# Modify the temporary service file
sed -i "s|ExecStart=.*|ExecStart=/usr/bin/python3 $SCRIPT_SOURCE_PATH|" "$TEMP_SERVICE_FILE"
sed -i "s|WorkingDirectory=.*|WorkingDirectory=$SCRIPT_SOURCE_DIR|" "$TEMP_SERVICE_FILE"
sed -i "s|User=.*|User=$CURRENT_USER|" "$TEMP_SERVICE_FILE"
# sed -i "s|Group=.*|Group=$(id -gn $CURRENT_USER)|" "$TEMP_SERVICE_FILE"
sed -i "s|Group=.*|Group=$CURRENT_USER|" "$TEMP_SERVICE_FILE"

# Install the modified service file
echo "Installing $SERVICE_FILE to $INSTALL_DIR"
sudo cp "$TEMP_SERVICE_FILE" "$INSTALL_DIR/$SERVICE_FILE"

# Remove the temporary file
rm "$TEMP_SERVICE_FILE"

# Copy the timer file as is
sudo cp "$SCRIPT_SOURCE_DIR/$TIMER_FILE" "$INSTALL_DIR/"

# Reload systemd daemon to recognize new service and timer
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling and starting $TIMER_FILE..."
sudo systemctl enable --now "$TIMER_FILE"

echo "Installation complete. You can check the status of the timer with:"
echo "  systemctl status $TIMER_FILE"

echo "And check the logs of the service with:"
echo "  journalctl -u $SERVICE_FILE -f"

# End of script
