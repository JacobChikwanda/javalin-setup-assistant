# ==============================================================
# Javalin Setup Assistant (Windows Edition)
# Created by: Jacob Chikwanda & GPT-5
# GitHub: https://github.com/JacobChikwanda/javalin-setup-assistant
# Purpose: Help students easily install Java + Gradle for Javalin
# ==============================================================

# Set error action to continue so script doesn't exit on error
$ErrorActionPreference = "Continue"

# Display ASCII Banner
$banner = @"
  _____     _     _   _          
 |_   _|   | |   | | (_)         
   | | __ _| |__ | |  _ ___ _   _
   | |/ _\` | '_ \| | | / __| | | |
   | | (_| | | | | | | \__ \ |_| |
   |_|\__,_|_| |_|_| |_|___/\__,_|
   
        Javalin Setup Assistant
    by Jacob Chikwanda & GPT-5
"@

Write-Host $banner -ForegroundColor Cyan
Write-Host ""

# Check if running as Admin
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "WARNING: Please run PowerShell as Administrator (right-click - Run as Administrator)." -ForegroundColor Red
    Write-Host "The script will exit in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    return
}

function Command-Exists($cmd) {
    $null = Get-Command $cmd -ErrorAction SilentlyContinue
    return $?
}

function Show-Progress($activity) {
    for ($i = 0; $i -le 100; $i += 10) {
        Write-Progress -Activity $activity -PercentComplete $i -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 150
    }
    Write-Progress -Activity $activity -Completed -ErrorAction SilentlyContinue
}

Write-Host "Hello, student! This tool by Jacob Chikwanda & GPT-5 will check for Java, Gradle, and Chocolatey."
Write-Host "It installs only what's missing - safe, automatic, and friendly!`n"

$dependencies = [ordered]@{
    "Chocolatey" = @{
        cmd = "choco"
        desc = "Chocolatey installs tools automatically on Windows."
        install = { 
            Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
            Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            try {
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "Failed to install Chocolatey: $_" -ForegroundColor Red
                return $false
            }
        }
    }
    "Java (OpenJDK)" = @{
        cmd = "java"
        desc = "Java lets your computer run Java apps."
        install = { 
            try {
                Write-Host "Installing Java..." -ForegroundColor Yellow
                & choco install openjdk -y 2>&1 | Out-String | Write-Host
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "Java installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "Failed to install Java: $_" -ForegroundColor Red
                return $false
            }
        }
    }
    "Gradle" = @{
        cmd = "gradle"
        desc = "Gradle builds and runs your Javalin projects."
        install = { 
            try {
                Write-Host "Installing Gradle..." -ForegroundColor Yellow
                & choco install gradle -y 2>&1 | Out-String | Write-Host
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "Gradle installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "Failed to install Gradle: $_" -ForegroundColor Red
                return $false
            }
        }
    }
}

$missing = @()
foreach ($dep in $dependencies.Keys) {
    $cmd = $dependencies[$dep].cmd
    if (Command-Exists $cmd) {
        Write-Host "[OK] $dep is already installed." -ForegroundColor Green
    } else {
        Write-Host "[MISSING] $dep is not installed." -ForegroundColor Yellow
        $missing += $dep
    }
}

if ($missing.Count -eq 0) {
    Write-Host "`nYou're all set! Everything you need for Javalin is installed." -ForegroundColor Green
    Write-Host "Script by Jacob Chikwanda & GPT-5`n"
    Write-Host "This window will close in 5 seconds..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
    return
}

Write-Host "`nMissing Components:`n" -ForegroundColor Yellow
foreach ($m in $missing) {
    Write-Host "  - $m : $($dependencies[$m].desc)"
}
Write-Host ""

$totalSize = 500
Write-Host "Estimated total download size: about $totalSize MB.`n" -ForegroundColor Cyan

# Auto-install with a countdown timer for user to cancel
Write-Host "Installation will start automatically in 10 seconds..." -ForegroundColor Yellow
Write-Host "Press CTRL+C to cancel`n" -ForegroundColor Gray

for ($i = 10; $i -gt 0; $i--) {
    Write-Host "`rStarting in $i seconds... " -NoNewline -ForegroundColor Cyan
    Start-Sleep -Seconds 1
}
Write-Host "`n"

# Install missing dependencies
$failedInstalls = @()
foreach ($m in $missing) {
    Write-Host "`n========================================" -ForegroundColor DarkGray
    Write-Host "Installing $m..." -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor DarkGray
    Show-Progress "Installing $m"
    
    $result = & $dependencies[$m].install
    if (-not $result) {
        $failedInstalls += $m
    }
    
    Write-Host ""
}

# Final status
Write-Host "`n========================================" -ForegroundColor DarkGray
if ($failedInstalls.Count -eq 0) {
    Write-Host "SUCCESS! All components installed!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor DarkGray
    Write-Host "`nRestart PowerShell and verify with:" -ForegroundColor Cyan
    Write-Host "   java --version"
    Write-Host "   gradle -v"
} else {
    Write-Host "PARTIAL SUCCESS" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor DarkGray
    Write-Host "Failed to install:" -ForegroundColor Red
    foreach ($f in $failedInstalls) {
        Write-Host "  - $f" -ForegroundColor Red
    }
    Write-Host "`nTry running the script again or install manually." -ForegroundColor Yellow
}

Write-Host "`nCreated with love by Jacob Chikwanda & GPT-5" -ForegroundColor Magenta
Write-Host "GitHub: https://github.com/JacobChikwanda/javalin-setup-assistant`n" -ForegroundColor Gray

Write-Host "This window will close in 10 seconds..." -ForegroundColor Gray
Start-Sleep -Seconds 10