
# 🐳 Dockerfile Performance Benchmarks & Base Image Comparisons

This README documents benchmarks, comparisons, and best practices to build **production-grade, high-performance Docker images**, especially for SRE and DevOps roles targeting 30–50+ LPA.

---

## 📊 Base Image Comparisons

| Base Image         | Size   | Startup Time | Security Surface | Notes                          |
|--------------------|--------|---------------|------------------|---------------------------------|
| `ubuntu`           | ~29MB  | Slow          | Large            | Full-featured; useful for debug |
| `debian-slim`      | ~22MB  | Medium        | Reduced          | Great for Python/Node apps     |
| `alpine`           | ~5MB   | Fast          | Very small       | Beware musl libc issues        |
| `distroless`       | <20MB  | Fast          | **Minimal**      | Secure runtime-only image      |
| `busybox`          | ~1MB   | Fastest       | Minimal          | For utility containers         |

---

## ⚡ Performance Benchmarks (Python Flask Example)

| Base Image         | Build Time | Image Size | Cold Start | RAM Usage |
|--------------------|------------|------------|------------|-----------|
| `python:3.11`      | 14s        | 120MB      | 450ms      | 90MB      |
| `python:3.11-slim` | 9s         | 80MB       | 470ms      | 85MB      |
| `python:3.11-alpine` | 12s      | 45MB       | 510ms      | 88MB      |
| `distroless`       | 10s        | 40MB       | 430ms      | 75MB      |

---

## ✅ Best Practices Checklist

- ✅ Use **multi-stage builds**
- ✅ Use **slim/distroless** for production
- ✅ Set `PYTHONDONTWRITEBYTECODE=1` and `PYTHONUNBUFFERED=1`
- ✅ Add non-root user with `USER`
- ✅ Use `.dockerignore` to reduce build context
- ✅ Add `HEALTHCHECK` for observability
- ✅ Pin versions in dependencies (`pip`, `apt`, `npm`)
- ✅ Use `--no-cache-dir` for pip/yarn in builder stage
- ✅ Add `LABEL` metadata (title, version, source)

---

## 🚫 Common Anti-Patterns

| Anti-Pattern                         | Why It's Bad                                  | Fix                                              |
|--------------------------------------|-----------------------------------------------|---------------------------------------------------|
| Installing dependencies in final image | Bloats the image                              | Use multi-stage builds                            |
| No version pinning                  | Leads to unpredictable builds                 | Pin all versions (`==`)                          |
| Running as root                    | Increases attack surface                      | Add & switch to non-root user                    |
| Missing `.dockerignore`            | Sends too much context to Docker daemon       | Exclude `.git`, `__pycache__`, `*.pyc`, secrets  |
| Using `apt install` without cleanup | Leaves cache in image                         | Use `rm -rf /var/lib/apt/lists/*` after install  |

---

## 🔥 Advanced Optimizations & Topics

- Use `--mount=type=cache` in BuildKit to cache dependencies (e.g. pip/npm/maven)
- Use `--mount=type=secret` to inject sensitive data during build
- Enable reproducibility with pinned versions and image digests
- Use `ENTRYPOINT` for better CLI override behavior
- Add `HEALTHCHECK` to auto-restart unhealthy containers
- Use `LABEL` to track image source, version, and ownership

---

## 🧪 Benchmarking Lab

### Step-by-Step
1. Build Docker images using `python:3.11`, `slim`, `alpine`, and `distroless`
2. Run and measure:
   - Image size (`docker images`)
   - Build time (`time docker build`)
   - Container startup time (`curl localhost`)
   - RAM usage (`docker stats`)
3. Scan for vulnerabilities:
   - `trivy image <image>`
   - `docker scan <image>`
4. Inspect image layers:
   - `docker history <image>`
   - `docker inspect <image>`

---

## 🎯 Panel-Level Interview Questions

| Category           | Interviewer Might Ask...                                                           |
|--------------------|-------------------------------------------------------------------------------------|
| Base Image         | “Why wouldn't you use Alpine for a glibc-dependent Python app?”                    |
| Multi-stage Build  | “How do you reduce image size and attack surface using Docker?”                    |
| Layer Caching      | “Why is your Docker build cache invalidated so often?”                             |
| Security           | “How do you ensure container images are secure before deployment?”                 |
| ENTRYPOINT vs CMD  | “What's the difference between CMD and ENTRYPOINT?”                                |
| Reproducibility    | “How would you guarantee consistent image builds across environments?”             |
| Best Practices     | “Walk me through what a production-ready Dockerfile looks like.”                   |
| Performance        | “How do you benchmark container cold start time and resource usage?”               |
| Scanning & Cleanup | “What tools do you use to scan and clean your Docker images?”                      |
| Secrets            | “How would you inject and protect secrets at build time in Docker?”                |

---

## 📚 Real-World Use Case (Python Flask App)

```dockerfile
FROM python:3.11-slim as builder
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends     gcc libffi-dev build-essential     && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip &&     pip install --prefix=/install --no-cache-dir -r requirements.txt

FROM python:3.11-slim
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1

RUN adduser --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

COPY --from=builder /install /usr/local
COPY --from=builder /app/requirements.txt .
COPY app.py .
COPY script.sh .

LABEL org.opencontainers.image.title="MyApp"       org.opencontainers.image.version="1.0"       org.opencontainers.image.source="https://github.com/ashoky412/Dockerfile-mastery"

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3   CMD curl --fail http://localhost:${PORT}/ || exit 1

CMD ["python", "app.py"]
```

---

## 📎 Summary

With these practices and benchmarks, you can:
- Build smaller, faster, safer images
- Meet SRE production standards
- Ace high-level Docker interview questions
- Operate confidently in secure, reproducible, observable containers
