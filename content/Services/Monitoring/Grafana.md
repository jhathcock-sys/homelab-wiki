# Grafana

[[_Monitoring-Stack|← Back to Monitoring Stack]]

**IP:** [[Network-Topology|192.168.1.XXX:3030]]

---

## Overview

Visualization and dashboards for metrics and logs.

---

## Access

```
http://192.168.1.XXX:3030
```

---

## Credentials

- **Username:** `admin`
- **password: [REDACTED] `N0r@1251`

**Security Note:** Password stored in `/opt/monitoring/.env` as `GRAFANA_PASSWORD`. Default password fallback removed for security (no `:-admin` fallback).

---

## Dashboards

| Dashboard | UID | Description |
|-----------|-----|-------------|
| **Homelab Overview** | homelab-overview | Single pane of glass - both hosts, containers, alerts, logs |
| **Docker Containers** | docker-containers | Detailed container metrics, status table, network/disk I/O |
| **Loki Logs** | loki-logs | Log exploration and search |
| **Node Exporter Full** | 1860 (imported) | Comprehensive host metrics |
| **cAdvisor** | 14282 (imported) | Container metrics detail |

---

## Datasources

Provisioned automatically on startup:

- **[[Prometheus]]** - `http://prometheus:9090`
- **[[Loki]]** - `http://loki:3100`

---

## Docker Compose

```yaml
grafana:
  image: grafana/grafana:latest
  container_name: grafana
  restart: unless-stopped
  ports:
    - "3030:3000"
  volumes:
    - grafana_data:/var/lib/grafana
    - ./grafana/provisioning:/etc/grafana/provisioning:ro
  environment:
    - GF_SECURITY_ADMIN_USER=admin
    - GF_SECURITY_ADMIN_PASSWORD=[REDACTED]
    - GF_USERS_ALLOW_SIGN_UP=false
  deploy:
    resources:
      limits:
        memory: 512M  # Current usage ~390 MB (76%)
```

---

## Provisioned Dashboards Location

```
/opt/monitoring/grafana/provisioning/
├── datasources/
│   ├── prometheus.yml
│   └── loki.yml
└── dashboards/
    ├── dashboards.yml
    └── json/
        ├── homelab-overview.json
        ├── docker-containers.json
        └── loki-logs.json
```

---

## Related Pages

- [[_Monitoring-Stack]]
- [[Prometheus]]
- [[Loki]]
- [[Security-Hardening|Security: Removed Default Password]]
