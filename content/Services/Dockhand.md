# Dockhand Configuration

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX:3000]] | **Stack:** [[GitOps-Workflow|homelab-ops/proxmox/dockhand/]]

---

## Overview

Docker management UI for local and remote hosts. Manages stacks via compose files.

---

## Access

```
http://192.168.1.XXX:3000
```

---

## Location

```
/opt/dockhand/docker-compose.yml
```

---

## Docker Compose

```yaml
services:
  dockhand:
    image: fnsys/dockhand:latest
    container_name: dockhand
    restart: unless-stopped
    ports:
      - 3000:3000
    environment:
      - HOST_DATA_DIR=/opt
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro  # Read-only for security
      - dockhand_data:/app/data
      - /opt:/opt

volumes:
  dockhand_data:
```

---

## Key Configuration Notes

- **Docker Socket:** Required for Dockhand to see and manage containers
- **`/opt:/opt` mount:** Critical for Dockhand to access compose files and manage stacks
- **`HOST_DATA_DIR`:** Helps with path resolution for stack management

---

## Stack Adoption

### Problem
Containers appeared in Dockhand but couldn't be managed because:
1. Dockhand could see containers via Docker socket
2. Dockhand couldn't access the compose files (no `/opt` mount)

### Solution
1. Added `/opt:/opt` volume mount to Dockhand
2. Added `HOST_DATA_DIR=/opt` environment variable
3. Used **Import** feature in Dockhand UI to adopt existing stacks

### Importing Stacks (Local - ProxMoxBox)
1. Go to **Stacks** in Dockhand
2. Click **Import**
3. Browse to compose file paths:
   - `/opt/homepage/docker-compose.yaml`
   - `/opt/homelab-tools/compose.yaml`
   - `/opt/minecraft/docker-compose.yaml`
   - `/opt/uptimekuma/docker-compose.yaml`

---

## Hawser (Remote Docker Management)

### How Hawser Works
- Compose files are stored on the **Dockhand server** (ProxMoxBox)
- Hawser agent runs on the remote host (Pi5)
- Dockhand sends commands to Hawser, which executes on remote Docker daemon
- Volume paths resolve on the **remote host** filesystem

### Pi5 Stacks Location on ProxMox
```
/opt/pi5-stacks/
├── infra/
│   ├── docker-compose.yaml
│   └── .env.example
├── mealie/
│   └── docker-compose.yaml
└── nebula-sync/
    ├── docker-compose.yaml
    └── .env.example
```

### Pi5 Running Containers
| Container | Stack | Status |
|-----------|-------|--------|
| pihole | infra | healthy |
| tailscale | infra | running |
| mealie | mealie | healthy |
| nebula-sync | nebula-sync | healthy |

### Original Pi5 Compose Locations (for reference)
- `/opt/stacks/infra/docker-compose.yaml`
- `/root/mealie/compose.yaml`

### Portainer Removal
Portainer was removed from both servers in favor of Dockhand:
```bash
# Removed from Pi5 infra stack
# Removed portainer_data directory
# Updated docker-compose.yaml to exclude Portainer service
```

---

## Troubleshooting

### Containers visible but not manageable in Dockhand
- Ensure `/opt` (or wherever compose files live) is mounted into Dockhand container
- Use the **Import** feature, not just viewing containers

### Hawser stacks not working
- Compose files must be on Dockhand server, not remote host
- Volume paths resolve on remote host - use absolute paths if needed
- Ensure Hawser agent is running on remote host

---

## Related Pages
- [[Homepage-Dashboard]]
- [[GitOps-Workflow]]
- [[Troubleshooting]]
