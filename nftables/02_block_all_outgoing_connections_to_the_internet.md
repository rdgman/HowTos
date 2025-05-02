let's configure `nftables` to achieve the opposite of the typical firewall: block all outgoing connections to the internet by default, but explicitly allow connections to specific services or subnets within your local network (LAN).

This is primarily done by changing the default policy of the `output` chain to `DROP` and then adding specific `ACCEPT` rules for the traffic you want to permit.

**1. Basic Structure (in `/etc/nftables.conf`)**

First, you'll need a table and the `output` chain defined with a default policy of drop. We'll use the `inet` family to handle both IPv4 and IPv6.

```nftables
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    # Define your local LAN subnets (adjust as needed)
    define local_lan_ipv4 = { 192.168.1.0/24, 10.0.0.0/8 }
    define local_lan_ipv6 = { fd00::/8 } # Example for IPv6 Unique Local Addresses

    # (Include input and forward chains as needed, perhaps from previous examples)
    # chain input { ... policy drop; ... }
    # chain forward { ... policy drop; ... }

    chain output {
        type filter hook output priority 0;
        policy drop; # Default action for outgoing packets is DROP

        # --- Add your ALLOW rules below ---

        # (Rules will go here)

        # --- End of ALLOW rules ---

        # Optional: Log dropped outgoing packets (useful for debugging)
        # log prefix "[nftables drop output]: " counter drop
    }
}
```

**2. Essential Rule: Allow Loopback Traffic**

Your system needs to talk to itself via the loopback interface (`lo`, addresses `127.0.0.1` and `::1`). This must be allowed *before* the general drop policy takes effect. Add this rule near the top of your `output` chain:

```nftables
        # Allow all traffic destined for the loopback interface
        oifname "lo" accept comment "Allow loopback traffic"
```
* `oifname "lo"`: Matches packets going out via the interface named "lo".
* `accept`: Allows these packets.

**3. Example 1: Allow ALL Outgoing Traffic to Specific LAN Subnets**

If you trust your entire LAN and want this machine to be able to connect to *any* service on *any* host within your defined LAN subnets, add these rules:

```nftables
        # Allow any connection to local IPv4 subnets
        ip daddr $local_lan_ipv4 accept comment "Allow all outgoing to local IPv4 LAN"

        # Allow any connection to local IPv6 subnets
        ip6 daddr $local_lan_ipv6 accept comment "Allow all outgoing to local IPv6 LAN"
```
* `ip daddr $local_lan_ipv4`: Matches packets whose IPv4 destination address is within the set defined by `$local_lan_ipv4`.
* `ip6 daddr $local_lan_ipv6`: Matches packets whose IPv6 destination address is within the set defined by `$local_lan_ipv6$.
* `accept`: Allows these packets.

**4. Example 2: Allow Specific Services to LAN**

This is generally more secure. Instead of allowing everything, you only allow specific protocols and ports needed for communication within the LAN.

```nftables
        # --- Rules for specific services ---

        # Allow outgoing SSH (TCP port 22) to any host in the LAN
        ip daddr $local_lan_ipv4 tcp dport ssh accept comment "Allow outgoing SSHv4 to LAN"
        ip6 daddr $local_lan_ipv6 tcp dport ssh accept comment "Allow outgoing SSHv6 to LAN"
        # Note: 'ssh' is usually translated to port 22 by nftables

        # Allow outgoing HTTP/HTTPS (TCP ports 80, 443) to any host in the LAN
        ip daddr $local_lan_ipv4 tcp dport { http, https } accept comment "Allow outgoing HTTP/S v4 to LAN"
        ip6 daddr $local_lan_ipv6 tcp dport { http, https } accept comment "Allow outgoing HTTP/S v6 to LAN"
        # Note: { http, https } is a set containing ports 80 and 443

        # Allow outgoing DNS (UDP/TCP port 53) ONLY to specific local DNS servers
        define local_dns_servers = { 192.168.1.1, 192.168.1.2 } # Adjust IPs
        ip daddr $local_dns_servers udp dport domain accept comment "Allow outgoing DNS UDP to local resolvers"
        ip daddr $local_dns_servers tcp dport domain accept comment "Allow outgoing DNS TCP to local resolvers"
        # (Add IPv6 DNS servers if needed)

        # Allow outgoing SMB/CIFS (Windows File Sharing) to a specific file server or subnet
        define file_server_ip = 192.168.1.100 # Adjust IP
        # define smb_subnet = 192.168.1.0/24 # Alternative: Allow to whole subnet
        ip daddr $file_server_ip tcp dport { 139, 445 } accept comment "Allow outgoing SMB to specific file server"
        # ip daddr $smb_subnet tcp dport { 139, 445 } accept comment "Allow outgoing SMB to LAN subnet"
        # (Add UDP ports 137, 138 if NetBIOS name resolution/Browse over UDP is needed within the LAN)

        # Allow outgoing NTP (Network Time Protocol - UDP port 123) to local time servers
        define local_ntp_servers = { 192.168.1.5 } # Adjust IPs
        ip daddr $local_ntp_servers udp dport ntp accept comment "Allow outgoing NTP to local servers"
        # (Add IPv6 NTP servers if needed)
```

**Explanation of Specific Service Rules:**

* We match based on the destination IP address (`ip daddr`, `ip6 daddr`) being within the LAN or a specific server IP.
* We match the protocol (`tcp`, `udp`).
* We match the destination port (`dport`). You can use standard service names (`ssh`, `http`, `https`, `domain`, `ntp`) or port numbers (`139`, `445`). Sets `{...}` can group multiple ports.

**5. Using `inet` Family for Combined Rules**

If you only need to match IPs and ports (without protocol-specific options like TCP flags), you can combine IPv4 and IPv6 rules using the `inet` family and sets containing both address types:

```nftables
        # Define combined LAN set
        define local_lan = { 192.168.1.0/24, 10.0.0.0/8, fd00::/8 }

        # Allow outgoing SSH (TCP port 22) to LAN (Combined IPv4/IPv6)
        inet daddr $local_lan tcp dport ssh accept comment "Allow outgoing SSH (v4/v6) to LAN"

        # Allow outgoing HTTP/S (TCP ports 80, 443) to LAN (Combined IPv4/v6)
        inet daddr $local_lan tcp dport { http, https } accept comment "Allow outgoing HTTP/S (v4/v6) to LAN"
```
* `inet daddr $local_lan`: Matches packets where the destination (IPv4 or IPv6) is in the `$local_lan` set.

**6. Putting it Together (Example `/etc/nftables.conf`)**

Here's how the `output` chain might look with the loopback rule and rules allowing specific services (using combined `inet` where possible):

```nftables
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    define local_lan_ipv4 = { 192.168.1.0/24, 10.0.0.0/8 }
    define local_lan_ipv6 = { fd00::/8 }
    define local_lan = { 192.168.1.0/24, 10.0.0.0/8, fd00::/8 }
    define local_dns_servers = { 192.168.1.1, 192.168.1.2 }
    define file_server_ip = 192.168.1.100

    # --- INPUT CHAIN (Example: Allow established/related, SSH) ---
    chain input {
        type filter hook input priority 0;
        policy drop;

        ct state established,related accept comment "Allow established connections"
        iifname "lo" accept comment "Accept loopback input"
        tcp dport ssh accept comment "Allow incoming SSH"
        # Add other necessary input rules (e.g., ICMP)
        icmp type echo-request limit rate 4/second accept
        ip6 nexthdr icmpv6 icmpv6 type echo-request limit rate 4/second accept

        # Log dropped input packets (optional)
        log prefix "[nftables drop input]: " counter drop
    }

    # --- FORWARD CHAIN (Usually drop unless routing) ---
    chain forward {
        type filter hook forward priority 0;
        policy drop;
    }

    # --- OUTPUT CHAIN (Block internet, allow LAN) ---
    chain output {
        type filter hook output priority 0;
        policy drop; # DEFAULT DROP FOR OUTGOING

        # Essential: Allow loopback
        oifname "lo" accept comment "Allow loopback traffic"

        # Allow established/related outgoing (often helpful, simplifies state)
        ct state established,related accept comment "Allow established outgoing"

        # Allow specific services to LAN
        inet daddr $local_lan tcp dport ssh accept comment "Allow outgoing SSH (v4/v6) to LAN"
        inet daddr $local_lan tcp dport { http, https } accept comment "Allow outgoing HTTP/S (v4/v6) to LAN"

        # Allow DNS only to specific local servers (IPv4 example)
        ip daddr $local_dns_servers udp dport domain accept comment "Allow outgoing DNS UDP to local resolvers"
        ip daddr $local_dns_servers tcp dport domain accept comment "Allow outgoing DNS TCP to local resolvers"

        # Allow SMB only to specific file server (IPv4 example)
        ip daddr $file_server_ip tcp dport { 139, 445 } accept comment "Allow outgoing SMB to specific file server"

        # Allow ICMP echo requests (ping) outbound to LAN
        inet daddr $local_lan icmp type echo-request accept comment "Allow outgoing ping (v4) to LAN"
        inet daddr $local_lan ip6 nexthdr icmpv6 icmpv6 type echo-request accept comment "Allow outgoing ping (v6) to LAN"

        # Log dropped outgoing packets (optional, must be last rule before implicit drop)
        log prefix "[nftables drop output]: " counter drop
    }
}

```

**7. Activation**

Save the rules to `/etc/nftables.conf` (or another file) and apply them using:

```bash
sudo nft -f /etc/nftables.conf
```

Remember to enable and start the `nftables.service` if you want the rules to persist across reboots:

```bash
sudo systemctl enable nftables
sudo systemctl start nftables
```

This setup effectively isolates the machine from initiating connections to the internet while allowing necessary communication within your defined local network segments. Adjust the subnets, IPs, and allowed ports according to your specific LAN setup and needs.
