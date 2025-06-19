<#
.SYNOPSIS
    Windows Update Automation Script using PSWindowsUpdate

.DESCRIPTION
    Automatically installs all available Windows updates,
    logs the process (including errors), and reboots the system if necessary.

.VERSION
    1.4.3

.AUTHOR
    Mark Biesma

.LINK
    https://github.com/MBiesma/WindowsUpdates.ps1

.DATE
    2025-06-19

.NOTES
    === USAGE INSTRUCTIONS ===

    1. Save this script as:
       C:\PSWindowsUpdate\WindowsUpdates.ps1

    2. Create a new task in Windows Task Scheduler with the following settings:

       - Action:
         Program/script: powershell.exe

       - Add arguments:
         -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File "C:\PSWindowsUpdate\WindowsUpdates.ps1"

    3. Ensure the task is configured to run with highest privileges ("Run with highest privileges").

    4. The script will automatically create a log file in:
       C:\PSWindowsUpdate

#>

# Only restart with ExecutionPolicy Bypass once
if (-not $env:SCRIPT_EXEC_POLICY_BYPASS) {
    Write-Host "Restarting script with ExecutionPolicy Bypass..."
    $env:SCRIPT_EXEC_POLICY_BYPASS = "1"
    powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -Command "& { [Environment]::SetEnvironmentVariable('SCRIPT_EXEC_POLICY_BYPASS','1','Process'); & '$($MyInvocation.MyCommand.Path)' }"
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
    Stop-
