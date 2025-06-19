# Windows Update Automation Script

[![PowerShell](https://img.shields.io/badge/PowerShell-v5%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

This PowerShell script automates the process of installing all available Windows updates on a system using the widely respected **PSWindowsUpdate** module. It handles downloading, installing updates, logging the entire update process (including any errors), and will automatically reboot the system if a restart is required. 

The script is designed for system administrators and IT professionals who want to streamline Windows Update management in an automated and reliable way without manually interacting with Windows Update GUI or the built-in Windows Update service.

---

## Features

- **Automatic installation** of all available Windows updates.
- **Comprehensive logging** with detailed timestamped transcripts stored locally.
- **Automatic reboot** of the system if required by updates.
- Ensures **secure PowerShell Gallery communication** by enforcing TLS 1.2.
- Checks and installs **required dependencies** such as the NuGet package provider and the PSWindowsUpdate module.
- Designed to **run with ExecutionPolicy Bypass** for seamless execution without manual policy changes.

---

## How It Works

1. **Execution Policy Bypass:**  
   The script restarts itself with `ExecutionPolicy Bypass` once to ensure it can run unrestricted, which is necessary for installing modules and performing updates.

2. **Logging Setup:**  
   It creates a log directory (`C:\PSWindowsUpdate`) if it does not exist, and starts transcript logging with a timestamped filename for easy tracking of each run.

3. **Dependency Checks:**  
   - Verifies that the NuGet package provider is installed; if missing, installs it.
   - Checks for the presence of the PSWindowsUpdate module; if not installed, installs it from the PowerShell Gallery.

4. **Module Import and Update Installation:**  
   Imports the PSWindowsUpdate module and starts installing all available updates silently, accepting all prompts automatically.

5. **Automatic Reboot:**  
   If updates require a reboot, the system will restart automatically.

6. **Error Handling:**  
   Catches and logs any errors during the process for troubleshooting.

---

## Prerequisites

- Windows PowerShell 5.0 or later (PowerShell 7+ is supported but tested primarily on Windows PowerShell 5.x).
- Internet connectivity to download modules and updates.
- Appropriate administrative privileges to install updates and reboot the system.

---

## Usage

1. Download or clone the repository.
2. Run the script as an Administrator.
3. The script will automatically handle everything from dependencies to update installation and reboot.
4. Review logs in `C:\PSWindowsUpdate` for detailed output and any errors.

```powershell
.\WindowsUpdates.ps1
