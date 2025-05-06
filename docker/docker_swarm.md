To set up **Traefik** with **Docker Swarm + Keepalived VIP + Ceph** on a 3-node cluster, here’s a **simple but scalable architecture and configuration approach** that balances service availability, admin separation, and storage concerns.

---

## 🧱 **Architecture Overview**

| Layer                | Details                                                                                                                          |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Hosts**            | 3 servers with dual interfaces:<br>- `eth0`: Admin – `172.16.x.x`<br>- `eth1`: VIP + Swarm – `10.10.101.2-4`, VIP: `10.10.101.1` |
| **VIP (Keepalived)** | Virtual IP on `eth1`: `10.10.101.1` — used for inbound traffic to Traefik                                                        |
| **Docker Swarm**     | - Init swarm on one node<br>- Join others as managers (or workers, depending on your HA model)                                   |
| **Traefik**          | Deployed as a global service (1 replica per node)<br>Bound to the VIP                                                            |
| **Ceph**             | Separate containers/disks; configure Ceph traffic on `eth0` (admin net)                                                          |
| **Network Zones**    | - Frontend: 10.10.101.x (public/services)<br>- Backend/admin: 172.16.x.x                                                         |

---

## ⚙️ **Configuration Plan**

### 1. **Keepalived (VIP Setup)**

Ensure `keepalived` runs on all 3 nodes with a floating IP `10.10.101.1` on `eth1`.

Basic config snippet (`/etc/keepalived/keepalived.conf`):

```conf
vrrp_instance VI_1 {
    state MASTER
    interface eth1
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 42abc
    }
    virtual_ipaddress {
        10.10.101.1
    }
}
```

Adjust priority and state (`BACKUP`) for other nodes.

---

### 2. **Docker Swarm Init**

From node1 (say `10.10.101.2`):

```bash
docker swarm init --advertise-addr 10.10.101.2
```

Then join others with:

```bash
docker swarm join --token <token> 10.10.101.2:2377
```

---

### 3. **Overlay Network for Traefik**

Create a Swarm overlay network:

```bash
docker network create --driver=overlay --attachable traefik-public
```

---

### 4. **Traefik Stack**

Prepare a `traefik.yml` stack file:

```yaml
version: "3.8"

services:
  traefik:
    image: traefik:v2.11
    command:
      - "--providers.docker.swarmMode=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--api.dashboard=true"
      - "--log.level=INFO"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080" # dashboard
    networks:
      - traefik-public
    deploy:
      mode: global
      placement:
        constraints: [node.role == manager]
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.api.rule=Host(`traefik.localhost`)"
        - "traefik.http.routers.api.service=api@internal"
        - "traefik.http.routers.api.entrypoints=web"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"

networks:
  traefik-public:
    external: true
```

Deploy:

```bash
docker stack deploy -c traefik.yml traefik
```

---

### 5. **Ceph Traffic Isolation (Optional but Recommended)**

Use Ceph’s `public_network` and `cluster_network` to isolate replication and admin traffic to `172.16.x.x`. Example:

```ini
public network = 172.16.0.0/16
cluster network = 172.16.0.0/16
```

Use systemd-networkd or Netplan to ensure interface routes persist across reboots.

---

## 🔐 **Security Tips**

* Expose Traefik dashboard only on internal 172 network or via VPN.
* Add Let’s Encrypt for public-facing services via DNS challenge (if needed).
* Apply strict firewall rules on both interfaces to control access.

---

## ✅ Summary

* **VIP (Keepalived):** Handles high availability on `eth1`.
* **Swarm + Traefik:** Runs as global service with overlay network.
* **Admin (172 net):** For Ceph replication, Traefik dashboard, and SSH.
* **Ceph:** Use disk isolation and bind to the 172 interface.
* **Simplicity:** Only a few moving parts — Swarm, Traefik, Ceph, Keepalived — but isolated by design.

Would you like me to generate a complete set of scripts or stack files for each component?
