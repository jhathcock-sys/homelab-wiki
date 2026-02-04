# GitOps Workflow

[[_Index|← Back to Index]]

---

## Overview

All Docker compose files are managed via Git for Infrastructure as Code.

---

## Repository

- **Local:** `/home/cib/homelab-ops`
- **Remote:** `github.com:jhathcock-sys/Dockers.git`

---

## Repository Structure

```
homelab-ops/
├── proxmox/                    # ProxMoxBox stacks -> deploy to /opt/<stack>/
│   ├── dockhand/
│   ├── homepage/               # Includes config/ directory
│   ├── homelab-tools/
│   ├── minecraft/
│   ├── monitoring/             # Includes prometheus/
│   ├── nginx-proxy-manager/
│   └── uptime-kuma/
│
└── pi5/                        # Pi5 stacks -> managed via Hawser
    ├── infra/                  # Pi-hole + Tailscale
    ├── mealie/
    ├── nebula-sync/
    └── promtail/               # Log collector for Loki
```

---

## Deployment Workflow

1. Edit compose files in the git repo
2. Commit and push to GitHub
3. Pull changes on server or sync via [[Dockhand]]
4. Run `docker compose up -d` in the stack directory

---

## Path Mapping

| Git Path | Server Deploy Path |
|----------|-------------------|
| `proxmox/<stack>/` | `/opt/<stack>/` on ProxMoxBox |
| `pi5/<stack>/` | `/opt/pi5-stacks/<stack>/` on ProxMoxBox (via [[Dockhand#Hawser\|Hawser]]) |

---

## Related Pages
- [[Network-Topology]]
- [[Dockhand]]
- [[GitHub-Repositories]]
