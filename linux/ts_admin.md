here's a list of common diagnostic commands that can be useful for both Ubuntu 22.04 Desktop and Server environments. These commands help in troubleshooting various issues related to system information, hardware, networking, performance, and software packages.

### System Information & General Health

* **`uname -a`**: Displays detailed information about the Linux kernel, including the version, release date, and system architecture. This is often one ofthe first commands run to understand the system's core. (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux))
* **`lsb_release -a`**: Shows Ubuntu-specific distribution information, including the release version and codename. (Source: [Tools to diagnose Ubuntu problems - Ask Ubuntu](https://askubuntu.com/questions/75325/tools-to-diagnose-ubuntu-problems))
* **`dmesg`**: Prints the kernel ring buffer messages. These messages can reveal errors or warnings related to hardware initialization, device drivers, and other kernel-level activities, especially useful for diagnosing boot-up issues. (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux), [Tools to diagnose Ubuntu problems - Ask Ubuntu](https://askubuntu.com/questions/75325/tools-to-diagnose-ubuntu-problems))
    * `dmesg -HT`: Displays `dmesg` output with human-readable timestamps and in a pager. (Source: [How do I detect any problem with my system? - Ask Ubuntu](https://askubuntu.com/questions/1426447/how-do-i-detect-any-problem-with-my-system))
* **`df -h`**: Reports file system disk space usage in a human-readable format (e.g., MB, GB). Essential for checking if a disk is full. (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux))
* **`free -h`**: Displays the amount of free and used memory in the system (RAM and swap) in a human-readable format. (Source: [How do I diagnose my issue, when I'm not sure if it is a hardware or software issue? - Ask Ubuntu](https://askubuntu.com/questions/1384357/how-do-i-diagnose-my-issue-when-im-not-sure-if-it-is-a-hardware-or-software-is))
* **`uptime`**: Shows how long the system has been running, the number of users currently logged in, and the system load averages.
* **`hostname`**: Displays the system's hostname. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`systemctl status <service-name>`**: Checks the status of a systemd service (e.g., `systemctl status sshd`, `systemctl status apache2`).
    * `systemctl --user restart pulseaudio`: Restarts the PulseAudio sound server (Desktop specific). (Source: [Ubuntu Linux Support - Velocity Micro](https://velocitymicro.com/support/ubuntu.php))
    * `sudo systemctl restart NetworkManager`: Restarts the NetworkManager service (Common on Desktop). (Source: [How to use logs to diagnose an internet connectivity issue? - Ubuntu Forums](https://ubuntuforums.org/showthread.php?t=2491463))
    * `sudo systemctl restart resolvd`: Restarts the systemd-resolved service for DNS. (Source: [How to use logs to diagnose an internet connectivity issue? - Ubuntu Forums](https://ubuntuforums.org/showthread.php?t=2491463))

### Hardware Diagnostics

* **`lspci`**: Lists all PCI devices connected to the system, such as graphics cards, network adapters, and sound cards. (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux))
    * `lspci | grep -i audio`: Specifically lists audio devices. (Source: [Ubuntu Linux Support - Velocity Micro](https://velocitymicro.com/support/ubuntu.php))
    * `lspci | grep -i bluetooth`: Specifically lists Bluetooth hardware. (Source: [Ubuntu Linux Support - Velocity Micro](https://velocitymicro.com/support/ubuntu.php))
* **`lsusb`**: Lists all USB devices connected to the system. (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux))
* **`lshw`**: Lists detailed information about the hardware configuration of the machine. It can provide a comprehensive overview of memory, CPU, disks, network interfaces, etc. (Source: [Tools to diagnose Ubuntu problems - Ask Ubuntu](https://askubuntu.com/questions/75325/tools-to-diagnose-ubuntu-problems))
* **`lsmod`**: Shows the status of modules currently loaded into the Linux kernel. Useful for checking if necessary drivers are loaded. (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux))
* **`lscpu`**: Displays information about the CPU architecture, such as the number of CPUs, cores, threads, and cache sizes. (Source: [Tools to diagnose Ubuntu problems - Ask Ubuntu](https://askubuntu.com/questions/75325/tools-to-diagnose-ubuntu-problems))
* **`lsblk`**: Lists block devices such as hard drives and their partitions in a tree-like format, showing mount points. (Source: [Tools to diagnose Ubuntu problems - Ask Ubuntu](https://askubuntu.com/questions/75325/tools-to-diagnose-ubuntu-problems))
* **`sudo fdisk -l`**: Lists disk partitions. (Similar to `lsblk` but provides different formatting and details).
* **`sudo dmidecode`**: Reports information about your system's hardware as described in the system BIOS. Can show memory details, serial numbers, etc. (Source: [Tools to diagnose Ubuntu problems - Ask Ubuntu](https://askubuntu.com/questions/75325/tools-to-diagnose-ubuntu-problems))
* **`sudo ubuntu-drivers devices`**: Lists devices that have available proprietary drivers and which ones are recommended. (Source: [How do I diagnose my issue, when I'm not sure if it is a hardware or software issue? - Ask Ubuntu](https://askubuntu.com/questions/1384357/how-do-i-diagnose-my-issue-when-im-not-sure-if-it-is-a-hardware-or-software-is))
* **`memtest86+`**: A tool for testing RAM. Often available from the GRUB boot menu. (Source: [Ubuntu Linux Support - Velocity Micro](https://velocitymicro.com/support/ubuntu.php))
* **`sudo memtester <RAM_to_test> <iterations>`**: Tests a specified amount of RAM for errors (e.g., `sudo memtester 6G 5`). (Source: [How do I diagnose my issue, when I'm not sure if it is a hardware or software issue? - Ask Ubuntu](https://askubuntu.com/questions/1384357/how-do-i-diagnose-my-issue-when-im-not-sure-if-it-is-a-hardware-or-software-is))
* **`sudo apt install rasdaemon`** then **`journalctl -f -u rasdaemon`**: Installs and checks logs from `rasdaemon`, which logs Machine Check Exceptions (MCEs) indicating hardware failures. (Source: [How do I diagnose my issue, when I'm not sure if it is a hardware or software issue? - Ask Ubuntu](https://askubuntu.com/questions/1384357/how-do-i-diagnose-my-issue-when-im-not-sure-if-it-is-a-hardware-or-software-is))
* **Disks utility (GUI)**: For desktop users, the "Disks" application allows checking S.M.A.R.T. data and running self-tests on hard drives. (Source: [How do I diagnose my issue, when I'm not sure if it is a hardware or software issue? - Ask Ubuntu](https://askubuntu.com/questions/1384357/how-do-i-diagnose-my-issue-when-im-not-sure-if-it-is-a-hardware-or-software-is))

### Network Diagnostics

* **`ip addr`** or **`ip a`**: Shows IP addresses and network interface information. This is the modern replacement for `ifconfig`. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`ip link show`**: Displays the status of network interfaces. (Source: [Ubuntu 22.04 Network Diagnostic Handbook - Anduin Xue](https://anduin.aiursoft.cn/post/2024/2/29/ubuntu-2204-network-diagnostic-handbook))
* **`ip route show`**: Shows the IP routing table. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`ping <hostname_or_IP>`**: Sends ICMP ECHO_REQUEST packets to network hosts to test connectivity. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`traceroute <hostname_or_IP>`**: Prints the route packets trace to network host. Useful for diagnosing routing issues. May need to be installed (`sudo apt install traceroute`). (Source: [How to use logs to diagnose an internet connectivity issue? - Ubuntu Forums](https://ubuntuforums.org/showthread.php?t=2491463))
* **`tracepath <hostname_or_IP>`**: Similar to traceroute but doesn't require root privileges and is often pre-installed. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`netstat -tulnp`**: Shows active listening ports and established connections (TCP and UDP), along with the programs using them. (Note: `ss` is a more modern replacement). (Source: [Tools to diagnose Ubuntu problems - Ask Ubuntu](https://askubuntu.com/questions/75325/tools-to-diagnose-ubuntu-problems))
* **`ss -tulnp`**: A utility to investigate sockets. Similar to `netstat`, but generally preferred on modern systems. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`dig <domain_name>`**: DNS lookup utility. Used to query DNS servers for information about host addresses, mail exchanges, name servers, and related information. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`nslookup <domain_name>`**: Another DNS lookup utility, similar to `dig`. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`host <domain_name>`**: Simple utility for performing DNS lookups. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`sudo netplan apply`**: Applies network configuration changes defined in Netplan YAML files (common in recent Ubuntu versions, especially Server). (Source: [Ubuntu 22.04 Network Diagnostic Handbook - Anduin Xue](https://anduin.aiursoft.cn/post/2024/2/29/ubuntu-2204-network-diagnostic-handbook))
* **`nmcli dev status`**: Command-line tool for controlling NetworkManager and reporting network status (common on Desktop).
* **`rfkill list`**: Shows the status of wireless devices (if they are hard or soft blocked). (Source: [Ubuntu Linux Support - Velocity Micro](https://velocitymicro.com/support/ubuntu.php))
* **`iwconfig`**: Used to configure wireless network interfaces (older, `iw` is often preferred now). (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`iftop`**: Displays bandwidth usage on an interface (needs installation: `sudo apt install iftop`). (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))
* **`tcpdump`**: Powerful command-line packet analyzer; allows the user to intercept and display TCP/IP and other packets being transmitted or received over a network. (Source: [Linux Network Commands Cheat Sheet | phoenixNAP KB](https://phoenixnap.com/kb/linux-network-commands))

### Log File Analysis

* **`journalctl`**: Queries and displays messages from the systemd journal.
    * `journalctl -xe`: Shows the latest journal entries with explanations for errors.
    * `journalctl -u <service-name>`: Shows logs for a specific systemd unit/service.
    * `journalctl -k`: Shows kernel messages from the current boot. (Source: [Driver Errors with Ubuntu 22.04 and 24.04 New Installation or Kernel 6.8 (or Later) Upgrade - NI](https://www.ni.com/docs/en-US/bundle/ni-platform-on-linux-desktop/page/iommu-linux.html))
    * `journalctl | grep -i <pattern>`: Filters journal output for a specific pattern. (Source: [Driver Errors with Ubuntu 22.04 and 24.04 New Installation or Kernel 6.8 (or Later) Upgrade - NI](https://www.ni.com/docs/en-US/bundle/ni-platform-on-linux-desktop/page/iommu-linux.html))
* **Viewing traditional log files in `/var/log/`**:
    * `cat /var/log/syslog`: Displays the entire system log. (Use with caution on large files). (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux), [Viewing and monitoring log files - Ubuntu](https://ubuntu.com/tutorials/viewing-and-monitoring-log-files))
    * `less /var/log/syslog`: Allows scrolling through the system log. (Source: [Viewing and monitoring log files - Ubuntu](https://ubuntu.com/tutorials/viewing-and-monitoring-log-files))
    * `tail /var/log/syslog`: Shows the last few lines of the system log.
    * `tail -f /var/log/syslog`: Monitors the system log in real-time. (Source: [Viewing and monitoring log files - Ubuntu](https://ubuntu.com/tutorials/viewing-and-monitoring-log-files))
    * `grep <pattern> /var/log/syslog`: Searches for a specific pattern in the system log. (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux))
    * Other important log files:
        * `/var/log/auth.log`: Authentication logs (logins, sudo usage). (Source: [Viewing and monitoring log files - Ubuntu](https://ubuntu.com/tutorials/viewing-and-monitoring-log-files))
        * `/var/log/kern.log`: Kernel messages. (Source: [Viewing and monitoring log files - Ubuntu](https://ubuntu.com/tutorials/viewing-and-monitoring-log-files))
        * `/var/log/dpkg.log`: Package installation/removal logs.
        * `/var/log/apt/history.log`: APT command history.
        * `/var/log/Xorg.0.log`: X11 server logs (for display/graphics issues on Desktop). (Source: [Viewing and monitoring log files - Ubuntu](https://ubuntu.com/tutorials/viewing-and-monitoring-log-files))
* `gnome-logs` (GUI): A graphical log viewer for GNOME desktop environments. (Source: [How do I detect any problem with my system? - Ask Ubuntu](https://askubuntu.com/questions/1426447/how-do-i-detect-any-problem-with-my-system))
* Check `/var/crash/` for crash dump files. (Source: [How do I detect any problem with my system? - Ask Ubuntu](https://askubuntu.com/questions/1426447/how-do-i-detect-any-problem-with-my-system))

### Process and Performance Monitoring

* **`top`**: Displays Linux processes, providing a dynamic real-time view of a running system. Shows CPU usage, memory usage, and other process information.
* **`htop`**: An interactive process viewer, similar to `top` but more user-friendly. (May need installation: `sudo apt install htop`).
* **`ps aux`**: Shows all running processes on the system.
* **`pstree`**: Shows running processes as a tree.
* **`vmstat`**: Reports virtual memory statistics.
* **`iostat`**: Reports CPU statistics and input/output statistics for devices and partitions.
* **`kill <PID>`**: Sends a signal to terminate a process (use with caution).
* **`sudo s-tui`**: A terminal UI for monitoring CPU temperature, frequency, power and utilization (needs installation: `sudo apt install stress-ng s-tui`). (Source: [How do I diagnose my issue, when I'm not sure if it is a hardware or software issue? - Ask Ubuntu](https://askubuntu.com/questions/1384357/how-do-i-diagnose-my-issue-when-im-not-sure-if-it-is-a-hardware-or-software-is))
* **`stress-ng`**: A tool to stress test your system (CPU, memory, I/O). (Source: [How do I diagnose my issue, when I'm not sure if it is a hardware or software issue? - Ask Ubuntu](https://askubuntu.com/questions/1384357/how-do-i-diagnose-my-issue-when-im-not-sure-if-it-is-a-hardware-or-software-is))

### Package Management Diagnostics (APT)

* **`sudo apt update`**: Resynchronizes the package index files from their sources.
* **`sudo apt upgrade`**: Installs the newest versions of all packages currently installed on the system.
* **`sudo apt full-upgrade`**: Also installs the newest versions but may remove packages if needed to upgrade others.
* **`sudo apt install -f`** or **`sudo apt --fix-broken install`**: Attempts to fix broken package dependencies.
* **`dpkg -l | grep <package_name>`**: Checks if a package is installed and shows its version.
* **`sudo dpkg --configure -a`**: Configures any unpacked but unconfigured packages.
* **`apt-cache policy <package_name>`**: Shows the installation status and available versions of a package.
* **`sosreport`**: While often associated with Red Hat, `sosreport` can also be installed and used on Ubuntu (`sudo apt-get install sosreport`). It collects a wide range of system configuration and diagnostic information. (Source: [Introduction to Basic Troubleshooting Terminal Commands in Ubuntu Linux | Dell US](https://www.dell.com/support/kbdoc/en-us/000123974/introduction-to-basic-troubleshooting-commands-within-ubuntu-linux))

This list provides a good starting point for diagnosing various issues on Ubuntu 22.04 systems. The best command to use will depend on the specific problem you are encountering. Remember to use `sudo` for commands that require root privileges.
