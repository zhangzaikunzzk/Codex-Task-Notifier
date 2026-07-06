param(
  [ValidateSet("pushover", "pushcut", "webhook", "wecom")]
  [string]$Provider = "pushover"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$envFile = Join-Path $scriptDir ".env"

function ConvertFrom-SecureStringPlainText {
  param([Security.SecureString]$SecureValue)

  $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureValue)
  try {
    return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
  } finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
  }
}

function Read-SecretText {
  param([string]$Prompt)
  $secure = Read-Host $Prompt -AsSecureString
  return ConvertFrom-SecureStringPlainText -SecureValue $secure
}

if (Test-Path -LiteralPath $envFile) {
  $overwrite = Read-Host ".env already exists. Overwrite it? Type YES to continue"
  if ($overwrite -ne "YES") {
    Write-Host "Setup cancelled."
    exit 0
  }
}

if ($Provider -eq "pushover") {
  Write-Host "Pushover setup"
  Write-Host "Paste values from pushover.net. Input is hidden where possible."

  $appToken = Read-SecretText -Prompt "PUSHOVER_APP_TOKEN"
  $userKey = Read-SecretText -Prompt "PUSHOVER_USER_KEY"

  @(
    "# Local secrets. Do not commit this file."
    "PUSHOVER_APP_TOKEN=$appToken"
    "PUSHOVER_USER_KEY=$userKey"
  ) | Set-Content -LiteralPath $envFile -Encoding UTF8

  Write-Host ".env configured for Pushover."
  exit 0
}

if ($Provider -eq "pushcut") {
  Write-Host "Pushcut setup"
  $webhookUrl = Read-SecretText -Prompt "PUSHCUT_WEBHOOK_URL"

  @(
    "# Local secrets. Do not commit this file."
    "PUSHCUT_WEBHOOK_URL=$webhookUrl"
  ) | Set-Content -LiteralPath $envFile -Encoding UTF8

  Write-Host ".env configured for Pushcut."
  exit 0
}

if ($Provider -eq "webhook") {
  Write-Host "Generic webhook setup"
  $webhookUrl = Read-SecretText -Prompt "WEBHOOK_URL"

  @(
    "# Local secrets. Do not commit this file."
    "WEBHOOK_URL=$webhookUrl"
  ) | Set-Content -LiteralPath $envFile -Encoding UTF8

  Write-Host ".env configured for generic webhook."
  exit 0
}

if ($Provider -eq "wecom") {
  Write-Host "WeCom group robot setup"
  $webhookUrl = Read-SecretText -Prompt "WECOM_WEBHOOK_URL"

  @(
    "# Local secrets. Do not commit this file."
    "WECOM_WEBHOOK_URL=$webhookUrl"
  ) | Set-Content -LiteralPath $envFile -Encoding UTF8

  Write-Host ".env configured for WeCom."
  exit 0
}
