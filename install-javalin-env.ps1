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
            Write-Host "    [>] Installing Chocolatey..." -ForegroundColor Yellow
            Write-Host "    NOTE: This installation will be silent (no output)" -ForegroundColor DarkGray
            Write-Host ""
            
            Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            
            try {
                # Show progress dots during silent Chocolatey install
                $job = Start-Job -ScriptBlock {
                    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                }
                
                Write-Host -NoNewline "    Installing"
                while ($job.State -eq 'Running') {
                    Write-Host -NoNewline "." -ForegroundColor Cyan
                    Start-Sleep -Seconds 2
                }
                Write-Host ""
                
                Receive-Job -Job $job
                Remove-Job -Job $job
                
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                
                if (Command-Exists "choco") {
                    Write-Host "    [+] Chocolatey installed successfully!" -ForegroundColor Green
                    return $true
                } else {
                    Write-Host "    [-] Chocolatey installation may have failed" -ForegroundColor Red
                    return $false
                }
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
        chocoPackage = "openjdk"
        install = { 
            try {
                Write-Host "    [>] Starting Java installation..." -ForegroundColor Yellow
                Write-Host "    This will show live progress from Chocolatey:" -ForegroundColor DarkGray
                Write-Host ""
                
                # Run choco install with real-time output
                $pinfo = New-Object System.Diagnostics.ProcessStartInfo
                $pinfo.FileName = "choco"
                $pinfo.RedirectStandardOutput = $false
                $pinfo.RedirectStandardError = $false
                $pinfo.UseShellExecute = $false
                $pinfo.Arguments = "install openjdk -y --no-progress"
                
                $p = New-Object System.Diagnostics.Process
                $p.StartInfo = $pinfo
                $p.Start() | Out-Null
                $p.WaitForExit()
                
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                
                if ($p.ExitCode -eq 0) {
                    Write-Host ""
                    Write-Host "    [+] Java installed successfully!" -ForegroundColor Green
                    return $true
                } else {
                    Write-Host "    [-] Java installation failed with exit code: $($p.ExitCode)" -ForegroundColor Red
                    return $false
                }
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
        chocoPackage = "gradle"
        install = { 
            try {
                Write-Host "    [>] Starting Gradle installation..." -ForegroundColor Yellow
                Write-Host "    This will show live progress from Chocolatey:" -ForegroundColor DarkGray
                Write-Host ""
                
                # Run choco install with real-time output
                $pinfo = New-Object System.Diagnostics.ProcessStartInfo
                $pinfo.FileName = "choco"
                $pinfo.RedirectStandardOutput = $false
                $pinfo.RedirectStandardError = $false
                $pinfo.UseShellExecute = $false
                $pinfo.Arguments = "install gradle -y --no-progress"
                
                $p = New-Object System.Diagnostics.Process
                $p.StartInfo = $pinfo
                $p.Start() | Out-Null
                $p.WaitForExit()
                
                # Refresh PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                
                if ($p.ExitCode -eq 0) {
                    Write-Host ""
                    Write-Host "    [+] Gradle installed successfully!" -ForegroundColor Green
                    return $true
                } else {
                    Write-Host "    [-] Gradle installation failed with exit code: $($p.ExitCode)" -ForegroundColor Red
                    return $false
                }
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
Write-Host "[i] Installation will show LIVE progress - you'll see everything!" -ForegroundColor Blue
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

$verifyFailed = @()
foreach ($m in $missing) {
    $cmd = $dependencies[$m].cmd
    $displayName = $dependencies[$m].displayName
    
    Write-Host -NoNewline "    Checking $displayName... "
    
    # Refresh PATH one more time
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    if (Command-Exists $cmd) {
        Write-Host "[OK]" -ForegroundColor Green
        
        # Show installed version
        switch ($cmd) {
            "java" {
                $version = & java --version 2>&1 | Select-Object -First 1
                Write-Host "       Installed version: $version" -ForegroundColor DarkGray
            }
            "gradle" {
                $version = & gradle --version 2>&1 | Select-String "Gradle" | Select-Object -First 1
                if ($version) {
                    Write-Host "       Installed version: $version" -ForegroundColor DarkGray
                }
            }
        }
    } else {
        Write-Host "[FAILED]" -ForegroundColor Red
        $verifyFailed += $displayName
    }
}

# Final status
Write-Host ""
if ($verifyFailed.Count -eq 0) {
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "         INSTALLATION COMPLETE!" -ForegroundColor Green
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  [+] All components installed and verified!" -ForegroundColor Green
    Write-Host ""
    Write-Host "  NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "  -----------" -ForegroundColor DarkGray
    Write-Host "  1. Close this PowerShell window" -ForegroundColor Cyan
    Write-Host "  2. Open a NEW PowerShell window" -ForegroundColor Cyan
    Write-Host "  3. Test your installation:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "     java --version" -ForegroundColor Green
    Write-Host "     gradle -v" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "===================================================" -ForegroundColor Yellow
    Write-Host "         INSTALLATION NEEDS ATTENTION" -ForegroundColor Yellow
    Write-Host "===================================================" -ForegroundColor Yellow
    Write-Host ""
    
    if ($failedInstalls.Count -gt 0) {
        Write-Host "  [!] Failed to install:" -ForegroundColor Red
        foreach ($f in $failedInstalls) {
            Write-Host "      [-] $($dependencies[$f].displayName)" -ForegroundColor Red
        }
    }
    
    if ($verifyFailed.Count -gt 0) {
        Write-Host "  [!] Installed but not found in PATH:" -ForegroundColor Yellow
        foreach ($v in $verifyFailed) {
            Write-Host "      [?] $v" -ForegroundColor Yellow
        }
        Write-Host ""
        Write-Host "  TIP: Close ALL PowerShell windows and open a new one," -ForegroundColor Cyan
        Write-Host "       then check if the commands work." -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "  If problems persist, try:" -ForegroundColor Yellow
    Write-Host "  1. Restart your computer" -ForegroundColor White
    Write-Host "  2. Run this script again" -ForegroundColor White
    Write-Host "  3. Install manually from chocolatey.org" -ForegroundColor White
    Write-Host ""
}

Write-Host "---------------------------------------------------" -ForegroundColor DarkGray
Write-Host "  Created with <3 by Jacob Chikwanda & GPT-5" -ForegroundColor Magenta
Write-Host "  GitHub: JacobChikwanda/javalin-setup-assistant" -ForegroundColor Blue
Write-Host "---------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Window will close in 15 seconds..." -ForegroundColor DarkGray
Write-Host "(or press any key to exit now)" -ForegroundColor DarkGray

$counter = 0
while ($counter -lt 150 -and -not [Console]::KeyAvailable) {
    Start-Sleep -Milliseconds 100
    $counter++
}

if ([Console]::KeyAvailable) {
    $null = [Console]::ReadKey($true)
}