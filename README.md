**English** | [فارسی](README.fa.md)

# SoftEtherBackupBot

A simple Python-based backup tool for [SoftEther VPN](https://www.softether.org/) servers.  
It fetches the current server config via SoftEther's JSON-RPC API, saves it locally, and optionally sends it to your Telegram bot for off-site backup.  
You can run it manually or schedule it with `cron`.

---

## Features

- Auto-fetch config from multiple SoftEther servers
- Save decoded `.config` files locally
- Send backups to a Telegram bot (optional)
- Easy setup with an install script
- Runs on schedule via `cron`

---

## Quick Install

Run the following command in your terminal:

```bash
wget -O se-install https://raw.githubusercontent.com/Pink210/SoftEtherBackupBot/master/install-SoftEtherBackupBot.bash && chmod +x se-install && ./se-install
```

## Editing Configuration
To change your server list, password, or Telegram settings, edit the config.py file:
```bash
sudo nano $HOME/SoftEtherBackupBot/config.py
```

## Changing the Backup Interval
To modify the backup schedule:
```bash
crontab -e
```
Then update the schedule line. For example, to run the backup every 3 hours:
```bash
0 */3 * * * /usr/bin/python3 $HOME/SoftEtherBackupBot/main.py >> $HOME/SoftEtherBackupBot/cron.log 2>&1
```
