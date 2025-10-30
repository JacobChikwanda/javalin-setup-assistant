# ==============================================================
# Javalin Setup Assistant (Windows Edition)
# Created by: Jacob Chikwanda & GPT-5
# GitHub: https://github.com/JacobChikwanda/javalin-setup-assistant
# Purpose: Help students easily install Java + Gradle for Javalin
# ==============================================================

# Display Banner
$scriptDir = Split-Path $MyInvocation.MyCommand.Definition -Parent
$bannerPath = Join-Path $scriptDir "assets\banner.txt"

if (Test-Path $bannerPath) {
    Get-Content $bannerPath | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
    Write-Host "`n"
} else {
    Write-Host "Javalin Setup Assistant by Jacob Chikwanda & GPT-5`n" -ForegroundColor Cyan
}

# Require Admin
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "WARNING: Please run PowerShell as Administrator (right-click - Run as Administrator)." -ForegroundColor Red
    exit
}

function Command-Exists($cmd) {
    return (Get-Command $cmd -ErrorAction SilentlyContinue) -ne $null
}

function Show-Progress($activity) {
    for ($i = 0; $i -le 100; $i += 10) {
        Write-Progress -Activity $activity -PercentComplete $i
        Start-Sleep -Milliseconds 150
    }
}

Write-Host "Hello, student! This tool by Jacob Chikwanda & GPT-5 will check for Java, Gradle, and Chocolatey."
Write-Host "It installs only what's missing - safe, automatic, and friendly!`n"

$dependencies = [ordered]@{
    "Chocolatey" = @{
        cmd = "choco"
        desc = "Chocolatey installs tools automatically on Windows."
        install = { 
            Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            # Refresh PATH in current session
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        }
    }
    "Java (OpenJDK)" = @{
        cmd = "java"
        desc = "Java lets your computer run Java apps."
        install = { choco install openjdk -y }
    }
    "Gradle" = @{
        cmd = "gradle"
        desc = "Gradle builds and runs your Javalin projects."
        install = { choco install gradle -y }
    }
}

$missing = @()
foreach ($dep in $dependencies.Keys) {
    $cmd = $dependencies[$dep].cmd
    if (Command-Exists $cmd) {
        Write-Host "OK - $dep is already installed."
    } else {
        Write-Host "MISSING - $dep is not installed."
        $missing += $dep
    }
}

if ($missing.Count -eq 0) {
    Write-Host "`nYou're all set! Everything you need for Javalin is installed." -ForegroundColor Green
    Write-Host "Script by Jacob Chikwanda & GPT-5"
    exit
}

Write-Host "`nMissing Components:`n" -ForegroundColor Yellow
foreach ($m in $missing) {
    Write-Host "- $m : $($dependencies[$m].desc)`n"
}

$totalSize = 500
Write-Host "Estimated total download size: about $totalSize MB.`n"

$confirm = Read-Host "Do you want to start installing now? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Setup cancelled. Run this script again anytime!"
    exit
}

foreach ($m in $missing) {
    Write-Host "`nInstalling $m..." -ForegroundColor Cyan
    Show-Progress "Installing $m"
    & $dependencies[$m].install
}

Write-Host "`nAll done! Restart PowerShell and check:" -ForegroundColor Green
Write-Host "   java --version"
Write-Host "   gradle -v"
Write-Host "`nCreated with love by Jacob Chikwanda & GPT-5"