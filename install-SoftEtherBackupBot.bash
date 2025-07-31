#!/bin/bash

set -e

INSTALL_DIR="$HOME/SoftEtherBackupBot"
REPO_URL="https://github.com/Pink210/SoftEtherBackupBot"
RAW_URL="https://raw.githubusercontent.com/Pink210/SoftEtherBackupBot/master"
SERVICE_NAME="softether_backup_bot"

echo "🟢 Installing SoftEtherBackupBot..."

# Step 1: Make directory and download files
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "📥 Downloading project files..."
wget -q "$RAW_URL/main.py"
wget -q "$RAW_URL/config.py"

# Step 2: Gather user input
read -p "🔹 Enter server addresses (comma-separated): " server_input
read -p "🔹 Enter server password: " server_password
read -p "🔹 Do you want to enable Telegram bot? (y/n): " telegram_answer

telegram_bot="False"
telegram_token=""
telegram_chat_id=""

if [[ "$telegram_answer" == "y" || "$telegram_answer" == "Y" ]]; then
    telegram_bot="True"
    read -p "🔹 Enter your Telegram bot token: " telegram_token
    read -p "🔹 Enter your Telegram chat ID: " telegram_chat_id
fi

read -p "🔹 Enter backup interval in HOURS (e.g., 1 or 6): " backup_interval

# Step 3: Write updated config.py
echo "🛠️ Writing config.py..."
cat > config.py <<EOF
lis_servers = [$(echo "$server_input" | sed 's/,/","/g' | sed 's/^/"/' | sed 's/$/"/')]
ser_password = "$server_password"
telegram_bot = $telegram_bot
telegram_bot_token = "$telegram_token"
telegram_chat_id = "$telegram_chat_id"
EOF

# Step 4: Create cronjob
echo "🕐 Creating cronjob..."
(crontab -l 2>/dev/null; echo "0 */$backup_interval * * * /usr/bin/python3 $INSTALL_DIR/main.py >> $INSTALL_DIR/cron.log 2>&1") | crontab -

# Step 5: Create systemd service
echo "⚙️ Creating systemd service..."
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=SoftEther Backup Bot
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 $INSTALL_DIR/main.py
WorkingDirectory=$INSTALL_DIR
StandardOutput=append:$INSTALL_DIR/systemd.log
StandardError=append:$INSTALL_DIR/systemd_error.log
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo "✅ Installation complete. Backup will run every $backup_interval hour(s)."
