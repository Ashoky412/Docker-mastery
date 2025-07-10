# 🚀 Docker Volumes Deep Dive Guide

This README consolidates everything you need to know about **Docker Volumes**, including:
- Named Volumes
- Bind Mounts
- Real-world SRE usage
- Behavior deep dive
- EC2 context
- Interview Q&A
- Full command reference

---

## 📦 1. What Are Docker Volumes?

Docker volumes are persistent data storage mechanisms **outside of the container lifecycle**.

### Types of Volumes:
| Type         | Description                                |
|--------------|--------------------------------------------|
| Named Volume | Docker-managed persistent data store       |
| Bind Mount   | Host path directly mounted into container  |
| Anonymous    | Auto-named, temporary volume               |

---

## 🔧 2. Creating Volumes

### 📌 Named Volume
```bash
docker volume create myvolume
docker run -v myvolume:/app/data myimage
```

### 📌 Bind Mount
```bash
mkdir -p ~/bind-logs
docker run -v ~/bind-logs:/app/logs myimage
```

---

## 🔁 3. Behavior on Container Re-Create

| Action               | Named Volume        | Bind Mount         |
|----------------------|---------------------|---------------------|
| Container deleted    | ✅ Data persists     | ✅ Data persists     |
| Viewable on host     | ❌ (indirect only)   | ✅ (directly)        |
| Re-usable by others  | ✅ Easy              | ✅ Path-specific     |

---

## 📂 4. Read or Inspect Volume Contents

### Named Volume
```bash
docker run --rm -v myvolume:/data busybox ls /data
docker run --rm -v myvolume:/data busybox cat /data/log.txt
```

### Bind Mount
```bash
ls ~/bind-logs
cat ~/bind-logs/log.txt
```

---

## 🔒 5. Read-Only Mounts

```bash
docker run -v ~/config:/app/config:ro myimage
```

---

## 🛑 6. Volume Deletion

```bash
docker volume ls
docker volume inspect myvolume
docker volume rm myvolume
docker volume prune  # remove all unused volumes
```

---

## 🧪 7. SRE Use Cases

| Use Case         | Recommended Volume Type | Reason                                    |
|------------------|--------------------------|--------------------------------------------|
| Logs             | Bind Mount               | View/rotate from host                     |
| Database storage | Named Volume             | Isolation, portability, snapshot-friendly |
| Runtime configs  | Bind Mount (read-only)   | Controlled host-level injection           |
| Shared dev code  | Bind Mount               | Hot-reload, live editing                  |

---

## 🧠 8. Interview Q&A

### Q: Why use named volume over bind mount?
✅ Named volumes are portable, docker-managed, easier to back up.

### Q: Where is volume data stored?
- Named: `/var/lib/docker/volumes/<name>/_data`
- Bind: Your specified host path

---

## 🧳 9. EC2-Specific Notes

| Feature             | Named Volume                         | Bind Mount                          |
|---------------------|--------------------------------------|-------------------------------------|
| Path                | Docker managed                       | Custom path on EC2 host             |
| Portability         | Easy                                 | Hardcoded                           |
| Access by OS tools  | Not direct                           | ✅ (e.g. logrotate, cron)           |

---

## 🧰 10. Useful Commands Summary

### 🔧 Volume Management
```bash
docker volume create myvol
docker volume ls
docker volume inspect myvol
docker volume rm myvol
docker volume prune
```

### 📂 Inspect Contents
```bash
docker run --rm -v myvol:/data busybox ls /data
docker run --rm -v ~/bind-logs:/data busybox ls /data
```

### 🧪 Run Containers
```bash
docker run -v myvol:/app/data myimage
docker run -v ~/bind-logs:/app/logs myimage
docker run -v ~/config:/app/config:ro myimage
```

### 🗃️ Backups
```bash
# Named Volume
docker run --rm -v myvol:/data -v $(pwd):/backup busybox tar czf /backup/myvol.tar.gz /data

# Bind Mount
tar czf backup.tar.gz ~/bind-logs
```

---

## 🧪 Bonus Lab Challenge

1. Create a named volume & a bind mount
2. Use both to store logs from different containers
3. Re-run containers and check persistence
4. Try read-only mount
5. Backup & inspect both types

---
