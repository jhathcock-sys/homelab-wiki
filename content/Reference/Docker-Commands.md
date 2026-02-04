# Docker Commands

[[_Index|← Back to Index]]

---

## Container Management

### Check running containers
```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'
```

### List compose projects
```bash
docker compose ls
```

### Check container health
```bash
docker inspect <container> --format '{{json .State.Health}}'
```

### View container logs
```bash
docker logs <container> --tail 50
```

### Restart a stack
```bash
cd /opt/<stack-name> && docker compose up -d
```

---

## Stack Management

### Deploy/update stack
```bash
cd /opt/<stack-name>
docker compose up -d
```

### Stop stack
```bash
docker compose down
```

### Rebuild without cache
```bash
docker compose build --no-cache
docker compose up -d
```

### View stack resource usage
```bash
docker stats
```

---

## SSH Key Setup

For remote management, SSH keys were set up:

```bash
# Generate Ed25519 key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy to remote hosts
ssh-copy-id root@192.168.1.XXX      # ProxMoxBox
ssh-copy-id cib@192.168.1.XXX     # Pi5
```

---

## Troubleshooting Commands

### Check disk usage
```bash
docker system df
```

### Clean up unused resources
```bash
docker system prune -a
```

### Inspect container configuration
```bash
docker inspect <container> | less
```

### Check container processes
```bash
docker top <container>
```

### Execute command in container
```bash
docker exec -it <container> sh
```

---

## Related Pages

- [[Troubleshooting]]
- [[GitOps-Workflow]]
- [[Dockhand]]
