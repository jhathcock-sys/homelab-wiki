# Monitoring Stack Overview

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX]] | **Stack:** [[GitOps-Workflow|homelab-ops/proxmox/monitoring/]]

---

## Overview

Full metrics, alerting, and visualization stack deployed on ProxMoxBox with Node Exporter on Pi5.

---

## Access URLs

| Service | URL | Purpose |
|---------|-----|---------|
| [[Grafana]] | http://192.168.1.XXX:3030 | Dashboards & visualization |
| [[Prometheus]] | http://192.168.1.XXX:9090 | Metrics database |
| [[Alertmanager]] | http://192.168.1.XXX:9093 | Alert routing & notifications |
| [[Loki]] | http://192.168.1.XXX:3101 | Log aggregation |
| Node Exporter (ProxMox) | http://192.168.1.XXX:9100 | System metrics |
| Node Exporter (Pi5) | http://192.168.1.XXX:9100 | System metrics |
| cAdvisor | http://192.168.1.XXX:8081 | Container metrics |

---

## Architecture

```
┌─────────────┐
│   Grafana   │ ← Dashboards & Visualization
└──────┬──────┘
       │
       ├─────→ Prometheus ← Metrics (Node Exporter, cAdvisor)
       └─────→ Loki       ← Logs (Promtail)
                  │
                  └─→ Alertmanager → Discord Notifications
```

---

## Components

- **[[Prometheus]]** - Time-series metrics database, scrapes exporters
- **[[Grafana]]** - Visualization and dashboards
- **[[Alertmanager]]** - Alert routing and Discord notifications
- **[[Loki]]** - Log aggregation (with Promtail collectors)
- **Node Exporter** - System metrics (CPU, RAM, disk, network)
- **cAdvisor** - Docker container metrics
- **SNMP Exporter** - [[NAS-Synology|NAS]] network metrics

---

## Stack Location

```
/opt/monitoring/
├── docker-compose.yaml
├── .env                          # GRAFANA_PASSWORD, DISCORD_WEBHOOK
├── alertmanager/
│   └── alertmanager.yml          # Discord routing config
├── prometheus/
│   ├── prometheus.yml            # Scrape configs
│   └── alerts.yml                # Alert rules
├── loki/
│   └── loki-config.yml
├── promtail/
│   └── promtail-config.yml
└── grafana/
    └── provisioning/
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

- [[Prometheus|Prometheus - Scrape Targets & Alerts]]
- [[Grafana|Grafana - Dashboards & Credentials]]
- [[Alertmanager|Alertmanager - Discord Notifications]]
- [[Loki|Loki - Log Aggregation]]
- [[NAS-Synology|NAS SNMP Monitoring]]
