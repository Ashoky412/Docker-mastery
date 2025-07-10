# Docker SRE Mastery

## Cheat Sheet
```

# Docker SRE Cheat Sheet

##  Lifecycle
- `docker run -it ubuntu bash`  Run container
- `docker stop/start/restart <container>`  Control lifecycle
- `docker exec -it <container> bash`  Access container
- `docker logs -f <container>`  View logs

##  Inspect & Debug
- `docker inspect <container>`  Metadata
- `docker stats`  Resource usage
- `docker top <container>`  Running processes

##  Volumes & Networking
- `docker run -v /host:/container`  Mount volume
- `docker network inspect <network>`  View network config
- `docker exec -it container ping other`  DNS test

##  Security & Resource Limits
- `--user nobody` | `--read-only` | `--cap-drop ALL`
- `--memory=512m` | `--cpus=1`

##  Restart & Health
- `--restart=on-failure:3`
- `HEALTHCHECK CMD curl -f http://localhost/health || exit 1`

##  Logs
- `--log-driver=json-file` with rotation options

##  Image Debugging
- `docker history <image>`  Layer insight
- `docker image inspect <image>`  Deep dive

```
## Labs
```

# Docker SRE Lab Guide

## Lab 1: Crash Loop Investigation
- Run `docker run --name failapp myapp`
- `docker logs failapp`  Identify crash
- `docker inspect failapp`  Exit code check

## Lab 2: Debug Broken Health Check
- `docker run --health-cmd "curl -f http://localhost || exit 1"`
- `docker inspect <container>`  Check Health.Status

## Lab 3: Simulate OOM
- `docker run --memory=100m --name oomtest ubuntu stress --vm 1 --vm-bytes 200M --vm-hang 0`
- `docker inspect oomtest`  Look for OOMKilled

## Lab 4: Broken Volume Mount
- Mount a non-existent host path and debug
- `docker inspect`  `.Mounts` info

## Lab 5: Network Debug
- Two containers in bridge network
- Use `ping`, `curl`, and `nslookup` to debug DNS/IP

```
## Interview Q&A
```

# Docker SRE Interview Q&A

##  L1 Round
- What is the difference between an image and a container?
- How do you access logs from a container?
- How do you mount a volume?

##  L2 Round
- How do you debug a container that restarts continuously?
- Explain Docker networking types.
- What is the role of namespaces and cgroups?

##  L3 Round
- How do you troubleshoot high CPU usage in a container?
- Explain how Docker handles DNS resolution.
- What happens when a container exceeds memory limit?

##  Panel Round
- Walk through a production issue involving Docker and how you debugged it.
- How do you secure containers in a multi-tenant environment?
- How would you optimize image size for faster CI/CD?

## Bonus
- Describe the internals of container creation.
- Compare Docker with containerd and CRI-O.

```