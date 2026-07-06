param(
  [ValidateSet("pushover", "pushcut", "webhook", "wecom")]
  [string]$Provider = "pushover",

  [string]$Title = "Task Notifier",
  [string]$Message = "Task completed",
  [string]$Priority = "0",
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$envFile = Join-Path $scriptDir ".env"

function Import-DotEnv {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    return
  }

  Get-Content -LiteralPath $Path | ForEach-Object {
    $line = $_.Trim()
    if ($line.Length -eq 0 -or $line.StartsWith("#")) {
      return
    }

    $parts = $line -split "=", 2
    if ($parts.Count -ne 2) {
      return
    }

    $name = $parts[0].Trim()
    $value = $parts[1].Trim()
    if ($value.StartsWith('"') -and $value.EndsWith('"')) {
      $value = $value.Substring(1, $value.Length - 2)
    }

    [Environment]::SetEnvironmentVariable($name, $value, "Process")
  }
}

function Require-Env {
  param([string]$Name)

  $value = [Environment]::GetEnvironmentVariable($Name, "Process")
  if ([string]::IsNullOrWhiteSpace($value)) {
    throw "Missing required environment variable: $Name. Run .\setup.ps1 or copy .env.example to .env."
  }
  return $value
}

function Invoke-JsonWebhook {
  param(
    [string]$Uri,
    [object]$Payload
  )

  $json = $Payload | ConvertTo-Json -Depth 8 -Compress
  Invoke-RestMethod `
    -Uri $Uri `
    -Method Post `
    -Body $json `
    -ContentType "application/json" `
    -TimeoutSec 20 | Out-Null
}

Import-DotEnv -Path $envFile

if ($Provider -eq "pushover") {
  if ($DryRun) {
    Write-Host "Dry run: would send Pushover notification."
    Write-Host "Title: $Title"
    Write-Host "Message: $Message"
    exit 0
  }

  $token = Require-Env -Name "PUSHOVER_APP_TOKEN"
  $user = Require-Env -Name "PUSHOVER_USER_KEY"

  $body = @{
    token = $token
    user = $user
    title = $Title
    message = $Message
    priority = $Priority
  }

  Invoke-RestMethod `
    -Uri "https://api.pushover.net/1/messages.json" `
    -Method Post `
    -Body $body `
    -TimeoutSec 20 | Out-Null

  Write-Host "Pushover notification sent."
  exit 0
}

if ($Provider -eq "pushcut") {
  if ($DryRun) {
    Write-Host "Dry run: would send Pushcut webhook."
    Write-Host "Title: $Title"
    Write-Host "Message: $Message"
    exit 0
  }

  $webhookUrl = Require-Env -Name "PUSHCUT_WEBHOOK_URL"
  Invoke-JsonWebhook -Uri $webhookUrl -Payload @{ title = $Title; text = $Message }

  Write-Host "Pushcut notification sent."
  exit 0
}

if ($Provider -eq "webhook") {
  if ($DryRun) {
    Write-Host "Dry run: would send generic webhook."
    Write-Host "Title: $Title"
    Write-Host "Message: $Message"
    exit 0
  }

  $webhookUrl = Require-Env -Name "WEBHOOK_URL"
  Invoke-JsonWebhook -Uri $webhookUrl -Payload @{ title = $Title; message = $Message }

  Write-Host "Generic webhook notification sent."
  exit 0
}

if ($Provider -eq "wecom") {
  if ($DryRun) {
    Write-Host "Dry run: would send WeCom group robot webhook."
    Write-Host "Title: $Title"
    Write-Host "Message: $Message"
    exit 0
  }

  $webhookUrl = Require-Env -Name "WECOM_WEBHOOK_URL"
  $content = "**$Title**`n`n$Message"
  Invoke-JsonWebhook -Uri $webhookUrl -Payload @{ msgtype = "markdown"; markdown = @{ content = $content } }

  Write-Host "WeCom webhook notification sent."
  exit 0
}
