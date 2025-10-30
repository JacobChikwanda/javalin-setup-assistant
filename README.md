# ☕ **Javalin Setup Helper**

👋 **Welcome!**
This friendly tool installs everything you need to start coding Java apps with **Javalin**, step by step — even if you’ve never installed software before.

---

## 🌍 What This Will Do

It installs these tools for you:

| 🧩 Tool                       | 💬 What It Does                       | 💾 Space Needed |
| ----------------------------- | ------------------------------------- | --------------- |
| **Java (OpenJDK)**            | Lets your computer run Java programs  | ~250 MB         |
| **Gradle**                    | Builds and runs your Javalin projects | ~200 MB         |
| **Chocolatey (Windows only)** | Helps install software automatically  | ~50 MB          |

---

## 🧠 Before You Start

You’ll need:

* 🌐 Internet connection
* 💽 About **500 MB of space**
* ⏳ A few minutes of patience

After this, you’ll be ready to build your first Javalin app 🚀

---

## 🖥️ What kind of computer are you using?

<details>
<summary>🪟 <b>Windows</b> (Click to expand)</summary>

### Step 1: Open PowerShell as Administrator

1. Click the **Start menu** 🪟
2. Type **PowerShell**
3. Right-click it → choose **Run as Administrator**
   (You’ll see a blue window open — that’s PowerShell.)

### Step 2: Copy and paste this command

*(Copy the whole line — don’t break it!)*

```powershell
iwr -useb https://raw.githubusercontent.com/JacobChikwanda/javalin-setup-assistant/main/install-javalin-env.ps1 | iex
```

### Step 3: Press **Enter** ⏎

The helper will:

* 🕵️ Check what’s already installed
* 🧩 Explain what’s missing
* ⚙️ Install everything automatically

### Step 4: When it says **✅ Done!**

Close PowerShell, open it again, then check:

```powershell
java --version
gradle -v
```

If both show version numbers — 🎉 You’re ready!

</details>

---

<details>
<summary>🐧 <b>Linux</b> (Click to expand)</summary>

### Step 1: Open your Terminal

(Press **Ctrl + Alt + T**)

### Step 2: Copy and paste this command

```bash
curl -fsSL https://raw.githubusercontent.com/JacobChikwanda/javalin-setup-assistant/main/install-javalin-env.sh | sudo bash
```

### Step 3: Press **Enter** ⏎ and type your password 🔑

The helper will automatically:

* 🕵️ Check your system
* 🧩 Install OpenJDK and Gradle
* ✅ Show you when it’s done

### Step 4: Check everything works

```bash
java --version
gradle -v
```

If both show version numbers — 🎉 You’re all set!

</details>

---

## 🎓 What You Just Installed

* 🧠 **Java (OpenJDK)** → The main language your app runs on
* 🛠️ **Gradle** → Builds and runs your Java + Javalin projects
* 📦 **Chocolatey / APT** → The helper that installs software for you

---

## 🌱 Next Step — Make Your First Javalin App

After setup, type this in your terminal:

```bash
gradle init --type java-application
```

Then open the new folder, find `App.java`, and start writing your first Javalin server! ✨

---

## 🧰 If Something Goes Wrong

| ⚠️ Issue            | 💡 Try This                                              |
| ------------------- | -------------------------------------------------------- |
| “Command not found” | Close and reopen your terminal or PowerShell             |
| “Permission denied” | Run with **Administrator** (Windows) or **sudo** (Linux) |
| “Download failed”   | Make sure you’re connected to the internet               |

---

## ❤️ About

Made by **Jacob Chikwanda** and **GPT-5**
to make Java + Javalin setup **easy for students everywhere** 🌍

👉 [Visit the GitHub Repo](https://github.com/jacobchikwanda/javalin-setup-assistant)