# 🐳 Dockerfile Optimization Guide – Production-Ready Flask App

This repository demonstrates how to write a **secure**, **optimized**, and **production-grade Dockerfile** for a simple Python Flask app, with deep explanations for real-world SRE scenarios.

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

## 🚀 Dockerfile – Production Grade Breakdown

### 🔁 Multi-Stage Build

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

> Installs only necessary dependencies to keep the final image clean.

---

### 🧼 Final Runtime Stage

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

```dockerignore
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

## ⚙️ CMD vs ENTRYPOINT – Explained for All Levels

| Concept       | Description                                   | Override? | How                         |
|---------------|-----------------------------------------------|-----------|------------------------------|
| CMD           | Default args for container                    | ✅ Yes     | `docker run image arg`       |
| ENTRYPOINT    | Fixed command (can’t override easily)         | ❌ No      | Use `--entrypoint` flag      |

**🧸 Analogy:**  
- `CMD` = "Eat cookies unless I say otherwise."  
- `ENTRYPOINT` = "Always go to kitchen first."  
- Override = You shout: `--entrypoint 'stay in room'`!

---

## 🧠 ENV Best Practices by Stack

| Stack      | ENV Vars                                | Why                                    |
|------------|------------------------------------------|----------------------------------------|
| Python     | `PYTHONDONTWRITEBYTECODE=1`, `PYTHONUNBUFFERED=1` | Clean, real-time logs                  |
| Java       | `JAVA_OPTS`, `-XX:+UseContainerSupport` | Heap tuning, container awareness       |
| Node/React | `NODE_ENV=production`                   | Optimizes bundles, disables dev mode   |

---

## ✅ Benefits of This Dockerfile

- 🛡️ Non-root user
- 🧼 Multi-stage build = smaller image
- 🔍 Healthcheck for K8s readiness
- 📜 Minimal, reproducible, and secure
- 🐳 Perfect base for CI/CD pipelines & Kubernetes

---

Happy Dockering! 🔥
