## 📘 Document: LUKS Encryption Rollout — Ubuntu 24.x Fleet

**Author:** Michael Tint
**Date:** October 2025
**Organisation:** Linux Administration — Reading, UK

---

### 🧱 **Purpose**

To standardise full-disk encryption across all Ubuntu 24.x systems using **LUKS2** with either:

* **Keyfile-based unlock** (for servers without TPM)
* **TPM2 auto-unlock** (for modern systems with TPM)

This ensures consistent security and hands-free boot integrity for the fleet.

---

## 1️⃣ Overview of LUKS2 Architecture

Below is a conceptual view of how LUKS2 sits in the Linux storage stack:

```
 ┌────────────────────────────────────────────┐
 │ Application Layer (userland, processes)   │
 └────────────────────────────────────────────┘
                  │
                  ▼
 ┌────────────────────────────────────────────┐
 │ Filesystem (ext4 / xfs / btrfs)           │
 └────────────────────────────────────────────┘
                  │
                  ▼
 ┌────────────────────────────────────────────┐
 │ /dev/mapper/<name>  (Decrypted device)     │
 │   ⤷ Data read/written in plaintext         │
 └────────────────────────────────────────────┘
                  │
                  ▼
 ┌────────────────────────────────────────────┐
 │ LUKS2 layer (dm-crypt + cryptsetup)        │
 │   ⤷ Encrypts/decrypts using AES-XTS        │
 │   ⤷ Master key stored encrypted in header  │
 │   ⤷ Multiple keyslots (passphrases/keys)   │
 └────────────────────────────────────────────┘
                  │
                  ▼
 ┌────────────────────────────────────────────┐
 │ Physical Device (/dev/sdX, NVMe, USB)      │
 │   ⤷ Encrypted block data                   │
 └────────────────────────────────────────────┘
```

---

## 2️⃣ Encryption Flow Diagrams

### **A. Keyfile Method (No TPM)**

```
┌───────────────┐
│ /dev/sdb      │   ← Unencrypted block device
└──────┬────────┘
       │ cryptsetup luksFormat
       ▼
┌────────────────────────┐
│ LUKS2 Encrypted Volume │
│ (AES-XTS, 512-bit key) │
└──────┬─────────────────┘
       │ luksAddKey using keyfile
       ▼
┌────────────────────────┐
│ /root/.luks/secure.key │  ← Stored securely (chmod 600)
└──────┬─────────────────┘
       │ cryptsetup open --key-file
       ▼
┌────────────────────────┐
│ /dev/mapper/securedata │  ← Decrypted mapper device
└──────┬─────────────────┘
       │ mkfs + mount
       ▼
┌────────────────────────┐
│ /srv/securedata        │  ← Filesystem mounted
└────────────────────────┘
```

---

### **B. TPM2 Auto-Unlock Method**

```
┌───────────────┐
│ /dev/sdb      │
└──────┬────────┘
       │ cryptsetup luksFormat
       ▼
┌────────────────────────┐
│ LUKS2 Volume            │
└──────┬─────────────────┘
       │ systemd-cryptenroll --tpm2-device=auto
       ▼
┌────────────────────────┐
│ TPM2 Chip (hardware)   │
│ - Seals master key     │
│ - Binds to PCRs        │
│ - Optional PIN          │
└──────┬─────────────────┘
       │ cryptsetup open --tpm2-device=auto
       ▼
┌────────────────────────┐
│ /dev/mapper/securedata │
└──────┬─────────────────┘
       │ mkfs + mount
       ▼
┌────────────────────────┐
│ /srv/securedata        │
└────────────────────────┘
```

On boot, `systemd` automatically unlocks the disk using TPM2, provided PCR measurements and PIN (if configured) match.

---

## 3️⃣ Process Flow

### **Step 1 – Prepare Device**

* Identify the correct target device (e.g., `/dev/sdb`)
* Unmount any partitions
* Optionally wipe:

  ```bash
  sudo blkdiscard /dev/sdb
  ```

---

### **Step 2 – Run Setup Script**

#### For keyfile-based systems:

```bash
sudo ./luks_provision_keyfile.sh \
  --device /dev/sdb \
  --name securedata \
  --mountpoint /srv/securedata \
  --fs ext4 \
  --keyfile /root/.luks/securedata.key \
  --header-backup /root/.luks/securedata.header \
  --label SECUREDATA
```

#### For TPM2-enabled systems:

```bash
sudo ./luks_provision_tpm2.sh \
  --device /dev/sdb \
  --name securedata \
  --mountpoint /srv/securedata \
  --fs ext4 \
  --header-backup /root/.luks/securedata.header \
  --label SECUREDATA \
  --pin "1234" \
  --pcrs "7"
```

---

### **Step 3 – Verify and Register**

#### Check mappings:

```bash
lsblk -f
```

#### Confirm `/etc/crypttab` and `/etc/fstab` entries:

```bash
cat /etc/crypttab
cat /etc/fstab
```

#### Test Reboot:

* On reboot, system should unlock automatically (TPM2) or via keyfile (stored locally).

---

## 4️⃣ Deployment Architecture (Fleet)

### Fleet-Level View (Keyfile Mode Example)

```
                   ┌─────────────────────────────────────────┐
                   │  Ansible Control Node                   │
                   │  (mtint@mgmtserver)                     │
                   │  Runs site.yml playbook                 │
                   └──────────────┬──────────────────────────┘
                                  │ SSH/Ansible
                                  ▼
 ┌────────────────────┬────────────────────┬────────────────────┐
 │ Host A (no TPM)    │ Host B (no TPM)    │ Host C (TPM2)     │
 │ /dev/sdb encrypted │ /dev/sdb encrypted │ /dev/sdb encrypted│
 │ keyfile stored in  │ keyfile stored in  │ TPM2 enrolment    │
 │ /root/.luks/       │ /root/.luks/       │ via cryptenroll   │
 └─────────┬──────────┴─────────┬──────────┴─────────┬─────────┘
           │                   │                    │
           ▼                   ▼                    ▼
 /srv/securedata       /srv/securedata      /srv/securedata
 Mounted and encrypted across fleet
```

---

## 5️⃣ Security & Maintenance Notes

| Area              | Recommendation                                                     |
| ----------------- | ------------------------------------------------------------------ |
| **Header Backup** | Store `/root/.luks/*.header` securely off-host.                    |
| **Keyfile**       | Restrict to `root:root`, mode `0600`. Consider Vault integration.  |
| **TPM2**          | Always use a PIN and bind to PCRs (7 recommended).                 |
| **Auditing**      | Monitor `/etc/crypttab` and `/etc/fstab` for unauthorized changes. |
| **Recovery**      | Test restore from header backup periodically.                      |
| **Updates**       | Keep `cryptsetup` and `systemd` up to date.                        |

---

## 6️⃣ Diagrams Summary (for presentation)

**Diagram 1:** Linux storage stack with LUKS
**Diagram 2:** Keyfile-based encryption flow
**Diagram 3:** TPM2-based encryption flow
**Diagram 4:** Fleet-wide Ansible rollout

---

Would you like me to:

1. Generate **PDF documentation** (with text + the diagrams embedded)?
2. Or produce a **visual poster-style diagram image** (network + device flow with labels)?

I can do both — just tell me which format(s) you want (`PDF`, `PNG`, or both).
