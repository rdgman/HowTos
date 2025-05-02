let's refine the previous example. We'll keep the policy of blocking outgoing internet access (`output policy drop`) but tighten the `input` rules.

The goal now is to ensure that **only specific client hosts** on your LAN can connect to **specific database (DB) and web server ports** on your server(s), while blocking other incoming LAN traffic.

This configuration assumes these rules are applied **directly on the server(s)** you want to protect (i.e., on the web server or the database server via their `input` chain).

**1. Define Your Assets**

First, let's define the IP addresses of the clients allowed access and the ports for the services.

```nftables
    # Define allowed client hosts (adjust IPs as needed)
    define allowed_clients_ipv4 = { 192.168.1.50, 192.168.1.51 }
    # define allowed_clients_ipv6 = { fd00::50, fd00::51 } # Add if needed
    define allowed_clients = { 192.168.1.50, 192.168.1.51 } # Add IPv6 if needed, e.g., { 192.168.1.50, 192.168.1.51, fd00::50, fd00::51 }

    # Define server ports
    define web_ports = { http, https } # Ports 80, 443
    define db_ports = { 3306, 5432 }    # Example: MySQL (3306), PostgreSQL (5432) - Adjust as needed
```

**2. Configure the `input` Chain on the Server**

The main changes happen in the `input` chain. We replace general "allow SSH/HTTP/S" rules with specific rules matching allowed source IPs *and* destination ports.

```nftables
    # --- INPUT CHAIN (on the Web/DB Server) ---
    chain input {
        type filter hook input priority 0;
        policy drop; # Default DROP for incoming

        # --- Essential Allows ---
        # Allow established/related connections (replies to outgoing, related ICMP etc)
        ct state established,related accept comment "Allow established connections"

        # Allow all input from loopback interface
        iifname "lo" accept comment "Accept loopback input"

        # Allow basic ICMP (e.g., ping) from allowed clients only (optional tightening)
        ip saddr $allowed_clients_ipv4 icmp type echo-request limit rate 4/second accept comment "Allow ping from specific v4 clients"
        # ip6 saddr $allowed_clients_ipv6 ip6 nexthdr icmpv6 icmpv6 type echo-request limit rate 4/second accept comment "Allow ping from specific v6 clients"
        # Or, allow from anywhere on LAN if preferred (replace saddr match)
        # icmp type echo-request limit rate 4/second accept

        # --- Service-Specific Allows from Specific Clients ---

        # Allow Web Access (if this IS a web server)
        ip saddr $allowed_clients_ipv4 tcp dport $web_ports accept comment "Allow Web traffic from specific v4 clients"
        # ip6 saddr $allowed_clients_ipv6 tcp dport $web_ports accept comment "Allow Web traffic from specific v6 clients"
        # OR using combined inet set:
        # inet saddr $allowed_clients tcp dport $web_ports accept comment "Allow Web traffic from specific clients (v4/v6)"

        # Allow DB Access (if this IS a DB server)
        ip saddr $allowed_clients_ipv4 tcp dport $db_ports accept comment "Allow DB traffic from specific v4 clients"
        # ip6 saddr $allowed_clients_ipv6 tcp dport $db_ports accept comment "Allow DB traffic from specific v6 clients"
        # OR using combined inet set:
        # inet saddr $allowed_clients tcp dport $db_ports accept comment "Allow DB traffic from specific clients (v4/v6)"

        # Allow SSH access (e.g., for administration) ONLY from specific clients (recommended)
        # You might want a separate 'admin_clients' set for this
        ip saddr $allowed_clients_ipv4 tcp dport ssh accept comment "Allow SSH from specific v4 clients"
        # ip6 saddr $allowed_clients_ipv6 tcp dport ssh accept comment "Allow SSH from specific v6 clients"
        # OR using combined inet set:
        # inet saddr $allowed_clients tcp dport ssh accept comment "Allow SSH from specific clients (v4/v6)"


        # --- End of Allow Rules ---

        # Optional: Log dropped input packets
        log prefix "[nftables drop input]: " counter drop
    }
```

**Explanation:**

* **`policy drop`:** Ensures that any incoming packet not explicitly matched by an `accept` rule is dropped.
* **`ct state established,related accept`:** Still crucial. This allows return traffic for connections initiated *by* the server (if any were allowed by the `output` chain) and related traffic like ICMP errors.
* **`iifname "lo" accept`:** Essential for the server's internal processes.
* **`ip saddr $allowed_clients_ipv4 ... accept`:** This is the core logic. It checks if the source IP address (`saddr`) of the incoming packet matches one of the IPs defined in the `$allowed_clients_ipv4` set. Only if the source IP matches *and* the destination port (`dport`) matches the allowed service ports (`$web_ports`, `$db_ports`, `ssh`) will the packet be accepted.
* **IPv6 / `inet`:** Corresponding rules using `ip6 saddr` or combined `inet saddr` should be used if your clients or servers use IPv6.
* **Service Separation:** Notice you only include the rules relevant to the server type. A dedicated web server wouldn't need the `dport $db_ports` rule in its `input` chain, and a DB server wouldn't need the `dport $web_ports` rule.

**3. Keep the `output` Chain (Blocking Internet)**

The `output` chain configuration from the previous example remains largely the same, ensuring the server itself cannot initiate connections to the internet but can communicate internally as needed (especially loopback and replies).

```nftables
    # --- OUTPUT CHAIN (on the Web/DB Server - Blocks Internet Access) ---
    chain output {
        type filter hook output priority 0;
        policy drop; # DEFAULT DROP FOR OUTGOING

        # Essential: Allow loopback
        oifname "lo" accept comment "Allow loopback traffic"

        # Allow established/related outgoing (essential for replies)
        ct state established,related accept comment "Allow established outgoing"

        # Optional: Allow server to initiate connections TO allowed clients if needed
        # (e.g., for monitoring checks, reverse connections)
        # ip daddr $allowed_clients_ipv4 accept comment "Allow OUTGOING connections TO specific clients"
        # ip6 daddr $allowed_clients_ipv6 accept comment "Allow OUTGOING connections TO specific clients"

        # Optional: Allow server to connect to OTHER specific internal servers if needed
        # (e.g., web server connecting to DB server)
        # define other_server_ip = 192.168.1.XXX
        # ip daddr $other_server_ip tcp dport $db_ports accept comment "Allow OUTGOING to other specific server/port"

        # Log dropped outgoing packets (optional)
        log prefix "[nftables drop output]: " counter drop
    }
```

**4. Complete Example Snippet (`/etc/nftables.conf`)**

```nftables
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    # --- Definitions ---
    define allowed_clients_ipv4 = { 192.168.1.50, 192.168.1.51 }
    # define allowed_clients_ipv6 = { fd00::50, fd00::51 } # Add if needed
    define allowed_clients = { 192.168.1.50, 192.168.1.51 } # Combine if using inet rules

    define web_ports = { http, https } # 80, 443
    define db_ports = { 3306, 5432 }    # MySQL, PostgreSQL - Adjust

    # --- INPUT CHAIN (Apply on Web Server OR DB Server) ---
    chain input {
        type filter hook input priority 0; policy drop;
        ct state established,related accept comment "Allow established connections"
        iifname "lo" accept comment "Accept loopback input"
        ip saddr $allowed_clients_ipv4 icmp type echo-request limit rate 4/second accept comment "Allow ping from specific v4 clients"
        # Add IPv6 ping if needed

        # === Rules FOR A WEB SERVER ===
        inet saddr $allowed_clients tcp dport $web_ports accept comment "Allow Web traffic from specific clients (v4/v6)"
        inet saddr $allowed_clients tcp dport ssh accept comment "Allow SSH from specific clients (v4/v6)" # If SSH needed

        # === Rules FOR A DB SERVER ===
        # inet saddr $allowed_clients tcp dport $db_ports accept comment "Allow DB traffic from specific clients (v4/v6)"
        # inet saddr $allowed_clients tcp dport ssh accept comment "Allow SSH from specific clients (v4/v6)" # If SSH needed

        log prefix "[nftables drop input]: " counter drop
    }

    # --- FORWARD CHAIN (Usually drop on server unless routing) ---
    chain forward {
        type filter hook forward priority 0; policy drop;
    }

    # --- OUTPUT CHAIN (Blocks Internet) ---
    chain output {
        type filter hook output priority 0; policy drop;
        oifname "lo" accept comment "Allow loopback traffic"
        ct state established,related accept comment "Allow established outgoing"
        # Add specific outgoing allowances if server needs to initiate connections
        log prefix "[nftables drop output]: " counter drop
    }
}
```

**To Use:**

1.  **Customize:** Adjust the IP addresses in `$allowed_clients*` and the ports in `$db_ports`.
2.  **Select Rules:** Uncomment/include only the rules relevant for the specific server (Web or DB) in the `input` chain.
3.  **Apply:** Save to `/etc/nftables.conf` on the specific server and run `sudo nft -f /etc/nftables.conf`.
4.  **Persistence:** Ensure the `nftables.service` is enabled and started.

This configuration provides granular control, allowing only designated client machines to access specific services on your servers within the LAN, while maintaining the block on internet access initiated by the server.
