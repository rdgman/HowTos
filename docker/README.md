Here’s a **step-by-step guide** on how to **use the files** inside `traefik_swarm_ceph_setup.zip`, where to place them, and how to apply them on your 3-node cluster.

---

## 🔄 **1. Unpack the Files**

On each of your three servers:

```bash
unzip traefik_swarm_ceph_setup.zip -d ~/infra-setup
cd ~/infra-setup
```

---

## 🧠 **2. Configure Keepalived (VIP on eth1)**

### 🔧 On **each node**:

Edit `keepalived/keepalived.conf`:

* Change:

  * `state MASTER` ➝ `BACKUP` for node2 & node3
  * `priority`: 101 (primary), 100 (secondary), 99 (tertiary)
  * `interface`: change if your interface is not `eth1`

### 📍 Put the config here:

```bash
sudo cp keepalived/keepalived.conf /etc/keepalived/keepalived.conf
sudo systemctl restart keepalived
```

Use `ip a` or `ping 10.10.101.1` to test VIP failover.

---

## 🐳 **3. Initialise Docker Swarm**

### On **node1 (manager)**:

```bash
cd swarm
chmod +x init_swarm.sh
./init_swarm.sh
```

Copy the token and use it to replace `<token>` and `<manager_ip>` in `join_swarm.sh`.

### On **node2 and node3**:

```bash
cd swarm
chmod +x join_swarm.sh
./join_swarm.sh
```

---

## 🌐 **4. Create Overlay Network**

Run this on **any manager node**:

```bash
docker network create --driver=overlay --attachable traefik-public
```

---

## 🧭 **5. Deploy Traefik**

### On **any manager node**:

```bash
cd traefik
docker stack deploy -c traefik.yml traefik
```

Check:

```bash
docker service ls
```

Access Traefik dashboard at:

```
http://10.10.101.1:8080
```

---

## 💾 **6. Configure Admin Networking (eth0)**

### Use Netplan (Debian/Ubuntu):

Edit `/etc/netplan/01-netcfg.yaml`:

```bash
sudo cp netplan/ceph_network_config.yaml /etc/netplan/01-netcfg.yaml
sudo netplan apply
```

Make sure `eth0` has 172.16.x.x and `eth1` has 10.10.101.x IPs.

---

## 🐘 **7. Setup Ceph**

### If you're deploying Ceph manually:

* Place config at `/etc/ceph/ceph.conf`

```bash
sudo mkdir -p /etc/ceph
sudo cp ceph/ceph.conf /etc/ceph/ceph.conf
```

Replace placeholders like:

```ini
fsid = <UUID>
mon_host = 172.16.0.2,172.16.0.3,172.16.0.4
```

Use cephadm or your preferred Ceph deployer to bootstrap.

---

## ✅ **Checklist**

| Task                    | Command / Note                                     |
| ----------------------- | -------------------------------------------------- |
| Keepalived running      | `systemctl status keepalived`                      |
| Swarm initialized       | `docker node ls`                                   |
| Overlay network created | `docker network ls`                                |
| Traefik running         | `docker service ls`                                |
| Traefik dashboard       | [http://10.10.101.1:8080](http://10.10.101.1:8080) |
| Ceph conf in place      | `/etc/ceph/ceph.conf`                              |
| Admin net working       | `ip a show eth0`                                   |

---

Would you like me to also include a Ceph bootstrap example using `cephadm` or `ceph-deploy`?
