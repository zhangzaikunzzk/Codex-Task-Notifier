<p align="center">
  <h1 align="center">Task Complete Notifier</h1>
  <p align="center">Send a completion alert when Codex, a script, a build, or any long-running task finishes.</p>
</p>

<p align="center">
  <a href="README.zh-CN.md">中文说明</a>
  ·
  <a href="skills/task-complete-notifier">Codex Skill</a>
  ·
  <a href="#manual-setup">Manual setup</a>
</p>

<p align="center">
  <img alt="PowerShell" src="https://img.shields.io/badge/PowerShell-5%2B-4479A1">
  <img alt="Codex Skill" src="https://img.shields.io/badge/Codex-Skill-111827">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green">
  <img alt="Secrets" src="https://img.shields.io/badge/secrets-local_only-orange">
</p>

---

## What it does

Task Complete Notifier is a small Windows PowerShell utility for sending task-completion alerts to your phone, Apple Watch, team chat, or any webhook endpoint.

It is designed for cases where you do not want to keep watching the terminal: Codex work, test suites, builds, backups, local scripts, and other slow jobs.

## Supported providers

| Provider | Best for | Command value |
| --- | --- | --- |
| Pushover | Phone and Apple Watch alerts | `pushover` |
| Pushcut | iOS automation webhooks | `pushcut` |
| Generic webhook | Any JSON endpoint | `webhook` |
| WeCom group robot | 企业微信群机器人 | `wecom` |

The generic webhook sends:

```json
{ "title": "Task Notifier", "message": "Task completed" }
```

The WeCom provider sends a markdown message to a WeCom group robot webhook.

## Fastest path: install as a Codex skill

Copy this into Codex:

```text
Install the Codex skill from https://github.com/zhangzaikunzzk/Codex-Task-Notifier/tree/main/skills/task-complete-notifier
```

Restart Codex after installation, then ask:

```text
Use $task-complete-notifier to set up task completion notifications.
```

Codex will walk through the local setup for Pushover, Pushcut, generic webhook, or WeCom.

## Does it edit AGENTS.md automatically?

No. Installing the skill only installs the skill files.

If you want Codex to remember the notification rule for future tasks, ask:

```text
Use $task-complete-notifier to configure notifications and add the task-completion notification rule to my AGENTS.md.
```

Codex should ask whether to write the rule globally or only for the current project before editing any AGENTS file.

## Manual setup

Download this repository, open PowerShell in the project folder, then choose a provider.

### Pushover

```powershell
.\setup.ps1 -Provider pushover
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Test notification"
```

### Generic webhook

```powershell
.\setup.ps1 -Provider webhook
.\notify-task-complete.ps1 -Provider webhook -Title "Task Notifier" -Message "Task completed"
```

### WeCom group robot

```powershell
.\setup.ps1 -Provider wecom
.\notify-task-complete.ps1 -Provider wecom -Title "Task Notifier" -Message "Task completed"
```

### Dry run

Dry run works for every provider and does not send a real request:

```powershell
.\notify-task-complete.ps1 -Provider wecom -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

## WeChat and WeCom

WeCom group robots support incoming webhook URLs and fit this project well.

Regular personal WeChat groups do not provide the same official simple webhook flow, so this project does not treat personal WeChat bots as a default provider.

## Apple Watch

Apple Watch receives the alert by mirroring Pushover notifications from your iPhone. If the phone receives the alert but the watch does not, check Pushover notification mirroring in the iPhone Watch app.

## Project structure

```text
.
├── notify-task-complete.ps1
├── setup.ps1
├── .env.example
└── skills/
    └── task-complete-notifier/
        ├── SKILL.md
        ├── agents/openai.yaml
        └── scripts/
```

## Security

- Do not paste webhook URLs, Pushover keys, or Pushcut URLs into chat.
- `.env` stays on your machine and is ignored by Git.
- The scripts do not print your secrets.
