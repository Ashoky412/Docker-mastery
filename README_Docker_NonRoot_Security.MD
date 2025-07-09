# 🔐 Why We Avoid Running Containers as root – SRE-Grade Guide

Running containers as `root` is dangerous and avoidable in secure, production-grade Dockerfiles. This guide explains **why using a non-root user matters**, the **risks of root containers**, and **how to mitigate them** properly.

---

## 🧠 What is root in Docker?

- Inside a container, `root` (UID 0) behaves like full-blown Linux root.
- Without `user namespaces` (which are OFF by default), this means:
  - Root in container = Root on host 😱

---

## 🚨 Why Root in Docker is Dangerous

| Risk              | Description |
|-------------------|-------------|
| Host takeover     | If the container breaks out, root becomes root on the host. |
| Volume abuse      | Can modify mounted volumes (even critical host paths). |
| Kernel access     | Can interact with `/proc`, `/sys`, etc., from inside container. |
| Escalation vector | Attackers exploit app, then system, then host. |

---

## ✅ What Happens When You Use a Non-Root User

```dockerfile
RUN adduser --disabled-password --gecos "" appuser
USER appuser
```

- Limits container to unprivileged actions
- Cannot modify system files
- Can't bind to ports < 1024
- Reduces risk in case of app compromise

---

## ⚠️ Non-Root is Not a Silver Bullet

| Still a Risk              | Why? |
|---------------------------|------|
| Vulnerable application    | Exploits still possible at app layer |
| Writable volumes          | Non-root may still write to data mounts |
| Misconfigured host        | Kernel bugs can break isolation |
| Over-permissioned configs | `--privileged`, `docker.sock`, etc., void non-root |

---

## 🔐 Secure Docker by Combining Layers of Defense

| Layer          | Tool or Flag                        | Purpose |
|----------------|--------------------------------------|---------|
| User           | `USER appuser` in Dockerfile         | Avoid root |
| Capabilities   | `--cap-drop=ALL`                     | Remove extra privileges |
| Read-only FS   | `--read-only`                        | Prevent filesystem writes |
| Seccomp        | `--security-opt seccomp=default.json`| Block syscalls |
| AppArmor/SELinux| Host profile enforcement            | Prevent container escape |
| No Docker sock | Don't mount `/var/run/docker.sock`   | Prevent host access |

---

## 🧪 Try It Yourself

```bash
docker run -it --rm --user 0 alpine sh         # root shell
docker run -it --rm --user 1000 alpine sh      # non-root shell
```

Now try:
```bash
touch /etc/passwd
```

✅ Root can  
❌ Non-root: "Permission denied"

---

## ✅ Summary

| Run As   | Risk   | Why                                |
|----------|--------|-------------------------------------|
| root     | ❌ High | Full control over container & host |
| non-root | ✅ Low  | Limits blast radius, safer default |

---

**Pro SRE Tip:** Running as non-root is your first wall. Use it with seccomp, readonly FS, AppArmor, and other layers for full protection.

