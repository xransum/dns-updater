# DNS Updater

## Overview

The `dns-updater` is a Python script designed to update DNS records on DreamHost dynamically. It retrieves the current public IP address of the machine it's running on and updates the specified DNS records accordingly. Additionally, it sends notifications to a Discord channel via webhook whenever an update occurs.

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/xransum/dns-updater.git
   ```

2. Navigate to the repository directory:

   ```bash
   cd dns-updater
   ```

3. Install the required dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Create a `.env` file in the root of the repository with the following variables:

   ```env
   DREAMHOST_API_TOKEN=
   DISCORD_WEBHOOK_ID=
   DISCORD_WEBHOOK_TOKEN=
   TARGET_RECORDS=
   ```

   For the `TARGET_RECORDS`, use a comma-separated list of the DNS records you want to update, each formatted as `domain.tld:type` (e.g., `example.com:A,sub.example.com:AAAA`).

   Example:

   ```env
   TARGET_RECORDS="example.com:A,sub.example.com:AAAA"
   ```

5. Execute the installation script:

   ```bash
   ./scripts/install.sh
   ```

   This script will:
   - Install the systemd service and timer files to `/etc/systemd/system/`.
   - Reload the systemd daemon.
   - Enable the timer.
   - Start the timer.

6. Verify the setup:

   - Check the status of the timer:

     ```bash
     sudo systemctl status dns-updater.timer
     ```

   - Alternatively, verify the timer and service logs:

     ```bash
     sudo systemctl list-timers | grep dns-updater
     sudo journalctl -u dns-updater.service
     ```
