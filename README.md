# ☕ **Javalin Setup Assistant**

> **The easiest way to install Java + Gradle for Javalin development** 🚀  
> Made with ❤️ by Jacob Chikwanda & GPT-5

---

## 🎯 **What is this?**

A friendly script that automatically installs everything you need to build Java web apps with Javalin. Perfect for students, beginners, and anyone who wants a quick setup!

**✨ Features:**
- 🔍 Auto-detects what's already installed
- 📦 Installs only what you're missing
- 🎨 Colorful, friendly interface with emojis
- ⚡ Takes less than 5 minutes
- 🛡️ Safe and reversible

---

## 📋 **What Gets Installed**

| Tool | Purpose | Size |
|------|---------|------|
| ☕ **Java (OpenJDK 17)** | Runs Java programs | ~250 MB |
| 🐘 **Gradle** | Builds & manages projects | ~200 MB |
| 🍫 **Chocolatey** *(Windows only)* | Package manager | ~50 MB |

**Total space needed:** ~500 MB  
**Time required:** 3-5 minutes with good internet

---

## 📖 **Detailed Installation Guide**

<details>
<summary><b>🪟 Windows - Step by Step with Screenshots</b></summary>

### Step 1: Open PowerShell as Administrator

<table>
<tr>
<td width="50%">

**Method A: Quick Access**
1. Press `Windows + X`
2. Select **Windows PowerShell (Admin)**

</td>
<td width="50%">

**Method B: Start Menu**
1. Click Start 🪟
2. Type "PowerShell"
3. Right-click → **Run as Administrator**

</td>
</tr>
</table>

> 💡 **Tip:** You'll see a blue window with white text - that's PowerShell!

### Step 2: Run the Installation

Copy this entire command:
```powershell
Start-Process powershell -ArgumentList "-NoExit", "-Command", "iwr -useb https://raw.githubusercontent.com/JacobChikwanda/javalin-setup-assistant/main/install-javalin-env.ps1 | iex" -Verb RunAs
```

**To paste in PowerShell:** Right-click anywhere in the window

### Step 3: Watch the Installation

You'll see:
- ✅ Green checkmarks for installed tools
- ❌ Red X's for missing tools
- ⏳ A 10-second countdown before installation starts
- 🎉 Success message when complete!

### Step 4: Verify Installation

After restarting PowerShell, run:
```powershell
java --version
gradle -v
```

Both should show version numbers!

</details>

<details>
<summary><b>🐧 Linux - Step by Step Guide</b></summary>

### Supported Distributions

✅ **Tested on:**
- Ubuntu / Debian (apt)
- Fedora / CentOS / RHEL (dnf/yum)
- Arch Linux (pacman)

### Step 1: Open Terminal

- **Ubuntu/Debian:** `Ctrl + Alt + T`
- **Fedora:** `Super + Enter`
- **Or:** Search for "Terminal" in your apps

### Step 2: Run Installation

**Standard method (most systems):**
```bash
curl -fsSL https://raw.githubusercontent.com/JacobChikwanda/javalin-setup-assistant/main/install-javalin-env.sh | sudo bash
```

**If you get "curl: command not found":**
```bash
wget -qO- https://raw.githubusercontent.com/JacobChikwanda/javalin-setup-assistant/main/install-javalin-env.sh | sudo bash
```

### Step 3: Enter Your Password

When prompted for `[sudo] password:`, type your login password.  
> 💡 **Note:** You won't see dots or asterisks - that's normal!

### Step 4: Verify Installation

```bash
java --version
gradle -v
```

You should see version information for both!

</details>

---

## 🎓 **After Installation - Build Your First App!**

### 1️⃣ Create a New Javalin Project

```bash
mkdir my-javalin-app
cd my-javalin-app
gradle init --type java-application
```

### 2️⃣ Add Javalin to Your Project

Edit `app/build.gradle` and add:
```gradle
dependencies {
    implementation 'io.javalin:javalin:5.6.3'
}
```

### 3️⃣ Write Your First Server

Replace `app/src/main/java/App.java` with:
```java
import io.javalin.Javalin;

public class App {
    public static void main(String[] args) {
        var app = Javalin.create()
            .get("/", ctx -> ctx.result("Hello Javalin! 🚀"))
            .start(7000);
        
        System.out.println("🎉 Server running at http://localhost:7000");
    }
}
```

### 4️⃣ Run Your App!

```bash
gradle run
```

Visit `http://localhost:7000` in your browser! 🌐

---

## 🔧 **Troubleshooting**

<details>
<summary><b>Common Issues & Solutions</b></summary>

| Problem | Solution |
|---------|----------|
| **"Not recognized as a command"** | Close and reopen your terminal/PowerShell |
| **"Permission denied"** | Make sure you're running as Admin (Windows) or with sudo (Linux) |
| **"Cannot download"** | Check your internet connection and firewall |
| **"Script won't run" (Windows)** | Run this first: `Set-ExecutionPolicy Bypass -Scope Process -Force` |
| **Installation seems frozen** | Some downloads take time - wait 2-3 minutes |
| **Java not found after install** | Restart your terminal and try again |

</details>

<details>
<summary><b>Manual Installation Links</b></summary>

If the script doesn't work, install manually:

**Windows:**
- [Java (OpenJDK)](https://adoptium.net/)
- [Gradle](https://gradle.org/install/)
- [Chocolatey](https://chocolatey.org/install)

**Linux:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-17-jdk gradle

# Fedora
sudo dnf install java-17-openjdk-devel gradle

# Arch
sudo pacman -S jdk17-openjdk gradle
```

</details>

---

## 🤝 **Contributing**

Found a bug? Have an idea? We'd love your help!

- 🐛 [Report Issues](https://github.com/JacobChikwanda/javalin-setup-assistant/issues)
- 🌟 [Star the Project](https://github.com/JacobChikwanda/javalin-setup-assistant)
- 🍴 Fork and submit a PR!

---

## 📜 **License**

MIT License - Use freely for any purpose!

---

## 👨‍💻 **Authors**

Created with ❤️ by:
- **Jacob Chikwanda** - [GitHub](https://github.com/JacobChikwanda)
- **GPT-5** - AI Assistant

**Mission:** Make Java development accessible to students everywhere! 🌍

---

<div align="center">

### 🌟 **If this helped you, give it a star!** 🌟

[![GitHub stars](https://img.shields.io/github/stars/JacobChikwanda/javalin-setup-assistant?style=social)](https://github.com/JacobChikwanda/javalin-setup-assistant)

**Happy Coding!** ☕🚀

</div>