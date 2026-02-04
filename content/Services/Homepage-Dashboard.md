# Homepage Dashboard

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX:4000]] | **Stack:** [[GitOps-Workflow|homelab-ops/proxmox/homepage/]]

---

## Access

```
http://192.168.1.XXX:4000
```

---

## Configuration Location

```
/opt/homepage/
├── docker-compose.yaml
├── .env
└── config/
    ├── services.yaml
    ├── widgets.yaml
    ├── settings.yaml
    ├── docker.yaml
    ├── bookmarks.yaml
    ├── custom.css
    └── custom.js
```

---

## Docker Compose

```yaml
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    restart: unless-stopped
    ports:
      - 4000:3000
    volumes:
      - /opt/homepage/config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
    env_file:
      - .env
    environment:
      HOMEPAGE_ALLOWED_HOSTS: "*"
      LOG_LEVEL: debug
```

**Port Fix:** Port mapping was `4000:4000` but container listens on port 3000. Changed to `4000:3000`.

---

## Dashboard Layout

| Section | Services |
|---------|----------|
| **Infrastructure** | Proxmox, [[Dockhand]], Synology NAS |
| **Network** | Primary [[Pi-hole]], Secondary Pi-hole, NPM |
| **Monitoring** | Uptime Kuma, [[Grafana]], [[Prometheus]], Syncthing |
| **Applications** | [[Homebox]], Mealie |
| **Gaming** | [[Minecraft-Server]] |
| **Media** | Jellyfin, Plex (Coming Soon) |
| **Home Automation** | Home Assistant (Coming Soon) |

---

## Widgets

- Logo + "Hathcock Infrastructure" greeting
- Date/time display
- Google search bar
- System resources (CPU, RAM, disk, uptime, temp)
- Weather (OpenMeteo)
- Docker container status

---

## Pi-hole v6 Widget Configuration

**Important:** Pi-hole v6 uses a different API. The `key` field accepts the web password directly:

```yaml
- Primary Pi-hole:
    icon: pi-hole.png
    href: http://192.168.1.XXX/admin
    description: Primary DNS (ns1)
    widget:
      type: pihole
      url: http://192.168.1.XXX
      version: 6
      key: your_pihole_password
```

**Note:** Environment variable substitution may not work reliably for Pi-hole widgets. Use the password directly in `services.yaml`.

---

## Related Pages
- [[Dockhand]]
- [[Pi-hole]]
- [[GitOps-Workflow]]
