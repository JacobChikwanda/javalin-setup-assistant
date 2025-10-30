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

     _______________________________________________
    |                                               |
    |        JAVALIN SETUP ASSISTANT                |
    |        ========================                |
    |                                               |
    |     Your friendly Java + Gradle installer     |
    |         by Jacob Chikwanda & GPT-5            |
    |_______________________________________________|

"@

Write-Host $banner -ForegroundColor Cyan
Write-Host ""

# Check if running as Admin
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "[!] WARNING: Please run PowerShell as Administrator" -ForegroundColor Red
    Write-Host "    (Right-click PowerShell -> Run as Administrator)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    Exiting in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    return
}

function Command-Exists($cmd) {
    $null = Get-Command $cmd -ErrorAction SilentlyContinue
    return $?
}

function Show-Progress($activity, $percentComplete) {
    $barLength = 30
    $filledLength = [math]::Round(($percentComplete / 100) * $barLength)
    $bar = ('#' * $filledLength).PadRight($barLength, '-')
    Write-Host "`r    [$bar] $percentComplete% - $activity" -NoNewline -ForegroundColor Cyan
}

function Animate-Progress($activity) {
    for ($i = 0; $i -le 100; $i += 5) {
        Show-Progress $activity $i
        Start-Sleep -Milliseconds 100
    }
    Write-Host "`r    [##############################] 100% - Complete!                    " -ForegroundColor Green
}

Write-Host ">> Welcome, student!" -ForegroundColor Green
Write-Host "   This tool will check for Java, Gradle, and Chocolatey" -ForegroundColor White
Write-Host "   and install only what's missing." -ForegroundColor White
Write-Host ""
Write-Host "   Made with <3 by Jacob Chikwanda & GPT-5" -ForegroundColor Magenta
Write-Host ""

Write-Host "[*] Scanning your system..." -ForegroundColor Blue
Write-Host ""

$dependencies = [ordered]@{
    "Chocolatey" = @{
        cmd = "choco"
        desc = "Package manager that installs tools automatically on Windows"
        displayName = "Chocolatey"
        install = { 
            Write-Host "    [>] Downloading Chocolatey..." -ForegroundColor Yellow
            Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            try {
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "    [+] Chocolatey installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "    [-] Failed to install Chocolatey: $_" -ForegroundColor Red
                return $false
            }
        }
    }
    "Java (OpenJDK)" = @{
        cmd = "java"
        desc = "The Java runtime - lets your computer run Java programs"
        displayName = "Java (OpenJDK)"
        install = { 
            try {
                Write-Host "    [>] Installing Java..." -ForegroundColor Yellow
                & choco install openjdk -y 2>&1 | Out-String | Write-Host
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "    [+] Java installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "    [-] Failed to install Java: $_" -ForegroundColor Red
                return $false
            }
        }
    }
    "Gradle" = @{
        cmd = "gradle"
        desc = "Build tool that compiles and runs your Javalin projects"
        displayName = "Gradle"
        install = { 
            try {
                Write-Host "    [>] Installing Gradle..." -ForegroundColor Yellow
                & choco install gradle -y 2>&1 | Out-String | Write-Host
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "    [+] Gradle installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "    [-] Failed to install Gradle: $_" -ForegroundColor Red
                return $false
            }
        }
    }
}

$missing = @()
foreach ($dep in $dependencies.Keys) {
    $cmd = $dependencies[$dep].cmd
    $displayName = $dependencies[$dep].displayName
    Write-Host -NoNewline "  "
    if (Command-Exists $cmd) {
        Write-Host "[OK]" -ForegroundColor Green -NoNewline
        Write-Host " $displayName is installed" -ForegroundColor White
        # Show version if available
        switch ($cmd) {
            "java" {
                $version = & java --version 2>&1 | Select-Object -First 1
                Write-Host "       Version: $version" -ForegroundColor DarkGray
            }
            "gradle" {
                $version = & gradle --version 2>&1 | Select-String "Gradle" | Select-Object -First 1
                if ($version) {
                    Write-Host "       Version: $version" -ForegroundColor DarkGray
                }
            }
            "choco" {
                $version = & choco --version 2>&1
                Write-Host "       Version: Chocolatey $version" -ForegroundColor DarkGray
            }
        }
    } else {
        Write-Host "[--]" -ForegroundColor Yellow -NoNewline
        Write-Host " $displayName is NOT installed" -ForegroundColor Yellow
        $missing += $dep
    }
}

Write-Host ""

if ($missing.Count -eq 0) {
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "  SUCCESS! Everything is already installed!" -ForegroundColor Green
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  You're ready to build Javalin applications!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Script by Jacob Chikwanda & GPT-5" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  Window will close in 5 seconds..." -ForegroundColor DarkGray
    Start-Sleep -Seconds 5
    return
}

Write-Host "[!] Missing Components:" -ForegroundColor Yellow
Write-Host ""
foreach ($m in $missing) {
    Write-Host "    * $($dependencies[$m].displayName)" -ForegroundColor Cyan
    Write-Host "      $($dependencies[$m].desc)" -ForegroundColor White
}
Write-Host ""

$totalSize = 500
Write-Host "[i] Estimated download size: ~$totalSize MB" -ForegroundColor Blue
Write-Host ""

# Auto-install with a countdown timer for user to cancel
Write-Host "[>] Installation will start automatically in 10 seconds..." -ForegroundColor Yellow
Write-Host "    Press CTRL+C to cancel" -ForegroundColor Red
Write-Host ""

for ($i = 10; $i -gt 0; $i--) {
    $dots = "." * (11 - $i)
    Write-Host "`r    Starting in $i seconds$dots    " -NoNewline -ForegroundColor Cyan
    Start-Sleep -Seconds 1
}
Write-Host "`r                                        " -NoNewline
Write-Host "`r"

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  STARTING INSTALLATION" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Install missing dependencies
$failedInstalls = @()
$installCount = 0
foreach ($m in $missing) {
    $installCount++
    Write-Host "[Step $installCount of $($missing.Count)] Installing $($dependencies[$m].displayName)" -ForegroundColor White
    Write-Host "---------------------------------------------------" -ForegroundColor DarkGray
    
    Animate-Progress "Installing $($dependencies[$m].displayName)"
    
    $result = & $dependencies[$m].install
    if (-not $result) {
        $failedInstalls += $m
    }
    
    Write-Host ""
}

# Verify installations
Write-Host ""
Write-Host "[*] Verifying installations..." -ForegroundColor Blue
Write-Host ""

# Final status
Write-Host ""
if ($failedInstalls.Count -eq 0) {
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "         INSTALLATION COMPLETE!" -ForegroundColor Green
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  [+] All components installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "  NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "  -----------" -ForegroundColor DarkGray
    Write-Host "  1. Close this PowerShell window" -ForegroundColor Cyan
    Write-Host "  2. Open a NEW PowerShell window" -ForegroundColor Cyan
    Write-Host "  3. Verify installation with:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "     java --version" -ForegroundColor Green
    Write-Host "     gradle -v" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "===================================================" -ForegroundColor Yellow
    Write-Host "         PARTIAL INSTALLATION" -ForegroundColor Yellow
    Write-Host "===================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [!] Some components failed to install:" -ForegroundColor Red
    foreach ($f in $failedInstalls) {
        Write-Host "      [-] $($dependencies[$f].displayName)" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "  Try running this script again or install manually." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "---------------------------------------------------" -ForegroundColor DarkGray
Write-Host "  Created with <3 by Jacob Chikwanda & GPT-5" -ForegroundColor Magenta
Write-Host "  GitHub: JacobChikwanda/javalin-setup-assistant" -ForegroundColor Blue
Write-Host "---------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Window will close in 10 seconds..." -ForegroundColor DarkGray
Start-Sleep -Seconds 10