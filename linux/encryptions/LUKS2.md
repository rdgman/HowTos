Below is a **ready-to-roll fleet-safe approach for Ubuntu 24.x** with two options:

1. keyfile-on-disk (simple, non-interactive), and
2. TPM2 auto-unlock (no passphrase prompts at boot, great for servers with TPMs).

I’ve included **bash scripts (with proper shebangs)** and an **Ansible playbook** you can push across the fleet.

---

# Option A — Keyfile-on-disk (non-interactive, simplest)

### `luks_provision_keyfile.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Usage:
#  sudo ./luks_provision_keyfile.sh \
#    --device /dev/sdb \
#    --name securedata \
#    --mountpoint /srv/securedata \
#    --fs ext4 \
#    --keyfile /root/.luks/securedata.key \
#    --header-backup /root/.luks/securedata.header \
#    --label SECUREDATA
#
# Notes:
# - Provide a whole disk or an existing partition as --device
# - Script is idempotent where possible; it won’t reformat if already set up

DEVICE=""
NAME=""
MOUNTPOINT=""
FS_TYPE="ext4"
KEYFILE=""
HEADER_BACKUP=""
LABEL="SECUREDATA"

err() { echo "ERROR: $*" >&2; exit 1; }
info(){ echo "-- $*"; }

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --device) DEVICE="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    --mountpoint) MOUNTPOINT="$2"; shift 2;;
    --fs) FS_TYPE="$2"; shift 2;;
    --keyfile) KEYFILE="$2"; shift 2;;
    --header-backup) HEADER_BACKUP="$2"; shift 2;;
    --label) LABEL="$2"; shift 2;;
    *) err "Unknown arg: $1";;
  esac
done

[[ -b "$DEVICE" ]] || err "--device must be a block device"
[[ -n "$NAME" ]] || err "--name is required"
[[ -n "$MOUNTPOINT" ]] || err "--mountpoint is required"
[[ -n "$KEYFILE" ]] || err "--keyfile is required"
[[ -n "$HEADER_BACKUP" ]] || err "--header-backup is required"

# Sanity checks
command -v cryptsetup >/dev/null || err "cryptsetup not installed. apt-get install -y cryptsetup"
if [[ "$FS_TYPE" != "ext4" && "$FS_TYPE" != "xfs" && "$FS_TYPE" != "btrfs" ]]; then
  err "--fs must be one of: ext4, xfs, btrfs"
fi
if lsblk -no MOUNTPOINT "$DEVICE" | grep -q . ; then
  err "$DEVICE appears mounted. Unmount and retry."
fi

# Ensure directories
install -d -m 0700 "$(dirname "$KEYFILE")"
install -d -m 0700 "$(dirname "$HEADER_BACKUP")"
install -d -m 0755 "$MOUNTPOINT"

# Detect if already LUKS
if cryptsetup isLuks "$DEVICE"; then
  info "$DEVICE already has LUKS header"
else
  info "Formatting LUKS2 on $DEVICE"
  cryptsetup luksFormat "$DEVICE" --type luks2 \
    --cipher aes-xts-plain64 --key-size 512 --hash sha256 \
    --iter-time 2000 --use-urandom --batch-mode

  info "Backing up LUKS header to $HEADER_BACKUP (KEEP THIS SAFE!)"
  cryptsetup luksHeaderBackup "$DEVICE" --header-backup-file "$HEADER_BACKUP"
fi

# Create a keyfile if missing and add to LUKS
if [[ ! -f "$KEYFILE" ]]; then
  info "Generating keyfile at $KEYFILE"
  umask 077
  dd if=/dev/urandom of="$KEYFILE" bs=64 count=1 status=none
  chmod 600 "$KEYFILE"
  info "Add keyfile to LUKS keyslots (you will be asked for existing passphrase once)"
  cryptsetup luksAddKey "$DEVICE" "$KEYFILE"
fi

# Open the container (idempotent)
if [[ ! -e "/dev/mapper/$NAME" ]]; then
  info "Opening LUKS container as $NAME"
  cryptsetup open "$DEVICE" "$NAME" --key-file "$KEYFILE"
else
  info "/dev/mapper/$NAME already exists"
fi

MAPPER="/dev/mapper/$NAME"

# Create filesystem if not present
if ! blkid "$MAPPER" | grep -qE 'TYPE='; then
  info "Creating filesystem $FS_TYPE on $MAPPER"
  case "$FS_TYPE" in
    ext4) mkfs.ext4 -L "$LABEL" "$MAPPER" ;;
    xfs)  mkfs.xfs -L "$LABEL" "$MAPPER" ;;
    btrfs) mkfs.btrfs -L "$LABEL" "$MAPPER" ;;
  esac
fi

# Mount it (idempotent)
if ! mount | grep -q " on $MOUNTPOINT "; then
  info "Mounting $MAPPER at $MOUNTPOINT"
  mount "$MAPPER" "$MOUNTPOINT"
fi

# Get UUID of the *underlying* device for /etc/crypttab
UUID="$(blkid -s UUID -o value "$DEVICE")"
[[ -n "$UUID" ]] || err "Failed to get UUID for $DEVICE"

# Ensure /etc/crypttab entry
CRYPTTAB_LINE="$NAME UUID=$UUID $KEYFILE luks,discard"
if ! grep -q "^$NAME " /etc/crypttab 2>/dev/null; then
  info "Adding to /etc/crypttab"
  echo "$CRYPTTAB_LINE" >> /etc/crypttab
else
  info "/etc/crypttab already has an entry for $NAME (not changing)"
fi

# Ensure /etc/fstab entry for the mapped device
if ! grep -q "/dev/mapper/$NAME" /etc/fstab 2>/dev/null; then
  info "Adding /etc/fstab entry"
  case "$FS_TYPE" in
    ext4) FSTAB_OPTS="defaults,noatime";;
    xfs)  FSTAB_OPTS="defaults,noatime";;
    btrfs) FSTAB_OPTS="defaults,noatime,ssd";;
  esac
  echo "/dev/mapper/$NAME $MOUNTPOINT $FS_TYPE $FSTAB_OPTS 0 2" >> /etc/fstab
else
  info "/etc/fstab already has entry for /dev/mapper/$NAME"
fi

# Harden permissions on keyfile
chmod 600 "$KEYFILE"
chown root:root "$KEYFILE"

info "Done. Verify with: lsblk -f; cat /etc/crypttab; cat /etc/fstab"
```

**What it does**

* Creates LUKS2 on the target device, backs up the header, creates a **keyfile**, adds it to LUKS, formats a filesystem, mounts it, and writes **/etc/crypttab** & **/etc/fstab** for auto-unlock and mount on boot.
* Designed to be **idempotent-ish** and safe for repeated execution.

---

# Option B — TPM2 auto-unlock (no passphrase at boot)

Requires TPM2 (common on modern servers/laptops) and systemd ≥ 252 (Ubuntu 24.04 meets this).

### `luks_provision_tpm2.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Usage:
#  sudo ./luks_provision_tpm2.sh \
#    --device /dev/sdb \
#    --name securedata \
#    --mountpoint /srv/securedata \
#    --fs ext4 \
#    --header-backup /root/.luks/securedata.header \
#    --label SECUREDATA
#
# Optional:
#   --pin "1234"     # (Recommended) require local PIN with TPM2
#   --pcrs "7"       # Bind to PCRs (e.g. 7, or '7+11') for measured-boot security

DEVICE=""
NAME=""
MOUNTPOINT=""
FS_TYPE="ext4"
HEADER_BACKUP=""
LABEL="SECUREDATA"
PIN=""
PCRS=""

err(){ echo "ERROR: $*" >&2; exit 1; }
info(){ echo "-- $*"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --device) DEVICE="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    --mountpoint) MOUNTPOINT="$2"; shift 2;;
    --fs) FS_TYPE="$2"; shift 2;;
    --header-backup) HEADER_BACKUP="$2"; shift 2;;
    --label) LABEL="$2"; shift 2;;
    --pin) PIN="$2"; shift 2;;
    --pcrs) PCRS="$2"; shift 2;;
    *) err "Unknown arg: $1";;
  esac
done

[[ -b "$DEVICE" ]] || err "--device must be a block device"
[[ -n "$NAME" ]] || err "--name is required"
[[ -n "$MOUNTPOINT" ]] || err "--mountpoint is required"
[[ -n "$HEADER_BACKUP" ]] || err "--header-backup is required"

command -v cryptsetup >/dev/null || err "cryptsetup not installed"
command -v systemd-cryptenroll >/dev/null || err "systemd-cryptenroll not installed (part of systemd)"

if lsblk -no MOUNTPOINT "$DEVICE" | grep -q . ; then
  err "$DEVICE appears mounted. Unmount and retry."
fi

install -d -m 0700 "$(dirname "$HEADER_BACKUP")"
install -d -m 0755 "$MOUNTPOINT"

if ! cryptsetup isLuks "$DEVICE"; then
  info "Formatting LUKS2 on $DEVICE"
  cryptsetup luksFormat "$DEVICE" --type luks2 \
    --cipher aes-xts-plain64 --key-size 512 --hash sha256 \
    --iter-time 2000 --use-urandom --batch-mode

  info "Backing up LUKS header to $HEADER_BACKUP (KEEP SAFE)"
  cryptsetup luksHeaderBackup "$DEVICE" --header-backup-file "$HEADER_BACKUP"
else
  info "$DEVICE is already LUKS"
fi

# Enrol TPM2 keyslot
ENROLL_ARGS=(--tpm2-device=auto)
[[ -n "$PIN" ]] && ENROLL_ARGS+=(--tpm2-with-pin --pin="$PIN")
[[ -n "$PCRS" ]] && ENROLL_ARGS+=(--tpm2-pcrs="$PCRS")

info "Enrolling TPM2 keyslot"
systemd-cryptenroll "${ENROLL_ARGS[@]}" "$DEVICE"

# Open via tpm2 (will prompt for PIN if set)
if [[ ! -e "/dev/mapper/$NAME" ]]; then
  info "Opening $DEVICE as $NAME using TPM2"
  cryptsetup open "$DEVICE" "$NAME" --tpm2-device=auto
fi

MAPPER="/dev/mapper/$NAME"

# Create filesystem if missing
if ! blkid "$MAPPER" | grep -qE 'TYPE='; then
  info "Creating filesystem $FS_TYPE on $MAPPER"
  case "$FS_TYPE" in
    ext4) mkfs.ext4 -L "$LABEL" "$MAPPER" ;;
    xfs)  mkfs.xfs -L "$LABEL" "$MAPPER" ;;
    btrfs) mkfs.btrfs -L "$LABEL" "$MAPPER" ;;
    *) err "Unsupported FS: $FS_TYPE";;
  esac
fi

# Mount
if ! mount | grep -q " on $MOUNTPOINT "; then
  info "Mounting $MAPPER at $MOUNTPOINT"
  mount "$MAPPER" "$MOUNTPOINT"
fi

# /etc/crypttab with TPM2
UUID="$(blkid -s UUID -o value "$DEVICE")"
[[ -n "$UUID" ]] || err "Failed to get UUID"
CRYPTTAB_LINE="$NAME UUID=$UUID - luks,tpm2-device=auto,discard"
if ! grep -q "^$NAME " /etc/crypttab 2>/dev/null; then
  info "Adding TPM2 entry to /etc/crypttab"
  echo "$CRYPTTAB_LINE" >> /etc/crypttab
fi

# /etc/fstab
if ! grep -q "/dev/mapper/$NAME" /etc/fstab 2>/dev/null; then
  info "Adding /etc/fstab entry"
  echo "/dev/mapper/$NAME $MOUNTPOINT $FS_TYPE defaults,noatime 0 2" >> /etc/fstab
fi

info "Done. Reboot test recommended to confirm auto-unlock."
```

---

# Fleet rollout with Ansible (works for both methods)

### `inventory.yml` (example)

```yaml
all:
  hosts:
    host1.example:
    host2.example:
  vars:
    luks_device: "/dev/sdb"
    luks_name: "securedata"
    luks_mountpoint: "/srv/securedata"
    luks_fs: "ext4"
    luks_label: "SECUREDATA"
    # Choose one:
    use_tpm2: true          # set to false to use keyfile mode
    tpm2_pin: "1234"        # optional
    tpm2_pcrs: "7"          # optional
    keyfile_path: "/root/.luks/securedata.key"
    header_backup: "/root/.luks/securedata.header"
```

### `site.yml`

```yaml
#!/usr/bin/env bash
```

```yaml
---
- name: Provision LUKS across Ubuntu 24.x fleet
  hosts: all
  become: yes
  gather_facts: yes

  pre_tasks:
    - name: Ensure dependencies
      apt:
        name:
          - cryptsetup
          - systemd
          - xfsprogs
          - btrfs-progs
        state: present
        update_cache: yes

    - name: Create secure directories
      file:
        path: "{{ item }}"
        state: directory
        mode: "0700"
      loop:
        - "{{ keyfile_path | default('/root/.luks/securedata.key') | dirname }}"
        - "{{ header_backup | default('/root/.luks/securedata.header') | dirname }}"
        - "{{ luks_mountpoint }}"

  tasks:
    - name: Upload keyfile script
      copy:
        src: ./luks_provision_keyfile.sh
        dest: /root/luks_provision_keyfile.sh
        mode: "0755"

    - name: Upload TPM2 script
      copy:
        src: ./luks_provision_tpm2.sh
        dest: /root/luks_provision_tpm2.sh
        mode: "0755"

    - name: Run TPM2 provision
      when: use_tpm2 | default(false)
      shell: >
        /root/luks_provision_tpm2.sh
        --device {{ luks_device }}
        --name {{ luks_name }}
        --mountpoint {{ luks_mountpoint }}
        --fs {{ luks_fs }}
        --header-backup {{ header_backup }}
        --label {{ luks_label }}
        {% if tpm2_pin is defined and tpm2_pin|length > 0 %}--pin "{{ tpm2_pin }}"{% endif %}
        {% if tpm2_pcrs is defined and tpm2_pcrs|length > 0 %}--pcrs "{{ tpm2_pcrs }}"{% endif %}
      args:
        executable: /bin/bash

    - name: Run keyfile provision
      when: not (use_tpm2 | default(false))
      shell: >
        /root/luks_provision_keyfile.sh
        --device {{ luks_device }}
        --name {{ luks_name }}
        --mountpoint {{ luks_mountpoint }}
        --fs {{ luks_fs }}
        --keyfile {{ keyfile_path }}
        --header-backup {{ header_backup }}
        --label {{ luks_label }}
      args:
        executable: /bin/bash
```

> Tip: put the two scripts beside `site.yml` and run:
> `ansible-playbook -i inventory.yml site.yml`

---

## Operational notes & guardrails

* **Header backup**: Store `*.header` files off-box (e.g., S3 with SSE, HashiCorp Vault). Without the header, recovery is near impossible.
* **Keyfile mode**: ensure `0600` perms, owned by root, and consider also storing the key in Vault/KBMS. Host compromise ⇒ key exposure risk.
* **TPM2 mode**: set a **PIN** and bind to **PCRs** (like 7) to reduce evil-maid risk. Changing firmware/boot chain may require re-enrolment if PCRs change.
* **Wipe before reuse**: run `blkdiscard /dev/sdX` (if SSD and supported) or `shred`/`dd if=/dev/zero` before provisioning to avoid data remnants.
* **Monitoring**: alert on `/etc/crypttab`, `/etc/fstab`, and `/root/.luks/*` changes; verify unlock on next reboot during a maintenance window.
* **Filesystems**: for large volumes, `xfs` is often preferred; for snapshots/compression, use `btrfs` (tune mount options appropriately).

---

If you want, I can tailor the Ansible to your exact host groups and naming conventions (e.g., different devices per host, per-role mountpoints, or Vault-backed key distribution).
