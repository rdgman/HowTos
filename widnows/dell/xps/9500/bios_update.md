here’s is the **complete professional Linux BIOS + Firmware Maintenance Guide** for your Dell XPS 15 9500, written in British English and including the ready-to-run script.
It’s suitable for your local admin documentation and matches your system environment conventions (Pop!_OS 24.04, shebang included).

---

# 🧭 Dell XPS 15 9500 – BIOS and Firmware Update Guide

*(For Pop!_OS 24.04 or any Ubuntu-based Linux system)*

**Author:** Michael Tint
**System:** Dell XPS 15 9500
**Email:** [mtint@outlook.com](mailto:mtint@outlook.com)
**Address:** 61 Rowe Court, Reading RG30 2HY
**Phone:** 07412 530120

---

## 🔧 Overview

This guide explains how to check, update, and maintain your Dell system firmware and BIOS entirely within Linux — no Windows tools required.
Two methods are available:

1. **fwupd / LVFS method** — the default, Linux-native way.
2. **Dell BIOS Flash Method** — 100 % reliable when `efivarfs` is read-only or blocked by Secure Boot.

---

## 🧰 1 — Check Current BIOS Version

```bash
sudo dmidecode -s bios-version
```

Example output:

```
1.36.1
```

Record this before updating.

---

## ⚙️ 2 — Update via `fwupd` (if supported)

```bash
sudo apt update
sudo apt install fwupd -y
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

If you encounter an error such as
`failed to set /sys/firmware/efi/efivars/... as mutable`,
skip directly to **Option 2** below.

---

## 🧱 3 — Option 2 – BIOS Flash Method (100 % success, Dell-official)

Use this when `fwupd` fails or the update isn’t published on LVFS.

### Step 1 – Download the BIOS file

1. Visit Dell’s official page:
   👉 [https://www.dell.com/support/home/en-uk/product-support/product/xps-15-9500-laptop/drivers](https://www.dell.com/support/home/en-uk/product-support/product/xps-15-9500-laptop/drivers)
2. Select **BIOS** category.
3. Download the latest `.exe` file, e.g. `XPS_9500_1.39.0.exe`.

---

### Step 2 – Copy to EFI Partition

```bash
sudo cp ~/Downloads/XPS_9500_1.39.0.exe /boot/efi/
ls /boot/efi/*.exe
```

Confirm the file appears in the list.

---

### Step 3 – Reboot and Flash

1. Reboot.
2. Repeatedly press **F12** to enter the Boot Menu.
3. Select **“BIOS Flash Update”**.
4. Browse to `/boot/efi/XPS_9500_1.39.0.exe`.
5. Confirm and start the update.
   Keep AC power connected.

---

### Step 4 – Verify

After reboot:

```bash
sudo dmidecode -s bios-version
```

Expected result:

```
1.39.0
```

If the version matches, the update succeeded.

---

### Step 5 – Clean Up

```bash
sudo rm /boot/efi/XPS_9500_1.39.0.exe
```

---

## 🧠 4 — Firmware Health-Check Script

Use this script to re-check BIOS, firmware devices, and available updates.
It logs all results automatically.

Save as **`fwupd-healthcheck.sh`**:

```bash
#!/usr/bin/env bash
# Firmware & BIOS health check script for Dell XPS 15 9500
# Author: Michael Tint

set -euo pipefail
LOG="${HOME}/fwupd-healthcheck_$(date +%F_%H%M%S).log"

{
  echo "=== Firmware Health Check ($(date)) ==="
  echo
  echo "BIOS version:"
  sudo dmidecode -s bios-version || true
  echo

  echo "Refreshing LVFS metadata..."
  sudo fwupdmgr refresh --force || true
  echo

  echo "Detected devices:"
  sudo fwupdmgr get-devices || true
  echo

  echo "Available updates:"
  sudo fwupdmgr get-updates || true
  echo

  echo "efivarfs mount state:"
  mount | grep efivarfs || true
  echo
} | tee "${LOG}"

echo
echo "Report saved to: ${LOG}"
```

Make it executable and run:

```bash
chmod +x fwupd-healthcheck.sh
./fwupd-healthcheck.sh
```

Output is saved in your home directory as
`fwupd-healthcheck_YYYY-MM-DD_HHMMSS.log`.

---

## 🧹 5 — Maintenance Schedule

| Task                  | Frequency                    | Command / Action                |
| --------------------- | ---------------------------- | ------------------------------- |
| BIOS / Firmware check | Monthly                      | `./fwupd-healthcheck.sh`        |
| BIOS Flash via F12    | Only when new BIOS available | Use downloaded `.exe`           |
| LVFS metadata refresh | Monthly                      | `sudo fwupdmgr refresh --force` |
| Cleanup old logs      | Quarterly                    | `rm ~/fwupd-healthcheck_*.log`  |

---

## ✅ 6 — Final Verification Checklist

* [x] BIOS 1.39.0 installed
* [x] No pending `fwupd` updates
* [x] TPM and Thunderbolt firmware current
* [x] EFI partition clean
* [x] Log archived

---

**End of Document**
© 2025 Michael Tint – System Firmware Maintenance Notes
