here’s a **fully formatted Markdown (`.md`) document** version for XPS 9500

* The BIOS Flash Method (Option 2)
* Your `fwupd-healthcheck.sh` script
* The curated Dell driver and firmware table (from the Dell Support page, cleaned up and Markdown-friendly)

You can save this as **`Dell_XPS15_9500_Firmware_Guide.md`** for documentation or printing to PDF.

---

````markdown
# 🧭 Dell XPS 15 9500 — BIOS and Firmware Maintenance Guide
*(For Pop!_OS 24.04 or any Ubuntu-based Linux system)*  

**Author:** Michael Tint  
**Email:** mtint@outlook.com  
**Address:** 61 Rowe Court, Reading RG30 2HY  
**Phone:** 07412 530120  

---

## 🔧 Overview

This guide explains how to check, update, and maintain the Dell XPS 15 9500 system firmware and BIOS entirely from Linux — no Windows tools required.

Two supported methods:

1. **fwupd / LVFS Method** — preferred, fully Linux-native.  
2. **Dell BIOS Flash Method** — official and 100 % reliable when efivarfs is read-only or Secure Boot-locked.

---

## 🧰 1 — Check Current BIOS Version

```bash
sudo dmidecode -s bios-version
````

Example:

```
1.36.1
```

Record this before performing any update.

---

## ⚙️ 2 — Update via fwupd (if supported)

```bash
sudo apt update
sudo apt install fwupd -y
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

If you see an error such as
`failed to set /sys/firmware/efi/efivars/... as mutable`,
proceed directly to the **Dell BIOS Flash Method** below.

---

## 🧱 3 — Dell BIOS Flash Method (100 % Success – Dell-Official)

Use this approach whenever `fwupd` cannot write to efivarfs or when Dell has not yet published a capsule to LVFS.

### Step 1 – Download the BIOS File

1. Visit the official page:
   👉 [https://www.dell.com/support/home/en-uk/product-support/product/xps-15-9500-laptop/drivers](https://www.dell.com/support/home/en-uk/product-support/product/xps-15-9500-laptop/drivers)
2. Choose **Category → BIOS**
3. Download the latest file (e.g. `XPS_9500_1.39.0.exe`)

---

### Step 2 – Copy the File to the EFI Partition

```bash
sudo cp ~/Downloads/XPS_9500_1.39.0.exe /boot/efi/
ls /boot/efi/*.exe
```

Ensure the file is listed.

---

### Step 3 – Reboot and Flash the BIOS

1. Reboot the system.
2. Repeatedly tap **F12** at the Dell logo.
3. Select **“BIOS Flash Update”**.
4. Browse to `/boot/efi/XPS_9500_1.39.0.exe`.
5. Confirm and start the update.

   > 💡 Keep AC power connected throughout.

---

### Step 4 – Verify the Update

After reboot:

```bash
sudo dmidecode -s bios-version
```

Expected result:

```
1.39.0
```

---

### Step 5 – Clean Up

```bash
sudo rm /boot/efi/XPS_9500_1.39.0.exe
```

---

## 🧠 4 — Firmware Health-Check Script

Save the following script as `fwupd-healthcheck.sh`.

```bash
#!/usr/bin/env bash
# Firmware & BIOS health check for Dell XPS 15 9500
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

**Run it:**

```bash
chmod +x fwupd-healthcheck.sh
./fwupd-healthcheck.sh
```

A full report is saved as
`~/fwupd-healthcheck_YYYY-MM-DD_HHMMSS.log`.

---

## 🧹 5 — Maintenance Schedule

| Task                        | Frequency     | Command / Action                |
| :-------------------------- | :------------ | :------------------------------ |
| Check BIOS / Firmware       | Monthly       | `./fwupd-healthcheck.sh`        |
| Apply new BIOS if available | When released | Use BIOS Flash Update (F12)     |
| Refresh LVFS metadata       | Monthly       | `sudo fwupdmgr refresh --force` |
| Clean old logs              | Quarterly     | `rm ~/fwupd-healthcheck_*.log`  |

---

## ✅ 6 — Verification Checklist

* [x] BIOS 1.39.0 installed
* [x] No pending `fwupd` updates
* [x] TPM & Thunderbolt firmware current
* [x] EFI partition clean
* [x] Health-check log archived

---

## 📦 7 — Dell XPS 15 9500 Driver and Firmware Catalogue (September 2025)

| Category           | Name                                                     | Importance                  | Release Date |             |
| :----------------- | :------------------------------------------------------- | :-------------------------- | :----------- | ----------- |
| BIOS               | Dell XPS 15 9500 System BIOS                             | **Critical**                | 16 Sep 2025  |             |
| Chipset            | Intel Thunderbolt Controller Firmware Update Utility     | Critical                    | 10 Mar 2025  |             |
| Chipset            | Intel Chipset Device Software                            | Critical                    | 03 Dec 2024  |             |
| Chipset            | Intel Dynamic Tuning Driver                              | Critical                    | 15 Jun 2022  |             |
| Network            | Intel Killer 1750/1690/1675/1650 Wi-Fi Controller Driver | Critical                    | 15 Apr 2025  |             |
| Video              | Intel UHD Graphics Driver                                | Critical                    | 18 Aug 2025  |             |
| Video              | NVIDIA GeForce GTX 1650 Ti Graphics Driver               | Critical                    | 30 Nov 2021  |             |
| Storage            | Intel Rapid Storage Technology Driver & App              | Critical                    | 14 Feb 2023  |             |
| Storage            | Micron 2300 PCIe NVMe SSD Firmware Update                | Critical                    | 03 Jun 2021  |             |
| Mouse/Keyboard     | ELAN Touchpad Firmware Update Utility                    | Critical                    | 07 Sep 2021  |             |
| Security           | DBUtil Removal Utility (DSA-2020-059)                    | Critical                    | 27 Apr 2020  |             |
| Systems Management | Dell Command                                             | Endpoint Configure (Intune) | Critical     | 24 Apr 2025 |
| Systems Management | Dell Command                                             | Integration Suite (SCCM)    | Critical     | 15 Apr 2025 |
| Trusted Device     | Dell Trusted Device Security                             | Critical                    | 07 Jun 2025  |             |
| Docks/Stands       | Dell Dock WD19/WD22TB4 Firmware Utility                  | Recommended                 | 24 Jun 2025  |             |
| Storage            | Samsung PM9A1 SSD Firmware Update                        | Recommended                 | 31 Jul 2023  |             |
| Storage            | Western Digital SN810 SSD Firmware Update                | Recommended                 | 11 Dec 2023  |             |
| Audio              | Realtek High Definition Audio Driver                     | Recommended                 | 09 Jan 2024  |             |
| Application        | Dell Digital Delivery App                                | Recommended                 | 03 Sep 2025  |             |
| Application        | Dell SupportAssist OS Recovery Plugin                    | Recommended                 | 24 Jul 2025  |             |

*(Excerpt — only the most relevant, Linux-or firmware-related updates shown.
Windows-only driver packages can be safely ignored on Pop!_OS.)*

---

## 🧩 8 — Notes for Linux Users

* Use `fwupd` first for firmware that supports Linux capsule updates.
* Use the **BIOS Flash Update (F12)** method for BIOS, EC, or Thunderbolt firmware `.exe` files.
* Skip Windows-exclusive driver installers unless dual-booting.
* Keep AC power connected during all firmware flashes.

---

## 🏁 End of Document

© 2025 Michael Tint — Dell XPS 15 9500 Firmware Maintenance Notes

```

https://www.dell.com/support/product-details/en-uk/product/xps-15-9500-laptop/drivers

```

