# Task Complete Notifier

A tiny Windows PowerShell utility for sending "task completed" notifications to your phone or Apple Watch through Pushover or Pushcut.

## Easiest Setup: Install as a Codex Skill

Copy this into Codex:

```text
Install the Codex skill from https://github.com/zhangzaikunzzk/Codex-Task-Notifier/tree/main/skills/task-complete-notifier
```

After Codex installs it, restart Codex so the new skill is loaded. Then ask:

```text
Use $task-complete-notifier to set up task completion notifications.
```

Codex will guide you through Pushover or Pushcut setup.

## Does It Edit AGENTS.md Automatically?

No. Installing the skill only installs the skill files. It does not automatically edit global or project `AGENTS.md`.

If you want Codex to remember the notification rule for future tasks, ask:

```text
Use $task-complete-notifier to configure notifications and add the task-completion notification rule to my AGENTS.md.
```

Codex should ask whether to write the rule globally or only for the current project before editing any AGENTS file.

## Manual Setup Without Codex Skill

1. Install Pushover on your phone.
2. Create or log into your Pushover account at <https://pushover.net/>.
3. Copy your account `User Key`.
4. Create an application/API token under `Your Applications`.
5. Download this repository as a ZIP and unzip it.
6. Open PowerShell in the project folder.
7. Run:

```powershell
.\setup.ps1
```

Paste your Pushover app token and user key when prompted.

Test without sending:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

Send a real test notification:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Test notification"
```

## Apple Watch Notes

Apple Watch receives the notification by mirroring Pushover notifications from your iPhone. If the phone receives the alert but the watch does not, check the iPhone Watch app notification settings for Pushover.

## Files

- `notify-task-complete.ps1`: sends the notification.
- `setup.ps1`: creates your local `.env` configuration.
- `.env.example`: shows the config format.
- `skills/task-complete-notifier/`: installable Codex skill package.

## Security

- Do not paste Pushover or Pushcut secrets into chat.
- `.env` stays on your machine and is ignored by Git.
- The scripts do not print your token or user key.
