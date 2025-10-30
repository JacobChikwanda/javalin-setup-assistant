# ==============================================================
# Javalin Setup Assistant (Windows Edition)
# Created by: Jacob Chikwanda & GPT-5
# GitHub: https://github.com/JacobChikwanda/javalin-setup-assistant
# Purpose: Help students easily install Java + Gradle for Javalin
# ==============================================================

# Force UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Display Banner
$banner = @"
███████╗ █████╗ ██╗   ██╗ █████╗ ██╗     ██╗███╗   ██╗
██╔════╝██╔══██╗██║   ██║██╔══██╗██║     ██║████╗  ██║
█████╗  ███████║██║   ██║███████║██║     ██║██╔██╗ ██║
██╔══╝  ██╔══██║╚██╗ ██╔╝██╔══██║██║     ██║██║╚██╗██║
██║     ██║  ██║ ╚████╔╝ ██║  ██║███████╗██║██║ ╚████║
╚═╝     ╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝
            Javalin Setup Assistant
        by Jacob Chikwanda & GPT-5
"@

Write-Host $banner -ForegroundColor Cyan
Write-Host ""

# Require Admin
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "WARNING: Please run PowerShell as Administrator (right-click - Run as Administrator)." -ForegroundColor Red
    exit 1
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
                iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            } catch {
                Write-Host "Failed to install Chocolatey: $_" -ForegroundColor Red
                return $false
            }
            return $true
        }
    }
    "Java (OpenJDK)" = @{
        cmd = "java"
        desc = "Java lets your computer run Java apps."
        install = { 
            try {
                choco install openjdk -y
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
                choco install gradle -y
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
        Write-Host "[OK] $dep is already installed."
    } else {
        Write-Host "[MISSING] $dep is not installed."
        $missing += $dep
    }
}

if ($missing.Count -eq 0) {
    Write-Host "`nYou're all set! Everything you need for Javalin is installed." -ForegroundColor Green
    Write-Host "Script by Jacob Chikwanda & GPT-5`n"
    exit 0
}

Write-Host "`nMissing Components:`n" -ForegroundColor Yellow
foreach ($m in $missing) {
    Write-Host "  - $m : $($dependencies[$m].desc)"
}
Write-Host ""

$totalSize = 500
Write-Host "Estimated total download size: about $totalSize MB.`n"

$confirm = Read-Host "Do you want to start installing now? (y/n)"
if ($confirm -ne "y") {
    Write-Host "`nSetup cancelled. Run this script again anytime!"
    exit 0
}

foreach ($m in $missing) {
    Write-Host "`nInstalling $m..." -ForegroundColor Cyan
    Show-Progress "Installing $m"
    & $dependencies[$m].install
}

Write-Host "`nAll done! Restart PowerShell and check:" -ForegroundColor Green
Write-Host "   java --version"
Write-Host "   gradle -v"
Write-Host "`nCreated with love by Jacob Chikwanda & GPT-5`n"