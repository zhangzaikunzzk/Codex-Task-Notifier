<p align="center">
  <h1 align="center">任务完成提醒</h1>
  <p align="center">Codex、脚本、测试、构建跑完后，自动发一条提醒。</p>
</p>

<p align="center">
  <a href="README.md">English</a>
  ·
  <a href="skills/task-complete-notifier">Codex Skill</a>
  ·
  <a href="#手动用法">手动用法</a>
</p>

<p align="center">
  <img alt="PowerShell" src="https://img.shields.io/badge/PowerShell-5%2B-4479A1">
  <img alt="Codex Skill" src="https://img.shields.io/badge/Codex-Skill-111827">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green">
  <img alt="Secrets" src="https://img.shields.io/badge/secrets-local_only-orange">
</p>

---

## 这是干什么的

一个很小的 PowerShell 脚本。任务跑完后，它给你发一条提醒。

适合这些场景：Codex 改代码、测试跑很久、本地脚本执行、构建、备份。你不用一直盯着终端，收到通知再回来。

## 支持哪些通知方式

| 方式 | 适合什么 | Provider |
| --- | --- | --- |
| Pushover | 手机和 Apple Watch | `pushover` |
| Pushcut | iOS 自动化 webhook | `pushcut` |
| 通用 webhook | 任意能接 JSON 的服务 | `webhook` |
| 企业微信群机器人 | 企微群提醒 | `wecom` |

通用 webhook 会发送：

```json
{ "title": "Task Notifier", "message": "Task completed" }
```

企微机器人会按 markdown 消息发到群里。

## 最省事：让 Codex 安装 skill

把这句话复制给 Codex：

```text
Install the Codex skill from https://github.com/zhangzaikunzzk/Codex-Task-Notifier/tree/main/skills/task-complete-notifier
```

安装完后，重启 Codex。然后说：

```text
Use $task-complete-notifier to set up task completion notifications.
```

Codex 会带你选 Pushover、Pushcut、通用 webhook 或企微机器人。

## 会自动写 AGENTS.md 吗？

不会。安装 skill 只是安装 skill 文件，不会偷偷改你的全局配置，也不会改项目里的 `AGENTS.md`。

如果你想让 Codex 以后在项目任务完成时自动提醒，再说：

```text
Use $task-complete-notifier to configure notifications and add the task-completion notification rule to my AGENTS.md.
```

Codex 应该先问你写到哪里：全局 AGENTS，还是当前项目 AGENTS。

## 手动用法

下载这个仓库，在项目文件夹里打开 PowerShell，然后选一种 provider。

### Pushover

```powershell
.\setup.ps1 -Provider pushover
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Test notification"
```

### 通用 webhook

```powershell
.\setup.ps1 -Provider webhook
.\notify-task-complete.ps1 -Provider webhook -Title "Task Notifier" -Message "Task completed"
```

### 企业微信群机器人

```powershell
.\setup.ps1 -Provider wecom
.\notify-task-complete.ps1 -Provider wecom -Title "Task Notifier" -Message "Task completed"
```

### 先 dry run

每种方式都可以先 dry run，不会真的发请求：

```powershell
.\notify-task-complete.ps1 -Provider wecom -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

## 微信和企微

企微可以。企业微信群机器人本来就支持 webhook，这个项目已经加了 `wecom`。

个人微信群不一样，没有官方、稳定、简单的 webhook 入口。要接个人微信通常得靠第三方中转或非官方机器人，维护成本和风险都高，所以这里不把它当默认支持项。

## Apple Watch

Apple Watch 是跟着 iPhone 的 Pushover 通知走的。手机能收到，手表没收到，就去 iPhone 的 Watch App 里检查 Pushover 的通知镜像。

## 项目结构

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

## 安全提醒

- 不要把 Pushover key、Pushcut URL、企微机器人 URL 或其他 webhook 地址发到聊天里。
- `.env` 只应该留在你自己的电脑上。
- 这个仓库已经把 `.env` 加进 `.gitignore`。
- 脚本不会打印你的密钥。
