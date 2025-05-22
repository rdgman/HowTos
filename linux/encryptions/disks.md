Here’s a comprehensive guide covering the topics you asked about, with a focus on how to use them on **Ubuntu Linux**:

---

## 🔐 LUKS Disk Encryption on Ubuntu

**LUKS (Linux Unified Key Setup)** is the standard for Linux hard disk encryption. It works with `dm-crypt` to provide secure, full-disk encryption.

### Key Steps:
1. **Install cryptsetup**:
   ```bash
   sudo apt update
   sudo apt install cryptsetup
   ```

2. **Encrypt a partition**:
   ```bash
   sudo cryptsetup luksFormat /dev/sdX
   ```

3. **Open the encrypted partition**:
   ```bash
   sudo cryptsetup luksOpen /dev/sdX my_encrypted_disk
   ```

4. **Create a filesystem**:
   ```bash
   sudo mkfs.ext4 /dev/mapper/my_encrypted_disk
   ```

5. **Mount it**:
   ```bash
   sudo mount /dev/mapper/my_encrypted_disk /mnt
   ```

📘 Full guide: [nixCraft LUKS Tutorial](https://www.cyberciti.biz/security/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/) [1](https://www.cyberciti.biz/security/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/) | [Ubuntu Community Wiki](https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019) [2](https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019)

---

## 🔐 Data Encryption with GPG

**GPG (GNU Privacy Guard)** is a tool for secure communication and data storage.

### Basic Usage:
1. **Install GPG**:
   ```bash
   sudo apt install gnupg
   ```

2. **Generate a key pair**:
   ```bash
   gpg --full-generate-key
   ```

3. **Encrypt a file**:
   ```bash
   gpg -c filename
   ```

4. **Decrypt a file**:
   ```bash
   gpg filename.gpg
   ```

📘 Full guide: [TheLinuxCode GPG Tutorial](https://thelinuxcode.com/gpg-command-ubuntu/) [3](https://thelinuxcode.com/gpg-command-ubuntu/) | [How-To Geek GPG Guide](https://www.howtogeek.com/427982/how-to-encrypt-and-decrypt-files-with-gpg-on-linux/) [4](https://www.howtogeek.com/427982/how-to-encrypt-and-decrypt-files-with-gpg-on-linux/)

---

## 🔍 MD5 and SHA Checksums on Ubuntu

Checksums verify file integrity. Common tools: `md5sum`, `sha256sum`, etc.

### Usage:
1. **Generate checksum**:
   ```bash
   md5sum filename
   sha256sum filename
   ```

2. **Compare with expected hash**:
   ```bash
   echo "expected_hash  filename" | sha256sum -c -
   ```

3. **GUI method**:
   Install:
   ```bash
   sudo apt install nautilus-gtkhash
   nautilus -q
   ```
   Then right-click a file → Properties → Digests tab.

📘 Full guide: [Ubuntu Handbook](https://ubuntuhandbook.org/index.php/2023/04/check-md5-sha-hash-ubuntu/) [5](https://ubuntuhandbook.org/index.php/2023/04/check-md5-sha-hash-ubuntu/) | [YouTube Tutorial](https://www.youtube.com/watch?v=uIIn6qVGOJQ) [6](https://www.youtube.com/watch?v=uIIn6qVGOJQ)

---

## 🔐 Data Encryption with SSH

**SSH (Secure Shell)** encrypts network traffic for secure remote access.

### Key Concepts:
- **Password Authentication**: Default method.
- **Key-Based Authentication**:
  1. Generate keys:
     ```bash
     ssh-keygen
     ```
  2. Copy public key to server:
     ```bash
     ssh-copy-id user@remote_host
     ```

- **Encrypting Data**: SSH encrypts all data in transit.
- **Secure File Transfer**:
  ```bash
  scp file.txt user@remote_host:/path/
  ```

📘 Full guide: [Ubuntu SSH Crypto Config](https://documentation.ubuntu.com/server/openssh-crypto-configuration/) [7](https://documentation.ubuntu.com/server/openssh-crypto-configuration/) | [SocketXP SSH Guide](https://www.socketxp.com/iot/ssh-secure-shell/) [8](https://www.socketxp.com/iot/ssh-secure-shell/)

---

Would you like me to compile all of this into a downloadable PDF or Markdown file for easy reference?
