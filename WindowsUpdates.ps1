<#
.SYNOPSIS
    Windows Update Automation Script using PSWindowsUpdate

.DESCRIPTION
    Automatically installs all available Windows updates,
    logs the process, and reboots the system if necessary.

.VERSION
    1.3.1

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

# Generate log file name with date and time (YYYYMMDD_HHmm)
$timestamp = Get-Date -Format 'yyyyMMdd_HHmm'
$logFile = "$logPath\$timestamp-WindowsUpdate.log"

# Ensure NuGet provider is available without prompts
$null = Get-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
}

# Install PSWindowsUpdate module if not already installed
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
}

# Import the module
Import-Module PSWindowsUpdate -Force

# Install updates and log results
Install-WindowsUpdate -AcceptAll -Install -AutoReboot | Out-File $logFile -Force -Encoding UTF8
