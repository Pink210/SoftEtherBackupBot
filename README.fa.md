**فارسی** | [English](README.md)

# SoftEtherBackupBot

ابزاری ساده و مبتنی بر پایتون برای گرفتن بکاپ از سرورهای [SoftEther VPN](https://www.softether.org/).  
این اسکریپت کانفیگ فعلی سرورها را از طریق API دریافت کرده، آن را به‌صورت محلی ذخیره می‌کند و در صورت فعال بودن، فایل بکاپ را به ربات تلگرام شما ارسال می‌نماید.  
می‌توانید آن را به‌صورت دستی یا از طریق زمان‌بندی `cron` اجرا کنید.

---

## ویژگی‌ها

- دریافت خودکار کانفیگ از چند سرور SoftEther
- ذخیره فایل‌های `.config` به‌صورت محلی
- ارسال بکاپ به ربات تلگرام (اختیاری)
- نصب آسان با اسکریپت آماده
- اجرای زمان‌بندی‌شده از طریق `cron`

---

## نصب سریع

دستور زیر را در ترمینال لینوکس اجرا کنید:

```bash
wget -O se-install https://raw.githubusercontent.com/Pink210/SoftEtherBackupBot/master/install-SoftEtherBackupBot.bash && chmod +x se-install && ./se-install
```

## ویرایش تنظیمات
برای تغییر لیست سرورها، رمز عبور یا اطلاعات ربات تلگرام، فایل config.py را ویرایش کنید:
```bash
sudo nano $HOME/SoftEtherBackupBot/config.py
```
نمونه:
```bash
lis_servers = ["server1.example.com", "server2.example.com"]
ser_password = "your_password"
telegram_bot = True
telegram_bot_token = "your_telegram_bot_token"
telegram_chat_id = "your_telegram_chat_id"
```

## تغییر بازه زمانی بکاپ
برای تغییر زمان اجرای بکاپ:
```bash
crontab -e
```
و سپس خط زمان‌بندی را تغییر دهید. به عنوان مثال برای اجرای هر ۳ ساعت:
```bash
0 */3 * * * /usr/bin/python3 $HOME/SoftEtherBackupBot/main.py >> $HOME/SoftEtherBackupBot/cron.log 2>&1
```
