# Task Complete Notifier

A tiny Windows PowerShell script that sends a "task completed" notification to your phone or Apple Watch.

It works with:

- Pushover, recommended
- Pushcut, optional

## Why this exists

Sometimes a local script, AI coding tool, backup job, build, or long-running task finishes while you are away from the computer. This project gives you one simple command you can run at the end of that task to receive a push notification.

Your private keys stay on your own computer in a local `.env` file.

## What you need

- A Windows computer
- PowerShell, already included with Windows
- An iPhone or Android phone
- Optional: Apple Watch, if you want the phone notification mirrored to your watch

## Step-by-step setup with Pushover

### 1. Install Pushover on your phone

1. Open the App Store or Google Play.
2. Search for `Pushover`.
3. Install the app.
4. Open Pushover and create or log into your account.
5. Send one test notification inside Pushover if the app asks you to verify your device.

If you use Apple Watch, make sure your watch mirrors Pushover notifications from your iPhone:

1. Open the iPhone `Watch` app.
2. Open `Notifications`.
3. Find `Pushover`.
4. Turn notification mirroring on.

### 2. Get your Pushover User Key

1. Open <https://pushover.net/> in your browser.
2. Log in.
3. On the main page, find `Your User Key`.
4. Copy that value. You will paste it later.

### 3. Create a Pushover application token

1. On the same Pushover page, scroll down to `Your Applications`.
2. Click `Create an Application/API Token`.
3. Fill in the form:
   - Name: `Task Complete Notifier`
   - Type: `Application`
   - Description: `Local task completion notifications`
   - URL: leave blank
4. Click the button to create the application.
5. Copy the new application's `API Token/Key`. You will paste it later.

You now have two values:

- `PUSHOVER_APP_TOKEN`: from the application you created
- `PUSHOVER_USER_KEY`: from your Pushover account page

Do not share these values publicly.

### 4. Download this project

If you are viewing this project on GitHub:

1. Click the green `Code` button.
2. Click `Download ZIP`.
3. Unzip the downloaded file.
4. Open the unzipped folder.

### 5. Open PowerShell in the project folder

In the project folder:

1. Hold `Shift`.
2. Right-click an empty area in the folder.
3. Click `Open PowerShell window here` or `Open in Terminal`.

You should see a PowerShell window.

### 6. Create your local config file

Copy this command, paste it into PowerShell, then press Enter:

```powershell
.\setup.ps1
```

PowerShell will ask for:

1. `PUSHOVER_APP_TOKEN`
2. `PUSHOVER_USER_KEY`

Paste each value and press Enter.

This creates a file named `.env` in the project folder. That file stores your private keys locally.

### 7. Test without sending a real notification

Copy and paste:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

You should see:

```text
Dry run: would send Pushover notification.
Title: Task Notifier
Message: Dry run OK
```

### 8. Send a real test notification

Copy and paste:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Test notification"
```

You should receive a notification on your phone. If your Apple Watch mirrors phone notifications, it should appear on your watch too.

## Daily use

When any task finishes, run:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Task completed"
```

You can change the message:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Backup" -Message "Photos backup finished"
```

## Pushcut alternative

Pushover is easier for most people. Use Pushcut only if you already know how Pushcut webhooks work.

To use Pushcut:

1. Create a Pushcut webhook on your iPhone.
2. Open PowerShell in this project folder.
3. Run:

```powershell
.\setup.ps1 -Provider pushcut
```

4. Paste your Pushcut webhook URL.
5. Test it:

```powershell
.\notify-task-complete.ps1 -Provider pushcut -Title "Task Notifier" -Message "Task completed"
```

## Troubleshooting

### PowerShell says scripts are disabled

Run this command in the same PowerShell window:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then run the setup or notification command again.

This only changes the current PowerShell window.

### Missing `PUSHOVER_APP_TOKEN`

Run:

```powershell
.\setup.ps1
```

Make sure you paste the application `API Token/Key`, not only your account user key.

### Missing `PUSHOVER_USER_KEY`

Run:

```powershell
.\setup.ps1
```

Make sure you paste the `Your User Key` value from your Pushover account page.

### I do not see the notification on Apple Watch

Check that the notification arrives on your phone first. Then check:

1. iPhone `Watch` app
2. `Notifications`
3. `Pushover`
4. Notification mirroring is turned on

## Project files

- `notify-task-complete.ps1`: sends the notification.
- `setup.ps1`: creates your private local `.env` configuration.
- `.env.example`: shows the config format.
- `.gitignore`: keeps local secrets and generated folders out of Git.

## Security notes

- Your Pushover keys stay in `.env` on your machine.
- `.env` is ignored by Git.
- The script does not print your token or user key.
- If you accidentally expose a Pushover user key or token, rotate it in Pushover.
