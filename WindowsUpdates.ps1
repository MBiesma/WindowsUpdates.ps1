<#
.SYNOPSIS
    Windows Update Automation Script using PSWindowsUpdate

.DESCRIPTION
    Automatically installs all available Windows updates,
    logs the process (including errors), and reboots the system if necessary.

.VERSION
    1.4.0

.AUTHOR
    Mark Biesma

.DATE
    2025-06-19
#>

# Re-run the script with ExecutionPolicy Bypass if not already
if ($ExecutionContext.SessionState.LanguageMode -ne 'FullLanguage' -or
    (Get-ExecutionPolicy) -ne 'Bypass') {
    Write-Host "Restarting script with ExecutionPolicy Bypass..."
    powershell.exe -ExecutionPolicy Bypass -NoProfile -File $MyInvocation.MyCommand.Path
    exit
}

# Ensure TLS 1.2 for secure connection to PowerShell Gallery
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Ensure log directory exists
$logPath = "C:\PSWindowsUpdate"
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
}

# Generate timestamped log file name
$timestamp = Get-Date -Format 'yyyyMMdd_HHmm'
$logFile = "$logPath\$timestamp-WindowsUpdate.log"

# Start full transcript logging
Start-Transcript -Path $logFile -Force

try {
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Ensuring NuGet provider is installed..."
    $null = Get-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue
    if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
    }

    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Ensuring PSWindowsUpdate module is installed..."
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
    }

    Import-Module PSWindowsUpdate -Force

    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Starting Windows Update installation..."
    Install-WindowsUpdate -AcceptAll -Install -AutoReboot -IgnoreReboot
}
catch {
    Write-Error "[$(Get-Date -Format 'HH:mm:ss')] ERROR: $($_.Exception.Message)"
}
finally {
    Stop-Transcript
}
