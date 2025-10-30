#!/usr/bin/env bash
# ==============================================================
# ☕ Javalin Setup Assistant (Linux Edition)
# --------------------------------------------------------------
# 👨‍💻 Created by: Jacob Chikwanda & GPT-5
# 🌐 GitHub: https://github.com/jchikwanda/javalin-setup-assistant
# 📘 Purpose: Help students easily install Java + Gradle for Javalin
# ==============================================================

set -e

# --- Display Banner ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BANNER_PATH="$SCRIPT_DIR/assets/banner.txt"

if [ -f "$BANNER_PATH" ]; then
  echo ""
  cat "$BANNER_PATH"
  echo ""
else
  echo ""
  echo "☕ Javalin Setup Assistant by Jacob Chikwanda & GPT-5 ❤️"
  echo ""
fi

echo "👋 Hello, student! This tool will check your system and install Java + Gradle if needed."
echo "Made with ❤️ by Jacob Chikwanda & GPT-5"
echo ""

# --- Require root privileges ---
if [[ "$EUID" -ne 0 ]]; then
  echo "⚠️  Please run this command with sudo:"
  echo "sudo bash install-javalin-env.sh"
  exit 1
fi

MISSING=()

check_command() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "✅ $1 is already installed."
  else
    echo "❌ $1 is missing."
    MISSING+=("$1")
  fi
}

check_command java
check_command gradle

if [ ${#MISSING[@]} -eq 0 ]; then
  echo ""
  echo "🎓 You’re already a pro! Everything you need for Javalin is installed!"
  echo "💚 Script by Jacob Chikwanda & GPT-5"
  exit 0
fi

echo ""
echo "🧩 Missing tools:"
for tool in "${MISSING[@]}"; do
  case "$tool" in
    java) echo "🔹 Java (OpenJDK) — lets your computer run Java programs." ;;
    gradle) echo "🔹 Gradle — builds and runs your Javalin projects." ;;
  esac
done

echo ""
echo "💾 Estimated total download size: ~450 MB"
read -p "Do you want to install them now? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Setup cancelled. Run this script later to continue."
  exit 0
fi

echo ""
echo "🚀 Starting installation..."
apt update -y

for tool in "${MISSING[@]}"; do
  echo ""
  echo "⬇️ Installing $tool..."
  for i in {1..10}; do
    echo -ne "Progress: $((i*10))%...\r"
    sleep 0.2
  done

  case "$tool" in
    java) apt install -y openjdk-17-jdk ;;
    gradle) apt install -y gradle ;;
  esac
done

echo ""
echo "✅ All done!"
echo "Restart your terminal and check:"
echo "   java --version"
echo "   gradle -v"
echo ""
echo "🎓 Created with ❤️ by Jacob Chikwanda & GPT-5"
