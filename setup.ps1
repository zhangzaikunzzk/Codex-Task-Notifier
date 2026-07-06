param(
  [ValidateSet("pushover", "pushcut")]
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

  $appTokenSecure = Read-Host "PUSHOVER_APP_TOKEN" -AsSecureString
  $userKeySecure = Read-Host "PUSHOVER_USER_KEY" -AsSecureString

  $appToken = ConvertFrom-SecureStringPlainText -SecureValue $appTokenSecure
  $userKey = ConvertFrom-SecureStringPlainText -SecureValue $userKeySecure

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
  $webhookSecure = Read-Host "PUSHCUT_WEBHOOK_URL" -AsSecureString
  $webhookUrl = ConvertFrom-SecureStringPlainText -SecureValue $webhookSecure

  @(
    "# Local secrets. Do not commit this file."
    "PUSHCUT_WEBHOOK_URL=$webhookUrl"
  ) | Set-Content -LiteralPath $envFile -Encoding UTF8

  Write-Host ".env configured for Pushcut."
  exit 0
}
