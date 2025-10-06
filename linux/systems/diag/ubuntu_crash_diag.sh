#!/bin/bash

# =============================================================================
# 📄 Ubuntu Crash Diagnostic Script
# =============================================================================
# This script automates the process of diagnosing system crashes on Ubuntu.
# It collects logs, scans for errors, checks system health indicators, and
# saves everything to a timestamped log file for review or sharing.
#
# 🧰 Features:
# - Retrieves logs from the previous boot using journalctl
# - Lists crash reports from /var/crash
# - Scans system logs (syslog, kern.log, auth.log) for errors
# - Displays GUI-related errors from .xsession-errors
# - Lists recent boot sessions
# - Searches for kernel panics, segmentation faults, and OOM killer events
# - Optionally checks CPU temperature (if lm-sensors is installed)
# - Saves all output to a timestamped log file
#
# 📦 Requirements:
# - Ubuntu or Debian-based system
# - Bash shell
# - Optional: lm-sensors for temperature checks
#   Install with: sudo apt install lm-sensors
#
# 🚀 Usage:
# 1. Save this script as ubuntu_crash_diag.sh
# 2. Make it executable: chmod +x ubuntu_crash_diag.sh
# 3. Run it: ./ubuntu_crash_diag.sh
#
# 🔐 Security Notes:
# - Reads system logs and user-specific files
# - Does not modify system state
# - For full access, consider running with sudo
#
# =============================================================================

LOGFILE="ubuntu_crash_diag_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "🔍 Ubuntu Crash Diagnostic Script"
echo "================================="
echo "📅 Date: $(date)"
echo "🖥️ Hostname: $(hostname)"
echo "👤 User: $(whoami)"
echo "📁 Log File: $LOGFILE"

# 1. Journal from previous boot
echo -e "\n📘 Journal from previous boot:"
journalctl -b -1 --no-pager | tail -n 100

# 2. Crash reports
echo -e "\n💥 Crash reports in /var/crash:"
ls -lh /var/crash

# 3. System log errors
echo -e "\n🧾 Errors in syslog:"
grep -i error /var/log/syslog | tail -n 20

echo -e "\n🧾 Errors in kern.log:"
grep -i error /var/log/kern.log | tail -n 20

echo -e "\n🔐 Authentication issues:"
grep -i fail /var/log/auth.log | tail -n 20

# 4. X session errors
echo -e "\n🖥️ X session errors:"
if [ -f ~/.xsession-errors ]; then
    tail -n 20 ~/.xsession-errors
else
    echo "No ~/.xsession-errors file found."
fi

# 5. Boot history
echo -e "\n🕰️ Recent boot sessions:"
journalctl --list-boots | tail -n 3

# 6. Kernel panic / segfault / OOM killer
echo -e "\n🚨 Kernel panic / segfault / OOM killer:"
grep -Ei 'panic|segfault|oom-killer' /var/log/syslog | tail -n 20

# 7. CPU temperature
echo -e "\n🌡️ CPU temperature:"
if command -v sensors &> /dev/null; then
    sensors
else
    echo "lm-sensors not installed. Run: sudo apt install lm-sensors"
fi

echo -e "\n✅ Diagnostic complete. Review $LOGFILE for full details."
