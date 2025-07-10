
# 🐳 Docker Networking - SRE Deep Dive

A practical, interview-ready guide to mastering Docker networking for production-scale SRE/DevOps roles.

---

## 🔧 Core Networking Concepts

| # | Concept                     | Description                                                                 |
|---|-----------------------------|-----------------------------------------------------------------------------|
| 1 | **Bridge Network**          | Default network with private IPs; containers can talk but no DNS resolution |
| 2 | **Host Network**            | Shares host network; no isolation; ultra-fast but less secure               |
| 3 | **None Network**            | No network; used for debugging and secure sandboxing                        |
| 4 | **User-Defined Bridge**     | Custom network with built-in DNS resolution via container names            |
| 5 | **Container ↔ Container**   | Communication via docker-compose or same custom network                    |
| 6 | **DNS Resolution**          | Uses Docker’s embedded DNS server at `127.0.0.11`                          |
| 7 | **Port Mapping**            | `-p HOST:CONTAINER`; enables external access to container ports            |
| 8 | **Multi-Network Containers**| One container in multiple networks (e.g., app & monitoring)                |
| 9 | **Troubleshooting**         | Tools: `curl`, `dig`, `ip route`, `tcpdump`, `nsenter`                     |

---

## 🧪 Real-World Labs

### ✅ Lab: User-Defined Network with DNS
```bash
docker network create mynet
docker run -d --name db --network mynet mysql
docker run -it --rm --network mynet busybox ping db
```

### ✅ Lab: Host Network Performance
```bash
docker run --rm --network host nginx
```

### ✅ Lab: None Network Debugging
```bash
docker run -it --network none busybox
```

### ✅ Lab: Multi-Network Container
```bash
docker network create net1
docker network create net2
docker run -d --name logger --network net1 alpine sleep 1000
docker network connect net2 logger
```

---

## 🎯 Interview Q&A

### Q: What is Docker’s default network?
**A:** `bridge` — provides isolated container communication with private IPs but no DNS resolution.

### Q: When should you use the host network?
**A:** For high-performance apps where you want direct access to the host’s network, like monitoring agents or real-time systems.

### Q: What does the none network do?
**A:** It fully disables networking for the container — useful for sandboxing or network-isolated workloads.

### Q: Why is a user-defined bridge preferred for services?
**A:** It provides DNS resolution by name (e.g., `ping db`) and better network isolation.

### Q: How do containers in different networks communicate?
**A:** They must be manually connected to each other’s networks using `docker network connect`.

### Q: How can you debug DNS issues inside a container?
**A:** Use `dig`, check `/etc/resolv.conf`, verify network settings, and inspect the network.

### Q: What tools are useful for Docker networking issues?
**A:** `curl`, `dig`, `ip route`, `tcpdump`, `nsenter` — for checking connectivity, routes, and DNS.

---

## 🔍 Troubleshooting Tips

| Tool       | Use Case                                       |
|------------|------------------------------------------------|
| `curl`     | Test HTTP access from container                |
| `ping`     | Test basic network reachability                |
| `dig`      | Resolve container names using Docker DNS       |
| `ip route` | Check container routing tables                 |
| `tcpdump`  | Capture packet-level network traffic           |
| `nsenter`  | Enter container namespaces for deep debugging  |

---

## 📦 Extras

- ✅ Cheat Sheet

# 📝 Docker Networking Cheat Sheet

## Network Types
- **bridge**: Default, isolated, no DNS by name
- **host**: Shares host's network, no isolation
- **none**: No network at all
- **user-defined bridge**: Custom network with DNS resolution

## Common Commands
- List networks: `docker network ls`
- Inspect network: `docker network inspect <name>`
- Create network: `docker network create <name>`
- Connect container: `docker network connect <network> <container>`
- Run with network: `docker run --network <name> ...`

## Troubleshooting
- Check IP: `ip addr`, `hostname -I`
- Routing: `ip route`
- DNS: `cat /etc/resolv.conf`, `dig`
- Capture packets: `tcpdump -i eth0`
- Enter namespace: `nsenter --target <PID> --net`

## Port Mapping
- Syntax: `-p HOST:CONTAINER`
- Ex: `-p 8080:80` exposes container port 80 on host 8080

## Real-World Scenarios
- App ↔ DB using user-defined bridge
- Logging container in multiple networks
- DNS failure debug with `dig` and `/etc/resolv.conf`

