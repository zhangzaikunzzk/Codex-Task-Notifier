# 任务完成提醒

这是一个很小的 PowerShell 脚本。作用很简单：任务跑完后，给你的手机或 Apple Watch 发一条提醒。

比如 Codex 改完代码、测试跑完、本地脚本执行结束、备份完成，你不用一直盯着电脑。收到通知再回来就行。

目前支持两种方式：

- Pushover：推荐，大多数人用这个就够了
- Pushcut：如果你本来就在用 Pushcut webhook，也可以用

## 用 Codex 安装，最省事

如果你用 Codex，直接把下面这句话复制给它：

```text
Install the Codex skill from https://github.com/zhangzaikunzzk/Codex-Task-Notifier/tree/main/skills/task-complete-notifier
```

安装完以后，重启 Codex。然后再说：

```text
Use $task-complete-notifier to set up task completion notifications.
```

接下来 Codex 会一步步带你配 Pushover 或 Pushcut。

## 会自动写 AGENTS.md 吗？

不会。

安装 skill 只是把 skill 装进去，不会偷偷改你的全局配置，也不会改项目里的 `AGENTS.md`。

如果你想让 Codex 以后在项目任务完成时自动发通知，再跟它说：

```text
Use $task-complete-notifier to configure notifications and add the task-completion notification rule to my AGENTS.md.
```

这时候 Codex 应该先问你：写到全局 AGENTS，还是只写到当前项目。确认之后再动文件。

## 不用 skill，手动也能装

如果你只是想自己跑脚本，也可以按下面来。

### 1. 先装 Pushover

在手机上安装 `Pushover`，注册或登录账号。先确认手机能收到 Pushover 通知。

如果你要让 Apple Watch 也响，去 iPhone 的 Watch App 里检查一下：

1. 打开 `Watch` App
2. 进入 `通知`
3. 找到 `Pushover`
4. 打开通知镜像

Apple Watch 本质上是跟着 iPhone 的 Pushover 通知走。

### 2. 拿到两个 key

打开 <https://pushover.net/> 并登录。

你需要两个东西：

- `PUSHOVER_USER_KEY`：首页里的 `Your User Key`
- `PUSHOVER_APP_TOKEN`：在 `Your Applications` 里新建 Application/API Token 后得到的 `API Token/Key`

别把这两个值发给别人，也别传到 GitHub。

### 3. 下载这个项目

在 GitHub 页面点绿色的 `Code`，选择 `Download ZIP`。下载后解压，打开文件夹。

### 4. 在这个文件夹里打开 PowerShell

在文件夹空白处按住 `Shift`，右键，选择 `Open PowerShell window here` 或 `Open in Terminal`。

### 5. 生成本地配置

复制这行命令，粘贴到 PowerShell，回车：

```powershell
.\setup.ps1
```

它会让你粘贴 app token 和 user key。填完后，脚本会在本地生成一个 `.env` 文件。

### 6. 先做 dry run

这一步不会真的发通知，只是确认脚本能跑：

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Dry run OK" -DryRun
```

看到下面这种输出就行：

```text
Dry run: would send Pushover notification.
```

### 7. 发一条真实测试通知

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Test notification"
```

手机应该会收到通知。Apple Watch 如果已经开启镜像，也会一起收到。

## 平时怎么用

任务结束时跑这行：

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Task Notifier" -Message "Task completed"
```

你也可以把标题和内容改成自己的：

```powershell
.\notify-task-complete.ps1 -Provider pushover -Title "Backup" -Message "Photos backup finished"
```

## 常见问题

### PowerShell 说不允许运行脚本

在当前 PowerShell 窗口先运行：

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

然后再运行 `setup.ps1` 或通知脚本。这个设置只对当前窗口生效。

### 提示缺少 PUSHOVER_APP_TOKEN

一般是 `.env` 没配好，或者你只填了 User Key。重新运行：

```powershell
.\setup.ps1
```

注意：`PUSHOVER_APP_TOKEN` 是 Application/API Token，不是账号首页的 User Key。

### 手机收到了，Apple Watch 没收到

先确认手机确实能收到 Pushover。然后打开 iPhone 的 Watch App，检查 Pushover 的通知镜像有没有打开。

## 这些文件是干什么的

- `notify-task-complete.ps1`：真正发送通知的脚本
- `setup.ps1`：帮你生成本地 `.env` 配置
- `.env.example`：配置模板，没有真实密钥
- `skills/task-complete-notifier/`：给 Codex 安装用的 skill

## 安全提醒

- 不要把 Pushover 或 Pushcut 的密钥发到聊天里。
- `.env` 只应该留在你自己的电脑上。
- 这个仓库已经把 `.env` 加进 `.gitignore`。
- 脚本不会打印你的 token 或 user key。
