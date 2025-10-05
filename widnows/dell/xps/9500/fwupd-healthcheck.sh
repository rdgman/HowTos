#!/usr/bin/env bash
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

  echo "Devices:"
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
