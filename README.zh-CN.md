# 任务完成通知器

这是一个很小的 Windows PowerShell 工具，用来在任务完成时给手机或 Apple Watch 发通知。它支持 Pushover，也支持 Pushcut。

最适合的场景：让 Codex、本地脚本、构建任务、备份任务或其他耗时任务完成后提醒你回来查看结果。

## 最简单的用法：作为 Codex Skill 安装

如果你使用 Codex，直接复制下面这句话发给 Codex：

```text
Install the Codex skill from https://github.com/zhangzaikunzzk/Codex-Task-Notifier/tree/main/skills/task-complete-notifier
```

安装完成后，重启 Codex。然后对 Codex 说：

```text
Use $task-complete-notifier to set up task completion notifications.
```

Codex 会带你完成 Pushover 或 Pushcut 的本地配置。

## 会自动修改 AGENTS.md 吗？

不会。安装 skill 只会安装 skill 文件，不会自动修改你的全局或项目 `AGENTS.md`。

如果你希望以后每次项目任务完成时都提醒你，可以在安装后对 Codex 说：

```text
Use $task-complete-notifier to configure notifications and add the task-completion notification rule to my AGENTS.md.
```

Codex 应该先问你：规则写到全局 AGENTS，还是只写到当前项目 AGENTS。确认后再修改。

## 手动安装方式

如果你不想用 Codex skill，也可以手动使用脚本。

### 1. 安装 Pushover

1. 在手机上打开 App Store 或 Google Play。
2. 搜索并安装 `Pushover`。
3. 注册或登录 Pushover 账号。
4. 确认手机可以收到 Pushover 通知。

如果你想让 Apple Watch 收到通知，需要让 Apple Watch 镜像 iPhone 上的 Pushover 通知：

1. 打开 iPhone 上的 `Watch` App。
2. 进入 `Notifications`。
3. 找到 `Pushover`。
4. 打开通知镜像。

### 2. 获取 Pushover 的两个 key

打开 <https://pushover.net/> 并登录。

你需要两个值：

- `PUSHOVER_USER_KEY`：账号首页里的 `Your User Key`
- `PUSHOVER_APP_TOKEN`：在 `Your Applications` 里创建 Application/API Token 后得到的 `API Token/Key`

不要把这两个值发到聊天里，也不要上传到 GitHub。

### 3. 下载这个项目

在 GitHub 页面点击绿色的 `Code` 按钮，然后选择 `Download ZIP`。下载后解压，打开项目文件夹。

### 4. 打开 PowerShell

在项目文件夹空白处按住 `Shift`，右键点击，选择 `Open PowerShell window here` 或 `Open in Terminal`。

### 5. 创建本地配置

复制下面的命令到 PowerShell，然后回车：

```powershell
.\setup.ps1
```

根据提示粘贴你的 Pushover app token 和 user key。脚本会在本地创建 `.env` 文件。

### 6. 先做一次不发送通知的测试

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

如果看到 `Dry run: would send Pushover notification.`，说明脚本能正常运行。

### 7. 发送真实测试通知

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Test notification"
```

手机应该会收到通知。如果 Apple Watch 已经开启通知镜像，手表也会收到。

## 日常使用

任务完成时运行：

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Task completed"
```

你也可以改成自己的标题和内容：

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Backup" -Message "Photos backup finished"
```

## 常见问题

### PowerShell 提示不能运行脚本

在同一个 PowerShell 窗口运行：

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

然后再运行 setup 或通知命令。这个设置只影响当前 PowerShell 窗口。

### 提示缺少 PUSHOVER_APP_TOKEN

说明 `.env` 没配好，或者你只填了 User Key。重新运行：

```powershell
.\setup.ps1
```

### 手机有通知，Apple Watch 没有

先确认手机能收到 Pushover 通知，再检查 iPhone 的 Watch App 里是否允许 Pushover 通知镜像到手表。

## 文件说明

- `notify-task-complete.ps1`：发送通知的脚本
- `setup.ps1`：生成本地 `.env` 配置
- `.env.example`：配置模板，不包含真实密钥
- `skills/task-complete-notifier/`：可安装的 Codex skill

## 安全说明

- 不要把 Pushover 或 Pushcut 密钥发到聊天里。
- `.env` 只保存在你的电脑上，并且已被 `.gitignore` 忽略。
- 脚本不会打印你的 token 或 user key。
