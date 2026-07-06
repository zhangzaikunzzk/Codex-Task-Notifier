# 任务完成提醒

这是一个很小的 PowerShell 脚本。作用很简单：任务跑完后，发一条提醒。

可以发到：

- Pushover：适合手机和 Apple Watch，最推荐
- Pushcut：适合已经在用 Pushcut webhook 的人
- 通用 webhook：会发送 `{ "title": "...", "message": "..." }` 这种 JSON
- 企业微信群机器人：也就是企微群机器人的 webhook

比如 Codex 改完代码、测试跑完、本地脚本执行结束、备份完成，你不用一直盯着电脑。收到通知再回来就行。

## 微信和企微能不能用？

企微可以。企业微信群机器人本来就支持 webhook，这个项目已经加了 `wecom` provider。

普通个人微信不一样。个人微信群没有这种官方、稳定、简单的 webhook 入口。如果要接个人微信，通常要靠第三方中转或非官方机器人，风险和维护成本都高，所以这个项目默认不支持个人微信机器人。

## 用 Codex 安装，最省事

如果你用 Codex，直接把下面这句话复制给它：

```text
Install the Codex skill from https://github.com/zhangzaikunzzk/Codex-Task-Notifier/tree/main/skills/task-complete-notifier
```

安装完以后，重启 Codex。然后再说：

```text
Use $task-complete-notifier to set up task completion notifications.
```

接下来 Codex 会一步步带你配 Pushover、Pushcut、通用 webhook 或企微机器人。

## 会自动写 AGENTS.md 吗？

不会。

安装 skill 只是把 skill 装进去，不会偷偷改你的全局配置，也不会改项目里的 `AGENTS.md`。

如果你想让 Codex 以后在项目任务完成时自动发通知，再跟它说：

```text
Use $task-complete-notifier to configure notifications and add the task-completion notification rule to my AGENTS.md.
```

这时候 Codex 应该先问你：写到全局 AGENTS，还是只写到当前项目。确认之后再动文件。

## 手动用法

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

先在企微群里添加群机器人，复制 webhook 地址。然后运行：

```powershell
.\setup.ps1 -Provider wecom
.\notify-task-complete.ps1 -Provider wecom -Title "Task Notifier" -Message "Task completed"
```

### dry run

每种 provider 都可以先 dry run，不会真的发请求：

```powershell
.\notify-task-complete.ps1 -Provider wecom -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

## Apple Watch 怎么收到？

Apple Watch 是跟着 iPhone 的 Pushover 通知走的。手机能收到，手表没收到，就去 iPhone 的 Watch App 里检查 Pushover 的通知镜像。

## 这些文件是干什么的

- `notify-task-complete.ps1`：真正发送通知的脚本
- `setup.ps1`：帮你生成本地 `.env` 配置
- `.env.example`：配置模板，没有真实密钥
- `skills/task-complete-notifier/`：给 Codex 安装用的 skill

## 安全提醒

- 不要把 Pushover key、Pushcut URL、企微机器人 URL 或其他 webhook 地址发到聊天里。
- `.env` 只应该留在你自己的电脑上。
- 这个仓库已经把 `.env` 加进 `.gitignore`。
- 脚本不会打印你的密钥。
