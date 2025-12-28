# dns-updater

## Overview

The `dns-updater` is a Python script designed to update DNS records on DreamHost
dynamically. It retrieves the current public IP address of the machine it's
running on and updates the specified DNS records accordingly. Additionally,
it sends notifications to a Discord channel via webhook whenever an update
occurs.

## Setup

Clone the repository:

```bash
git clone blah
```

Install the required dependencies:

```bash
pip install -r requirements.txt
```

Edit the appropriate destination path to the `dns_updater.py` script in `dns-updater.service`.

Copy the service file to the systemd directory:

```bash
sudo cp dns-updater.service /etc/systemd/system/
```

Copy the timer file to the systemd directory:

```bash
sudo cp dns-updater.timer /etc/systemd/system/
```

Reload, enable, and start the timer:

```bash
sudo systemctl daemon-reload
sudo systemctl enable dns-updater.timer
sudo systemctl start dns-updater.timer
```

Check the status of the timer:

```bash
sudo systemctl status dns-updater.timer
```

Alternatively, you can verify the timer and service logs with:

```bash
sudo systemctl list-timers | grep dns-updater
sudo journalctl -u dns-updater.service
```

## Configuration

Within the root of the repository, you need to create a file `.env` with the following variables:

```env
DREAMHOST_API_TOKEN
DISCORD_WEBHOOK_ID
DISCORD_WEBHOOK_TOKEN
TARGET_RECORDS
```

For the `TARGET_RECORDS`, use a comma-separated list of the DNS records you want to update,
each of the records formatted as `domain.tld:type` (e.g., `example.com:A,sub.example.com:AAAA`).

```env
TARGET_RECORDS="example.com:A,sub.example.com:AAAA"
```
