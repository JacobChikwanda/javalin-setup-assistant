#!/usr/bin/env bash
# ==============================================================
# Javalin Setup Assistant (Linux Edition)
# Created by: Jacob Chikwanda & GPT-5
# GitHub: https://github.com/JacobChikwanda/javalin-setup-assistant
# Purpose: Help students easily install Java + Gradle for Javalin
# ==============================================================

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Display Banner
display_banner() {
    echo -e "${CYAN}"
    cat << "EOF"

     _______________________________________________
    |                                               |
    |        JAVALIN SETUP ASSISTANT                |
    |        ========================                |
    |                                               |
    |     Your friendly Java + Gradle installer     |
    |         by Jacob Chikwanda & GPT-5            |
    |_______________________________________________|

EOF
    echo -e "${NC}"
}

display_banner

echo -e "${GREEN}>> Welcome, student!${NC}"
echo -e "   This tool will check for Java and Gradle on your system"
echo -e "   and install only what's missing."
echo ""
echo -e "${MAGENTA}   Made with <3 by Jacob Chikwanda & GPT-5${NC}"
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_LIKE=$ID_LIKE
    else
        echo -e "${RED}[!] Cannot detect Linux distribution${NC}"
        exit 1
    fi
else
    echo -e "${RED}[!] This script is designed for Linux systems only${NC}"
    exit 1
fi

# Require root privileges
if [[ "$EUID" -ne 0 ]]; then
  echo -e "${YELLOW}[!] Administrator privileges required${NC}"
  echo -e "${CYAN}    Please run with sudo:${NC}"
  echo ""
  echo -e "${GREEN}    curl -fsSL https://raw.githubusercontent.com/JacobChikwanda/javalin-setup-assistant/main/install-javalin-env.sh | sudo bash${NC}"
  echo -e "${WHITE}    or${NC}"
  echo -e "${GREEN}    wget -qO- https://raw.githubusercontent.com/JacobChikwanda/javalin-setup-assistant/main/install-javalin-env.sh | sudo bash${NC}"
  echo ""
  exit 1
fi

MISSING=()

check_command() {
  echo -n "  "
  if command -v "$1" >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} $2 is installed"
    # Check version if installed
    case "$1" in
      java)
        VERSION=$(java -version 2>&1 | head -n 1)
        echo -e "${GRAY}       Version: $VERSION${NC}"
        ;;
      gradle)
        VERSION=$(gradle --version 2>/dev/null | grep "Gradle" | head -n 1)
        echo -e "${GRAY}       Version: $VERSION${NC}"
        ;;
    esac
  else
    echo -e "${YELLOW}[--]${NC} $2 is NOT installed"
    MISSING+=("$1")
  fi
}

echo -e "${BLUE}[*] Scanning your system...${NC}"
echo ""
check_command java "Java (OpenJDK)"
check_command gradle "Gradle"
echo ""

if [ ${#MISSING[@]} -eq 0 ]; then
  echo -e "${GREEN}===================================================${NC}"
  echo -e "${GREEN}  SUCCESS! Everything is already installed!${NC}"
  echo -e "${GREEN}===================================================${NC}"
  echo ""
  echo -e "${CYAN}  You're ready to build Javalin applications!${NC}"
  echo ""
  echo -e "${MAGENTA}  Script by Jacob Chikwanda & GPT-5${NC}"
  echo ""
  exit 0
fi

echo -e "${YELLOW}[!] Missing Components:${NC}"
echo ""
for tool in "${MISSING[@]}"; do
  case "$tool" in
    java) 
      echo -e "${CYAN}    * Java (OpenJDK)${NC}"
      echo -e "      The Java runtime - lets your computer run Java programs"
      ;;
    gradle) 
      echo -e "${CYAN}    * Gradle${NC}"
      echo -e "      Build tool that compiles and runs your Javalin projects"
      ;;
  esac
done

echo ""
echo -e "${BLUE}[i] Estimated download size: ~450 MB${NC}"
echo ""

# Auto-install with countdown for cancellation
echo -e "${YELLOW}[>] Installation will start automatically in 10 seconds...${NC}"
echo -e "${RED}    Press CTRL+C to cancel${NC}"
echo ""

for i in {10..1}; do
    dots=$(printf '.%.0s' $(seq 1 $((11-i))))
    echo -ne "${CYAN}    Starting in $i seconds$dots    \r${NC}"
    sleep 1
done
echo -ne "\033[K\r"

echo -e "${CYAN}===================================================${NC}"
echo -e "${CYAN}  STARTING INSTALLATION${NC}"
echo -e "${CYAN}===================================================${NC}"
echo ""

# Function to show progress
show_progress() {
    local duration=$1
    local steps=20
    local sleep_time=$(echo "scale=2; $duration / $steps" | bc)
    
    echo -n "    ["
    for ((i=0; i<$steps; i++)); do
        echo -n "#"
        sleep $sleep_time
    done
    echo "] 100% - Complete!"
}

# Function to install packages based on distribution
install_packages() {
    local pkg_manager=""
    local java_pkg=""
    local gradle_pkg=""
    
    # Determine package manager and package names
    if [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]] || [[ "$OS_LIKE" == *"debian"* ]]; then
        pkg_manager="apt"
        java_pkg="openjdk-17-jdk"
        gradle_pkg="gradle"
        echo -e "${BLUE}[i] Using APT package manager (Debian/Ubuntu)${NC}"
        echo -e "${GRAY}    Updating package lists...${NC}"
        apt update -y 2>&1 | tail -3
    elif [[ "$OS" == "fedora" ]] || [[ "$OS" == "centos" ]] || [[ "$OS" == "rhel" ]] || [[ "$OS_LIKE" == *"fedora"* ]] || [[ "$OS_LIKE" == *"rhel"* ]]; then
        pkg_manager="dnf"
        java_pkg="java-17-openjdk-devel"
        gradle_pkg="gradle"
        echo -e "${BLUE}[i] Using DNF package manager (Fedora/RHEL/CentOS)${NC}"
        dnf check-update -y 2>&1 | tail -3
    elif [[ "$OS" == "arch" ]] || [[ "$OS_LIKE" == *"arch"* ]]; then
        pkg_manager="pacman"
        java_pkg="jdk17-openjdk"
        gradle_pkg="gradle"
        echo -e "${BLUE}[i] Using Pacman package manager (Arch)${NC}"
        pacman -Sy --noconfirm 2>&1 | tail -3
    elif command -v yum >/dev/null 2>&1; then
        pkg_manager="yum"
        java_pkg="java-17-openjdk-devel"
        gradle_pkg="gradle"
        echo -e "${BLUE}[i] Using YUM package manager${NC}"
        yum check-update -y 2>&1 | tail -3
    else
        echo -e "${RED}[!] Unsupported Linux distribution: $OS${NC}"
        echo -e "${YELLOW}    Please install Java and Gradle manually:${NC}"
        echo "    - Java: OpenJDK 17 or later"
        echo "    - Gradle: Latest version"
        exit 1
    fi
    
    echo ""
    
    local install_count=0
    local total_missing=${#MISSING[@]}
    
    for tool in "${MISSING[@]}"; do
        install_count=$((install_count + 1))
        echo -e "${WHITE}[Step $install_count of $total_missing] Installing $tool${NC}"
        echo "---------------------------------------------------"
        
        case "$tool" in
            java)
                echo -e "${YELLOW}    [>] Downloading and installing Java...${NC}"
                if [[ "$pkg_manager" == "apt" ]]; then
                    apt install -y $java_pkg > /dev/null 2>&1 &
                    show_progress 3
                elif [[ "$pkg_manager" == "dnf" ]]; then
                    dnf install -y $java_pkg > /dev/null 2>&1 &
                    show_progress 3
                elif [[ "$pkg_manager" == "yum" ]]; then
                    yum install -y $java_pkg > /dev/null 2>&1 &
                    show_progress 3
                elif [[ "$pkg_manager" == "pacman" ]]; then
                    pacman -S --noconfirm $java_pkg > /dev/null 2>&1 &
                    show_progress 3
                fi
                wait
                echo -e "${GREEN}    [+] Java installed successfully!${NC}"
                ;;
            gradle)
                echo -e "${YELLOW}    [>] Downloading and installing Gradle...${NC}"
                if [[ "$pkg_manager" == "apt" ]]; then
                    apt install -y $gradle_pkg > /dev/null 2>&1 &
                    show_progress 3
                elif [[ "$pkg_manager" == "dnf" ]]; then
                    dnf install -y $gradle_pkg > /dev/null 2>&1 &
                    show_progress 3
                elif [[ "$pkg_manager" == "yum" ]]; then
                    yum install -y $gradle_pkg > /dev/null 2>&1 &
                    show_progress 3
                elif [[ "$pkg_manager" == "pacman" ]]; then
                    pacman -S --noconfirm $gradle_pkg > /dev/null 2>&1 &
                    show_progress 3
                fi
                wait
                echo -e "${GREEN}    [+] Gradle installed successfully!${NC}"
                ;;
        esac
        echo ""
    done
}

# Run installation
install_packages

# Verify installations
echo -e "${BLUE}[*] Verifying installations...${NC}"
echo ""

FAILED=()
if command -v java >/dev/null 2>&1; then
    echo -e "${GREEN}    [+] Java is ready!${NC}"
    java -version 2>&1 | head -n 1 | sed 's/^/        /'
else
    echo -e "${RED}    [-] Java installation may have failed${NC}"
    FAILED+=("Java")
fi

if command -v gradle >/dev/null 2>&1; then
    echo -e "${GREEN}    [+] Gradle is ready!${NC}"
    gradle --version 2>/dev/null | grep "Gradle" | head -n 1 | sed 's/^/        /'
else
    echo -e "${RED}    [-] Gradle installation may have failed${NC}"
    FAILED+=("Gradle")
fi

echo ""
if [ ${#FAILED[@]} -eq 0 ]; then
    echo -e "${GREEN}===================================================${NC}"
    echo -e "${GREEN}         INSTALLATION COMPLETE!${NC}"
    echo -e "${GREEN}===================================================${NC}"
    echo ""
    echo -e "${GREEN}  [+] All components installed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}  NEXT STEPS:${NC}"
    echo -e "${GRAY}  -----------${NC}"
    echo -e "${CYAN}  1. Open a new terminal window${NC}"
    echo -e "${CYAN}  2. Verify installation with:${NC}"
    echo ""
    echo -e "${GREEN}     java --version${NC}"
    echo -e "${GREEN}     gradle -v${NC}"
    echo ""
else
    echo -e "${YELLOW}===================================================${NC}"
    echo -e "${YELLOW}         PARTIAL INSTALLATION${NC}"
    echo -e "${YELLOW}===================================================${NC}"
    echo ""
    echo -e "${RED}  [!] Some components failed to install:${NC}"
    for tool in "${FAILED[@]}"; do
        echo -e "${RED}      [-] $tool${NC}"
    done
    echo ""
    echo -e "${YELLOW}  Try running this script again or install manually.${NC}"
    echo ""
fi

echo "---------------------------------------------------"
echo -e "${MAGENTA}  Created with <3 by Jacob Chikwanda & GPT-5${NC}"
echo -e "${BLUE}  GitHub: JacobChikwanda/javalin-setup-assistant${NC}"
echo "---------------------------------------------------"
echo ""