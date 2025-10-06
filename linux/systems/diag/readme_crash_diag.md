Documentation for your **Ubuntu Crash Diagnostic Script**, designed to help users understand its purpose, usage, and each component.

---

# 📄 Ubuntu Crash Diagnostic Script Documentation

## Overview
This script automates the process of diagnosing system crashes on Ubuntu by collecting logs, scanning for errors, and checking system health indicators. It’s especially useful for sysadmins, developers, or support engineers who need a quick snapshot of what went wrong during the last boot.

---

## 🧰 Features
- Retrieves logs from the previous boot using `journalctl`
- Lists crash reports from `/var/crash`
- Scans system logs (`syslog`, `kern.log`, `auth.log`) for errors
- Displays GUI-related errors from `.xsession-errors`
- Lists recent boot sessions
- Searches for kernel panics, segmentation faults, and OOM killer events
- Optionally checks CPU temperature (if `lm-sensors` is installed)
- Saves all output to a timestamped log file for review or sharing

---

## 📦 Requirements
- Ubuntu or Debian-based system
- Bash shell
- Optional: `lm-sensors` for temperature checks
  ```bash
  sudo apt install lm-sensors
  ```

---

## 🚀 Installation & Usage

### 1. Save the Script
Save the following as `ubuntu_crash_diag.sh`:

```bash
# (Insert full script here)
```

### 2. Make It Executable
```bash
chmod +x ubuntu_crash_diag.sh
```

### 3. Run the Script
```bash
./ubuntu_crash_diag.sh
```

### 4. Review the Output
The script creates a log file named like:
```
ubuntu_crash_diag_20251006_1312.log
```
You can open it with:
```bash
less ubuntu_crash_diag_*.log
```

---

## 📂 Output Breakdown

| Section | Description |
|--------|-------------|
| `Journal from previous boot` | Shows last 100 lines from the previous boot session |
| `Crash reports` | Lists any `.crash` files in `/var/crash` |
| `Syslog / Kern.log / Auth.log` | Filters for recent errors and failures |
| `X session errors` | Displays GUI-related issues from `.xsession-errors` |
| `Boot history` | Lists recent boot sessions with timestamps |
| `Kernel panic / segfault / OOM killer` | Searches for critical crash indicators |
| `CPU temperature` | Displays current CPU temps if `lm-sensors` is installed |

---

## 🧪 Troubleshooting Tips
- If no crash reports are found, check if Apport is enabled:
  ```bash
  sudo systemctl status apport
  ```
- If logs are missing, ensure log rotation hasn’t cleared them:
  ```bash
  ls -lh /var/log/
  ```
- For deeper analysis, increase the number of lines retrieved or add more `grep` filters.

---

## 🔐 Security Notes
- This script reads system logs and user-specific files.
- It does not modify system state or require elevated privileges unless accessing protected logs.
- For full access, consider running with `sudo`:
  ```bash
  sudo ./ubuntu_crash_diag.sh
  ```

---

## 📌 Version History
**v1.0** – Initial release with core diagnostics and logging  
**v1.1** – Added temperature check and improved formatting (optional)

---

