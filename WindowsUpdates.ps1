<#
.SYNOPSIS
    Windows Update Automation Script using PSWindowsUpdate

.DESCRIPTION
    Downloads and installs all available Windows updates,
    logs the process, and reboots automatically if necessary.

.VERSION
    1.1.0

.AUTHOR
    [Your Name or Organization]

.DATE
    2025-06-18
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

# Install and import PSWindowsUpdate module if not already available
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module -Name PSWindowsUpdate -Force
}

Import-Module PSWindowsUpdate -Force

# Fetch updates and log results
Get-WindowsUpdate -Download -AcceptAll | Out-File $logFile -Force -Encoding UTF8

# Install updates and log results
Install-WindowsUpdate -AcceptAll -Install -AutoReboot | Out-File $logFile -Force -Append -Encoding UTF8
