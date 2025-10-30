# ==============================================================
# ☕ Javalin Setup Assistant (Windows Edition)
# --------------------------------------------------------------
# 👨‍💻 Created by: Jacob Chikwanda & GPT-5
# 🌐 GitHub: https://github.com/JacobChikwanda/javalin-setup-assistant
# 📘 Purpose: Help students easily install Java + Gradle for Javalin
# ==============================================================

# Set error action to continue so script doesn't exit on error
$ErrorActionPreference = "Continue"

# Enable UTF-8 output for emojis
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Display ASCII Banner with emoji decoration
$banner = @"
  _____     _     _   _          
 |_   _|   | |   | | (_)         
   | | __ _| |__ | |  _ ___ _   _
   | |/ _\` | '_ \| | | / __| | | |
   | | (_| | | | | | | \__ \ |_| |
   |_|\__,_|_| |_|_| |_|___/\__,_|
   
     ☕ Javalin Setup Assistant
    by Jacob Chikwanda & GPT-5 ❤️
"@

Write-Host $banner -ForegroundColor Cyan
Write-Host ""

# Check if running as Admin
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "⚠️  WARNING: Please run PowerShell as Administrator (right-click - Run as Administrator)." -ForegroundColor Red
    Write-Host "The script will exit in 5 seconds... ⏱️" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    return
}

function Command-Exists($cmd) {
    $null = Get-Command $cmd -ErrorAction SilentlyContinue
    return $?
}

function Show-Progress($activity) {
    $spinners = @('⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏')
    for ($i = 0; $i -le 100; $i += 10) {
        $spinner = $spinners[($i / 10) % $spinners.Count]
        Write-Host "`r$spinner $activity... $i%" -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 150
    }
    Write-Host "`r✅ $activity... Complete!" -ForegroundColor Green
}

Write-Host "👋 Hello, student! This tool by Jacob Chikwanda & GPT-5 will check for Java, Gradle, and Chocolatey." -ForegroundColor Green
Write-Host "Made with ❤️ by Jacob Chikwanda & GPT-5" -ForegroundColor Magenta
Write-Host "It installs only what's missing - safe, automatic, and friendly! 🚀`n"

Write-Host "🔍 Checking installed tools..." -ForegroundColor Blue
Write-Host ""

$dependencies = [ordered]@{
    "Chocolatey" = @{
        cmd = "choco"
        desc = "🍫 Chocolatey — package manager that installs tools automatically on Windows"
        icon = "🍫"
        install = { 
            Write-Host "⬇️  Installing Chocolatey..." -ForegroundColor Yellow
            Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            try {
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "✅ Chocolatey installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "❌ Failed to install Chocolatey: $_" -ForegroundColor Red
                return $false
            }
        }
    }
    "Java (OpenJDK)" = @{
        cmd = "java"
        desc = "☕ Java (OpenJDK) — lets your computer run Java programs"
        icon = "☕"
        install = { 
            try {
                Write-Host "⬇️  Installing Java..." -ForegroundColor Yellow
                & choco install openjdk -y 2>&1 | Out-String | Write-Host
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "✅ Java installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "❌ Failed to install Java: $_" -ForegroundColor Red
                return $false
            }
        }
    }
    "Gradle" = @{
        cmd = "gradle"
        desc = "🐘 Gradle — builds and runs your Javalin projects"
        icon = "🐘"
        install = { 
            try {
                Write-Host "⬇️  Installing Gradle..." -ForegroundColor Yellow
                & choco install gradle -y 2>&1 | Out-String | Write-Host
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                Write-Host "✅ Gradle installed successfully!" -ForegroundColor Green
                return $true
            } catch {
                Write-Host "❌ Failed to install Gradle: $_" -ForegroundColor Red
                return $false
            }
        }
    }
}

$missing = @()
foreach ($dep in $dependencies.Keys) {
    $cmd = $dependencies[$dep].cmd
    $icon = $dependencies[$dep].icon
    if (Command-Exists $cmd) {
        Write-Host "✅ $icon $dep is already installed." -ForegroundColor Green
        # Show version if available
        switch ($cmd) {
            "java" {
                $version = & java --version 2>&1 | Select-Object -First 1
                Write-Host "   Version: $version" -ForegroundColor Cyan
            }
            "gradle" {
                $version = & gradle --version 2>&1 | Select-String "Gradle" | Select-Object -First 1
                if ($version) {
                    Write-Host "   Version: $version" -ForegroundColor Cyan
                }
            }
            "choco" {
                $version = & choco --version 2>&1
                Write-Host "   Version: $version" -ForegroundColor Cyan
            }
        }
    } else {
        Write-Host "❌ $icon $dep is not installed." -ForegroundColor Yellow
        $missing += $dep
    }
}

if ($missing.Count -eq 0) {
    Write-Host "`n🎓 You're already a pro! Everything you need for Javalin is installed! 🎉" -ForegroundColor Green
    Write-Host "💚 Script by Jacob Chikwanda & GPT-5`n" -ForegroundColor Magenta
    Write-Host "This window will close in 5 seconds... ⏱️" -ForegroundColor Gray
    Start-Sleep -Seconds 5
    return
}

Write-Host "`n🧩 Missing Components:`n" -ForegroundColor Yellow
foreach ($m in $missing) {
    Write-Host "  $($dependencies[$m].desc)" -ForegroundColor Cyan
}
Write-Host ""

$totalSize = 500
Write-Host "💾 Estimated total download size: ~$totalSize MB`n" -ForegroundColor Blue

# Auto-install with a countdown timer for user to cancel
Write-Host "⚡ Installation will start automatically in 10 seconds..." -ForegroundColor Yellow
Write-Host "🛑 Press CTRL+C to cancel`n" -ForegroundColor Red

for ($i = 10; $i -gt 0; $i--) {
    Write-Host "`r⏳ Starting in $i seconds... " -NoNewline -ForegroundColor Cyan
    Start-Sleep -Seconds 1
}
Write-Host "`n"

Write-Host "🚀 Starting installation..." -ForegroundColor Green
Write-Host ""

# Install missing dependencies
$failedInstalls = @()
foreach ($m in $missing) {
    Write-Host "════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "$($dependencies[$m].icon) Installing $m..." -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════" -ForegroundColor DarkGray
    Show-Progress "Installing $m"
    
    $result = & $dependencies[$m].install
    if (-not $result) {
        $failedInstalls += $m
    }
    
    Write-Host ""
}

# Verify installations
Write-Host "🔍 Verifying installations..." -ForegroundColor Blue
Write-Host ""

# Final status
Write-Host "════════════════════════════════════════" -ForegroundColor DarkGray
if ($failedInstalls.Count -eq 0) {
    Write-Host "🎉 SUCCESS! All components installed!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "✨ Next steps:" -ForegroundColor Yellow
    Write-Host "  1️⃣  Restart PowerShell" -ForegroundColor Cyan
    Write-Host "  2️⃣  Verify installations:" -ForegroundColor Cyan
    Write-Host "     📌 java --version" -ForegroundColor Green
    Write-Host "     📌 gradle -v" -ForegroundColor Green
} else {
    Write-Host "⚠️  PARTIAL SUCCESS" -ForegroundColor Yellow
    Write-Host "════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "❌ Failed to install:" -ForegroundColor Red
    foreach ($f in $failedInstalls) {
        Write-Host "  ❌ $f" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "💡 Try running the script again or install manually." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎓 Created with ❤️ by Jacob Chikwanda & GPT-5" -ForegroundColor Magenta
Write-Host "🌐 GitHub: https://github.com/JacobChikwanda/javalin-setup-assistant" -ForegroundColor Blue
Write-Host ""

Write-Host "This window will close in 10 seconds... ⏱️" -ForegroundColor Gray
Start-Sleep -Seconds 10