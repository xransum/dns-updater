# dns-updater

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
