Smart move to check Dell’s support site for **other critical updates** (firmware, drivers, etc.), not just BIOS. But you need to be careful — some are Windows-only or require vendor tools, and some are already handled by `fwupd`. Here’s how to approach it safely on Pop!_OS (Linux) and which ones are likely feasible.

---

## 🔍 What kinds of updates you might find on Dell’s site

On the Dell “Drivers & Downloads” page for XPS 15 9500, you’ll typically see:

* System BIOS / firmware (you already deal with that)
* EC (Embedded Controller) firmware updates
* Thunderbolt / USB controller firmware
* SSD/NVMe firmware
* WiFi / Bluetooth drivers / firmware (often Windows drivers)
* Chipset / platform software (for Windows only)
* Misc tools (Dell utilities, etc.)

Some of them are **hardware-level updates** that *can* be deployed under Linux (if the device is supported via LVFS / fwupd), others are Windows-only.

Dell’s own BIOS page often includes “Firmware updates to address security vulnerabilities” etc. ([Dell][1])

Dell also documents how to flash BIOS from Linux side or via the boot menu. ([Dell][2])

---

## ⚙️ What updates *are* likely supported via `fwupd`

`fwupd` + LVFS (Linux Vendor Firmware Service) supports firmware updates for many internal devices, such as:

* System / motherboard firmware (BIOS/UEFI)
* Embedded controllers, microcontrollers
* NVMe / SSD firmware (if the vendor publishes it)
* Thunderbolt / USB controllers (if supported)
* Some peripherals (touchpads, fingerprint, etc.)

If `fwupdmgr get-updates` shows no updates left, that means either:

* Dell hasn’t published that firmware via LVFS yet, or
* The component is not supported for capsule updates
* Or the kernel / system blocks writing to the firmware region (like the efivarfs issue you saw)

In your output earlier, `fwupdmgr get-updates` listed devices with “no available firmware updates” (like NVMe, Thunderbolt, UEFI Device Firmware) which suggests that there are currently none published or allowable for your device.

---

## 🛡️ Steps to safely check and apply additional updates

Here’s a safe workflow:

1. **List all devices and their firmware versions via fwupd**

   ```bash
   sudo fwupdmgr get-devices
   ```

   This shows which components are updatable and whether a vendor has issued newer firmware.

2. **Refresh the metadata**

   ```bash
   sudo fwupdmgr refresh --force
   sudo fwupdmgr get-updates
   ```

   This ensures you've got the latest published updates from LVFS.

3. **For firmware the system can’t update (or for updates not in LVFS)**

   * Download the relevant `.exe` or firmware file from Dell’s website
   * Copy it to a FAT32-formatted USB or to your EFI partition
   * Use Dell’s Boot Menu / BIOS Flash Update / UEFI update mechanism to apply it

4. **Verify after reboot**

   * Check the firmware versions again (via `fwupdmgr get-devices`)
   * Ensure the device is working normally

5. **Ignore (or skip) pure Windows driver updates**
   Many drivers on Dell’s page are Windows executables (e.g. “Dell Update Application,” specific Windows-only chipset drivers). Those won’t be usable under Linux, so skip them unless you’re running dual-boot or using those components via Windows.

---

## 🧪 Example: Thunderbolt / Dock firmware

For example, in AskUbuntu someone had Dell XPS 15 9500 and observed:

* Thunderbolt controller firmware updates
* Dock (e.g. WD19) firmware updates
  These were listed under `fwupdmgr` as updatable devices. ([Ask Ubuntu][3])

If your system shows “Thunderbolt host controller” as **updatable** in `fwupdmgr get-devices`, then yes, you can update it via `fwupdmgr update` — assuming your system allows writing to that firmware region.

If instead Dell’s site has a more recent Thunderbolt firmware not yet in LVFS, you'd do exactly the `.exe` + boot-flash method.

---

If you want, I can check the Dell Drivers page for your XPS 9500 right now and cross-reference which firmware updates *are* available (BIOS, Thunderbolt, SSD, etc.), then generate a checklist for which ones you can apply under Linux (and how). Do you want me to do that?

[1]: https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=mh02d&utm_source=chatgpt.com "Dell XPS 15 9500 System BIOS | Driver Details"
[2]: https://www.dell.com/support/kbdoc/en-us/000131486/update-the-dell-bios-in-a-linux-or-ubuntu-environment?utm_source=chatgpt.com "How to Update the Dell BIOS in the Ubuntu or Linux Environment"
[3]: https://askubuntu.com/questions/1515391/firmware-updates-for-dell-xps15-9500?utm_source=chatgpt.com "Firmware Updates for Dell XPS15 9500 - Ask Ubuntu"
