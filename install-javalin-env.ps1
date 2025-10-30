<#
==============================================================
☕ Javalin Setup Assistant (Windows Edition)
--------------------------------------------------------------
👨‍💻 Created by: Jacob Chikwanda & GPT-5
🌐 GitHub: https://github.com/JacobChikwanda/javalin-setup-assistant
📘 Purpose: Help students easily install Java + Gradle for Javalin
==============================================================
#>

# --- Display Banner ---
$scriptDir = Split-Path $MyInvocation.MyCommand.Definition -Parent
$bannerPath = Join-Path $scriptDir "assets\banner.txt"

if (Test-Path $bannerPath) {
    Get-Content $bannerPath | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
    Write-Host "`n"
} else {
    Write-Host "☕ Javalin Setup Assistant by Jacob Chikwanda & GPT-5 ❤️`n" -ForegroundColor Cyan
}

# --- Require Admin ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent())
    .IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⚠️  Please run PowerShell as Administrator (right-click → Run as Administrator)." -ForegroundColor Red
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

Write-Host "👋 Hello, student! This tool by Jacob Chikwanda & GPT-5 will check for Java, Gradle, and Chocolatey."
Write-Host "It installs only what’s missing — safe, automatic, and friendly!`n"

$dependencies = @{
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
    "Chocolatey" = @{
        cmd = "choco"
        desc = "Chocolatey installs tools automatically on Windows."
        install = { Write-Host "🍫 Please install Chocolatey manually from https://chocolatey.org/install" -ForegroundColor Yellow }
    }
}

$missing = @()
foreach ($dep in $dependencies.Keys) {
    $cmd = $dependencies[$dep].cmd
    if (Command-Exists $cmd) {
        Write-Host "✅ $dep is already installed."
    } else {
        Write-Host "❌ $dep is missing."
        $missing += $dep
    }
}

if ($missing.Count -eq 0) {
    Write-Host "`n🎓 You’re already a pro! Everything you need for Javalin is installed." -ForegroundColor Green
    Write-Host "💚 Script by Jacob Chikwanda & GPT-5"
    exit
}

Write-Host "`n🧩 Missing Components:`n" -ForegroundColor Yellow
foreach ($m in $missing) {
    Write-Host "🔹 $m — $($dependencies[$m].desc)`n"
}

$totalSize = 500
Write-Host "💾 Estimated total download size: about $totalSize MB.`n"

$confirm = Read-Host "Do you want to start installing now? (y/n)"
if ($confirm -ne "y") {
    Write-Host "❌ Setup cancelled. Run this script again anytime!"
    exit
}

foreach ($m in $missing) {
    Write-Host "`n🚀 Installing $m..." -ForegroundColor Cyan
    Show-Progress "Installing $m"
    & $dependencies[$m].install
}

Write-Host "`n✅ All done! Restart PowerShell and check:" -ForegroundColor Green
Write-Host "   java --version"
Write-Host "   gradle -v"
Write-Host "`n🎓 Created with ❤️ by Jacob Chikwanda & GPT-5"
