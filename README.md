# Task Complete Notifier

[中文说明](README.zh-CN.md)

A tiny Windows PowerShell utility for sending "task completed" notifications to your phone, Apple Watch, generic webhooks, or WeCom group robots.

Supported providers:

- `pushover`: recommended for phone and Apple Watch alerts
- `pushcut`: for Pushcut webhook automations
- `webhook`: generic JSON webhook with `{ "title": "...", "message": "..." }`
- `wecom`: WeCom / 企业微信群机器人 webhook using markdown messages

## Easiest Setup: Install as a Codex Skill

Copy this into Codex:

```text
Install the Codex skill from https://github.com/zhangzaikunzzk/Codex-Task-Notifier/tree/main/skills/task-complete-notifier
```

After Codex installs it, restart Codex so the new skill is loaded. Then ask:

```text
Use $task-complete-notifier to set up task completion notifications.
```

Codex will guide you through Pushover, Pushcut, generic webhook, or WeCom setup.

## Does It Edit AGENTS.md Automatically?

No. Installing the skill only installs the skill files. It does not automatically edit global or project `AGENTS.md`.

If you want Codex to remember the notification rule for future tasks, ask:

```text
Use $task-complete-notifier to configure notifications and add the task-completion notification rule to my AGENTS.md.
```

Codex should ask whether to write the rule globally or only for the current project before editing any AGENTS file.

## Manual Setup Without Codex Skill

Pushover:

```powershell
.\setup.ps1 -Provider pushover
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Test notification"
```

Generic webhook:

```powershell
.\setup.ps1 -Provider webhook
.\notify-task-complete.ps1 -Provider webhook -Title "Task Notifier" -Message "Task completed"
```

WeCom group robot:

```powershell
.\setup.ps1 -Provider wecom
.\notify-task-complete.ps1 -Provider wecom -Title "Task Notifier" -Message "Task completed"
```

Dry run works for every provider and does not send a real request:

```powershell
.\notify-task-complete.ps1 -Provider wecom -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

## WeChat and WeCom Notes

WeCom group robots support incoming webhook URLs and are a good fit for this project. Regular personal WeChat groups do not provide the same official simple webhook flow, so this project does not treat personal WeChat bots as a default provider.

## Apple Watch Notes

Apple Watch receives the notification by mirroring Pushover notifications from your iPhone. If the phone receives the alert but the watch does not, check the iPhone Watch app notification settings for Pushover.

## Files

- `notify-task-complete.ps1`: sends the notification.
- `setup.ps1`: creates your local `.env` configuration.
- `.env.example`: shows the config format.
- `skills/task-complete-notifier/`: installable Codex skill package.

## Security

- Do not paste webhook URLs, Pushover keys, or Pushcut URLs into chat.
- `.env` stays on your machine and is ignored by Git.
- The scripts do not print your secrets.
