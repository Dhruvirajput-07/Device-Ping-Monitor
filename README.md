
🖥️ DEVICE PING MONITOR – LAN MONITORING & EMAIL ALERTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📌 ABOUT THE PROJECT

Device Ping Monitor is a PowerShell-based LAN monitoring tool that continuously monitors devices using their IP addresses.

➜ Reads device details from a CSV file.
➜ Sends ping requests every 10 seconds.
➜ Detects devices that become unreachable or exceed the configured packet-loss threshold.
➜ Sends email alerts to the email address associated with each device.
➜ Sends recovery emails with reconnection time and total downtime.
➜ Starts automatically using Windows Task Scheduler.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ FEATURES

📡 ➜ Monitors multiple LAN devices.
📄 ➜ Reads device information from an Excel-created CSV file.
⏱️ ➜ Sends ping requests every 10 seconds.
⚠️ ➜ Detects device failures and packet loss.
📧 ➜ Sends email alerts when a device goes DOWN.
✅ ➜ Sends recovery notifications when a device comes UP.
🕒 ➜ Reports disconnection time, reconnection time, and total downtime.
👤 ➜ Sends notifications to the email address mapped to each device.
🔄 ➜ Runs automatically through Windows Task Scheduler.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 SETUP INSTRUCTIONS

1️⃣ CREATE THE DEVICE CSV FILE

➜ Open Microsoft Excel.
➜ Create the following columns:

   Sr No | Device Name | IP Address | Email Address

➜ Enter each device's details and its corresponding email address.
➜ Save the file as CSV (Comma delimited) (*.csv).

📄 Example:

   Sr No: 1
   Device Name: Office-PC-01
   IP Address: 192.168.1.10
   Email Address: pc01@example.com

   Sr No: 2
   Device Name: Office-PC-02
   IP Address: 192.168.1.11
   Email Address: pc02@example.com

ℹ️ Replace the example details with your actual device information.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

2️⃣ GENERATE A GMAIL APP PASSWORD

➜ Sign in to your Google Account.
➜ Open Google Account Security:
   https://myaccount.google.com/security

➜ Enable 2-Step Verification.
➜ Open Google App Passwords:
   https://myaccount.google.com/apppasswords

➜ Enter an app name, such as Device Ping Monitor.
➜ Click Create and copy the generated 16-character app password.
➜ Configure your Gmail address and app password in the PowerShell script.

🔐 SECURITY NOTE

Never share your app password or upload it to GitHub. Store your credentials securely.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3️⃣ RUN THE POWERSHELL SCRIPT

➜ Keep the CSV file and PowerShell script in the appropriate locations.
➜ Configure the CSV file path and Gmail settings in the script.
➜ Open PowerShell and navigate to the script folder.
➜ Run the following command:

   .\Device-Ping-Monitor.ps1

➜ Verify that devices are monitored every 10 seconds.
➜ Check that DOWN and recovery email notifications work correctly.

ℹ️ Replace the example filename with your actual .ps1 filename.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

4️⃣ CONFIGURE AUTOMATIC STARTUP

➜ Open Windows Task Scheduler.
➜ Select Create Task.
➜ Under Triggers, choose At startup or At log on.
➜ Under Actions, select Start a program.
➜ Set the program to powershell.exe.
➜ Add the PowerShell script path as an argument.
➜ Configure the correct working directory.
➜ Save the task and test it.

✅ Device Ping Monitor will start automatically according to the selected trigger.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📧 EMAIL NOTIFICATIONS

⚠️ DEVICE DOWN ALERT

When a device becomes unreachable, an email is sent to its configured email address.

➜ Device Name
➜ IP Address
➜ Event Date and Time
➜ Detected Packet Loss

📩 Example Subject:
ALERT: Device Down - Office-PC-01

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ DEVICE RECOVERY ALERT

When connectivity is restored, a recovery email is sent.

➜ Device Name
➜ IP Address
➜ Reconnection Date and Time
➜ Total Downtime Duration

📩 Example Subject:
RECOVERY: Device Up - Office-PC-01

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🛠️ TECHNOLOGIES USED

💻 PowerShell
📄 CSV File Handling
📧 Gmail SMTP
⚙️ Windows Task Scheduler

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚙️ REQUIREMENTS

➜ Windows PC with PowerShell.
➜ CSV file containing device information.
➜ Network access to monitored devices.
➜ Gmail SMTP configuration for email alerts.
➜ Windows Task Scheduler for automatic startup.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔒 IMPORTANT NOTES

➜ The monitoring PC must remain powered on and connected to the network.
➜ Devices must allow ping requests; firewalls may block ICMP traffic.
➜ Email notifications require internet access and valid SMTP settings.
➜ Device status detection depends on the packet-loss threshold configured in the script.
➜ Use this tool only on devices and networks you are authorized to monitor.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 USE CASES

🏢 Office LAN Monitoring
🖥️ PC and Server Monitoring
🖨️ Network Printer Monitoring
⏱️ Device Downtime Tracking
📧 Automatic Email Alerts
🔄 Device Recovery Notifications

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👨‍💻 AUTHOR

Your Name

🔗 GitHub:
https://github.com/YOUR-USERNAME

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 LICENSE

Add a LICENSE file to define how this project can be used, modified, and distributed.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
