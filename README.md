# SoftEtherBackupBot
A Python-based automatic backup tool for SoftEther VPN server configurations. This script periodically fetches base64-encoded config files via SoftEther’s JSON-RPC API, decodes them, stores them locally, and optionally sends them to a Telegram bot. Ideal for hourly/daily cron jobs to maintain off-site config backups.
