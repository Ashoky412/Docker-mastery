# 🐳 Dockerfile Optimization Guide – Complete SRE-Grade Summary

This guide is a comprehensive breakdown of how to create **production-grade Dockerfiles** with a strong focus on **performance, security, debuggability, and reliability** for SREs and DevOps engineers.

---

## 📦 Project Structure

```
.
├── Dockerfile
├── app.py
├── requirements.txt
├── script.sh
└── .dockerignore
```

---

## 🚀 Dockerfile Optimization – Best Practices

### ✅ Multi-Stage Build

```Dockerfile
FROM python:3.11-slim as builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libffi-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt
```

---

### ✅ Final Runtime Stage

```Dockerfile
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN adduser --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

COPY --from=builder /install /usr/local
COPY --from=builder /app/requirements.txt .
COPY app.py .
COPY script.sh .

ENV PORT=5000
ENV APP_USER="DockerUser"

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:${PORT}/ || exit 1

CMD ["python", "app.py"]
```

---

## 🧾 .dockerignore

```
__pycache__/
*.pyc
*.pyo
*.log
*.db
venv/
.env
.git
node_modules/
```

---

## 🔄 COPY vs ADD – Deep Dive

| Feature              | COPY        | ADD (more powerful, but risky)         |
|----------------------|-------------|----------------------------------------|
| Basic file copy      | ✅          | ✅                                      |
| Auto-extract .tar.gz | ❌          | ✅                                      |
| Fetch remote URLs    | ❌          | ✅ (but NOT recommended)               |
| Honors .dockerignore | ✅          | ✅                                      |
| Safer to use         | ✅ Recommended | ❌ Can cause unexpected behaviors     |

> ✅ Use `COPY` unless you need to extract tarballs.

---

## ⚙️ ARG vs ENV – Deep Dive

| Feature              | ARG (Build-time)     | ENV (Runtime + Build)            |
|----------------------|----------------------|----------------------------------|
| Scope                | Build only           | Runtime and build                |
| Persisted in image?  | ❌ No                | ✅ Yes (visible in `docker inspect`) |
| Use in CMD/ENTRY?    | ❌ No                | ✅ Yes                            |
| Redefinable in stages| ❌ Must redeclare    | ✅ Carries over                   |
| Secure for secrets   | ✅ Yes               | ❌ No                             |

> Combine them:
```Dockerfile
ARG VERSION
ENV VERSION=${VERSION}
```

---

## 🧠 Why Clean Up `apt-get`?

### What Happens:
- `apt-get update` downloads package indexes into `/var/lib/apt/lists/`
- If not deleted, they get baked into image layers forever

### Bad:
```Dockerfile
RUN apt-get update
RUN apt-get install curl
```

Layers:
1. Metadata
2. Packages
3. Cleanup? Too late!

### Good:
```Dockerfile
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*
```

> ✅ All in one layer = no bloat!

---

## 🧱 Docker Image Layers – Internals

| Layer Type      | Created By                |
|------------------|--------------------------|
| Base layer       | FROM ubuntu              |
| Instruction layer| RUN, COPY, ADD, etc.     |
| Final image      | Union of all layers      |

- Each layer is **immutable**
- Layers are **cached and reused**
- Docker images = **layered filesystem (OverlayFS)**

> ✅ Deleting files must happen in the **same RUN** command to actually reduce size.

---

## 🧠 ENTRYPOINT vs CMD

| Feature        | ENTRYPOINT              | CMD                         |
|----------------|--------------------------|------------------------------|
| Fixed command  | ✅ Cannot override easily| ✅ Override with `docker run` |
| Use for        | Entrypoint logic         | Default args                 |
| Can override?  | Only with `--entrypoint` | Yes                          |

**Analogy:**  
- `ENTRYPOINT`: Always go to kitchen  
- `CMD`: Eat cookie unless told otherwise

---

## 🧠 ENV by Language

| Language/Stack | ENV Vars                           | Purpose                             |
|----------------|-------------------------------------|--------------------------------------|
| Python         | `PYTHONUNBUFFERED`, `PYTHONDONTWRITEBYTECODE` | Clean logs, avoid `.pyc` files   |
| Java           | `JAVA_OPTS`, `-XX:+UseContainerSupport` | Memory tuning, GC awareness      |
| Node/React     | `NODE_ENV=production`               | Smaller builds, faster runtime       |

---

## ✅ Summary of Optimizations

- ✅ Use `COPY` over `ADD` for clarity
- ✅ Combine `RUN` lines for clean layers
- ✅ Clean up after package installs
- ✅ Use `--no-install-recommends` to avoid bloat
- ✅ Use `.dockerignore` effectively
- ✅ Use multi-stage builds
- ✅ Don’t store secrets in ENV
- ✅ Run as non-root
- ✅ Add health checks for observability
- ✅ Use ENTRYPOINT + CMD pattern properly

---

Happy Dockering!
