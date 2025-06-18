[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Ensure log directory exists
$logPath = "C:\PSWindowsUpdate"
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
}

# Date for log file
$date = Get-Date -Format 'yyyy-MM-dd'
$logFile = "$logPath\$date-WindowsUpdate.log"

# Ensure proper execution policy
if ((Get-ExecutionPolicy) -ne 'RemoteSigned') {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
}

# Install and import module
Install-Module -Name PSWindowsUpdate -Force
Import-Module PSWindowsUpdate

# Fetch and install updates
Get-WindowsUpdate -Download -AcceptAll | Out-File $logFile -Force -Encoding UTF8
Install-WindowsUpdate -AcceptAll -Install -AutoReboot | Out-File $logFile -Force -Append -Encoding UTF8
