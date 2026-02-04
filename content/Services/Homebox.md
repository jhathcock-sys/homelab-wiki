# Homebox Inventory System

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX:3100]] | **Stack:** [[GitOps-Workflow|homelab-ops/proxmox/homelab-tools/]]

---

## Overview

Inventory management application for homelab equipment and assets.

---

## Access

```
http://192.168.1.XXX:3100
```

---

## Health Fix

### Problem
Homebox showed as "unhealthy" despite working correctly.

### Cause
Built-in healthcheck was checking port 7745 (old default), but container was configured for port 3100 via `HBOX_WEB_PORT=3100`.

### Solution
Added custom healthcheck to compose file:
```yaml
healthcheck:
  test: ["CMD", "wget", "--no-verbose", "--tries=1", "-O", "-", "http://localhost:3100/api/v1/status"]
  interval: 30s
  timeout: 5s
  retries: 3
  start_period: 5s
```

---

## Configuration

### Environment Variables
```yaml
environment:
  HBOX_WEB_PORT: 3100
  HBOX_LOG_LEVEL: info
  HBOX_STORAGE_DATA: /data/
  HBOX_STORAGE_SQLITE_URL: /data/homebox.db
```

### Secrets
Secret encryption key stored in `/opt/homelab-tools/.env`:
```
SECRET_ENCRYPTION_KEY=<your-key-here>
```

**Security Note:** Moved from hardcoded value in compose file to environment file.

---

## Related Pages
- [[GitOps-Workflow]]
- [[Environment-Files]]
- [[Troubleshooting#Healthcheck Failing]]
