<#
.SYNOPSIS
    Windows Update Automation Script using PSWindowsUpdate

.DESCRIPTION
    Downloads and installs all available Windows updates,
    logs the process, and reboots automatically if necessary.

.VERSION
    1.2.0

.AUTHOR
    Mark Biesma

.DATE
    2025-06-19
#>

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Ensure log directory exists
$logPath = "C:\PSWindowsUpdate"
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
}

# Date for log file
$date = Get-Date -Format 'yyyy-MM-dd'
$logFile = "$logPath\$date-WindowsUpdate.log"

# Zorg dat NuGet provider beschikbaar is zonder prompt
$null = Get-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
}

# Install and import PSWindowsUpdate module if not already available
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
}

Import-Module PSWindowsUpdate -Force

# Fetch updates and log results
Get-WindowsUpdate -Download -AcceptAll | Out-File $logFile -Force -Encoding UTF8

# Install updates and log results
Install-WindowsUpdate -AcceptAll -Install -AutoReboot | Out-File $logFile -Force -Append -Encoding UTF8
