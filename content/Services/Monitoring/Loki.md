# Loki Log Aggregation

[[_Monitoring-Stack|← Back to Monitoring Stack]]

**IP:** [[Network-Topology|192.168.1.XXX:3101]]

---

## Overview

Centralized logging using Grafana Loki. Collects logs from all Docker containers and system logs across both ProxMoxBox and Pi5.

---

## Access

```
http://192.168.1.XXX:3101
```

---

## Components

| Service | Host | Port | Purpose |
|---------|------|------|---------|
| **Loki** | ProxMoxBox | 3101 | Log database |
| **Promtail** | ProxMoxBox | 1514 (syslog) | Local log collector |
| **Promtail** | Pi5 | - | Remote log collector |

---

## Logs Collected

- Docker container logs (`/var/lib/docker/containers/`)
- System logs (`/var/log/syslog`)
- Auth logs (`/var/log/auth.log`)
- [[NAS-Synology|Synology NAS]] syslog (partial - format mismatch)

---

## Stack Locations

```
# ProxMoxBox
/opt/monitoring/
├── loki/
│   └── loki-config.yml
└── promtail/
    └── promtail-config.yml

# Pi5
~/promtail/
├── docker-compose.yaml
└── promtail-config.yml
```

---

## Useful LogQL Queries

```logql
{host="pi5"}                      # All Pi5 logs
{host="proxmoxbox", job="docker"} # ProxMox Docker logs
{job="syslog"} |= "error"         # Syslog errors
{job="authlog"} |= "Failed"       # Failed login attempts
{filename=~".*grafana.*"}         # Grafana container logs
```

---

## Retention

- **30 days** for all logs

---

## Docker Compose

```yaml
loki:
  image: grafana/loki:latest
  container_name: loki
  restart: unless-stopped
  ports:
    - "3101:3100"
  volumes:
    - ./loki/loki-config.yml:/etc/loki/local-config.yaml:ro
    - loki_data:/loki
  command: -config.file=/etc/loki/local-config.yaml
  deploy:
    resources:
      limits:
        memory: 512M  # Current usage ~158 MB (31%)

promtail:
  image: grafana/promtail:latest
  container_name: promtail
  restart: unless-stopped
  ports:
    - "1514:1514"  # Syslog receiver for NAS
  volumes:
    - ./promtail/promtail-config.yml:/etc/promtail/config.yml:ro
    - /var/lib/docker/containers:/var/lib/docker/containers:ro
    - /var/log:/var/log:ro
  command: -config.file=/etc/promtail/config.yml
  deploy:
    resources:
      limits:
        memory: 128M  # Current usage ~45 MB (35%)
```

---

## Synology NAS Syslog - 🟡 PARTIAL

**Status:** Messages arriving but format mismatch causes parse warnings.

### Issue
- Synology sends BSD format (RFC 3164)
- Promtail expects RFC 5424 format with version number
- Parse warnings: `expecting a version value in the range 1-999`

### Future Enhancement
- Add syslog relay container for RFC 3164 → RFC 5424 conversion
- Or use Promtail file scraping via NFS mount of `/var/log`

**Decision:** Accepted partial implementation - messages arriving and searchable in Loki, format conversion can be addressed later if needed.

---

## Grafana Integration

Loki datasource is provisioned automatically in [[Grafana]]. Access via:
- **Loki Logs** dashboard
- **Homelab Overview** dashboard (logs panel)
- Explore tab in Grafana

---

## Related Pages

- [[_Monitoring-Stack]]
- [[Grafana]]
- [[NAS-Synology#Syslog Forwarding]]
