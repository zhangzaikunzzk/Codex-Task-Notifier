---
name: task-complete-notifier
description: Send task-complete notifications to a user's phone or Apple Watch through local PowerShell scripts using Pushover or Pushcut. Use when the user asks Codex to install, configure, test, or run project-completion notifications, Apple Watch alerts, Pushover task alerts, Pushcut webhooks, AGENTS.md notification rules, or end-of-task reminders.
---

# Task Complete Notifier

## Overview

Use this skill to set up and send local task-completion notifications. Prefer Pushover for most users; use Pushcut only when the user already has a Pushcut webhook.

The bundled scripts live in `scripts/` relative to this `SKILL.md`:

- `scripts/notify-task-complete.ps1`: sends a notification.
- `scripts/setup.ps1`: creates a local `.env` file for Pushover or Pushcut.

## Safety Rules

- Never ask the user to paste Pushover or Pushcut secrets into chat.
- Never print, summarize, upload, or commit `.env` contents.
- Keep `.env` local and ensure `.gitignore` includes it when copying scripts into a repo.
- Ask for network approval before sending a real notification if the tool environment requires escalation.
- Send completion notifications only when a project task is genuinely complete, not for ordinary chat, progress updates, or blocked work.

## Setup Workflow

1. Choose a local destination for the notifier files.
   - If the user is working in a repo, prefer `<repo>/tools/task-complete-notifier/` or another small utility folder.
   - If the user wants a global local notifier, use a clear local folder outside source-controlled work.
2. Copy `scripts/notify-task-complete.ps1` and `scripts/setup.ps1` into that destination.
3. Add or update `.gitignore` near the destination so `.env` is ignored.
4. Tell the user to run setup from PowerShell:

```powershell
.\setup.ps1
```

5. The setup script asks for:
   - `PUSHOVER_APP_TOKEN`
   - `PUSHOVER_USER_KEY`

For Pushcut, use:

```powershell
.\setup.ps1 -Provider pushcut
```

## Testing Workflow

First run a dry run; it must not require secrets or network:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

Then, after the user confirms `.env` is configured, send a real test:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Test notification"
```

If the user uses Apple Watch, tell them to verify that the iPhone receives the Pushover notification and that Apple Watch notification mirroring is enabled for Pushover.

## AGENTS.md Persistence

Installing the skill does not automatically edit `AGENTS.md`. When the user asks to make notifications persistent:

1. Ask whether they want the rule in the current project's `AGENTS.md` or their global Codex instructions.
2. Before editing, state the target file and the exact rule being added.
3. Add this rule, adapted only for the chosen script path:

```markdown
- When a project task is genuinely complete and before the final response, run the local task-complete notifier script to send a Pushover or Pushcut completion notification. Do not send notifications for ordinary chat, intermediate progress, or blocked work. Never print, summarize, upload, or commit notifier `.env` secrets.
```

4. If no AGENTS file exists at the chosen project target, create it only after the user confirms.
5. Do not overwrite unrelated AGENTS content.

## Task Completion Workflow

At the end of a project task, after validation and before the final response, send one notification:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Codex" -Message "Task completed"
```

Use a more specific message when helpful, for example:

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Codex" -Message "Build and tests completed"
```

If sending fails, mention the failure briefly in the final response and include the error category without exposing secrets.

## Troubleshooting

- `Missing required environment variable`: `.env` is missing or incomplete. Ask the user to run `setup.ps1` again or create `.env` from `.env.example` without sharing values in chat.
- `scripts are disabled`: tell the user to run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` in the current PowerShell window.
- No Apple Watch alert: verify the phone alert first, then check iPhone Watch app notification mirroring for Pushover.
