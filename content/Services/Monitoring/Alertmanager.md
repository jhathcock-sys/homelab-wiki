# Alertmanager

[[_Monitoring-Stack|← Back to Monitoring Stack]]

**IP:** [[Network-Topology|192.168.1.XXX:9093]]

---

## Overview

Alert routing and notifications. Routes [[Prometheus]] alerts to Discord via webhook bridge.

---

## Access

```
http://192.168.1.XXX:9093
```

---

## Discord Notifications

Alerts are routed through Alertmanager to Discord via the `alertmanager-discord` bridge container.

**Discord Webhook:** Stored in `/opt/monitoring/.env` (not in Git)

---

## Alert Timing

```yaml
group_wait: 30s        # Wait before sending first notification
group_interval: 5m     # Wait between notifications for same group
repeat_interval: 4h    # Repeat unresolved alerts (1h for critical)
```

---

## Configuration

```yaml
# /opt/monitoring/alertmanager/alertmanager.yml

global:
  resolve_timeout: 5m

route:
  receiver: 'discord'
  group_by: ['alertname', 'severity']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  routes:
    - match:
        severity: critical
      receiver: 'discord'
      repeat_interval: 1h

receivers:
  - name: 'discord'
    webhook_configs:
      - url: 'http://alertmanager-discord:9094'
        send_resolved: true
```

---

## Docker Compose

```yaml
alertmanager:
  image: prom/alertmanager:latest
  container_name: alertmanager
  restart: unless-stopped
  ports:
    - "9093:9093"
  volumes:
    - ./alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml:ro
    - alertmanager_data:/alertmanager
  command:
    - "--config.file=/etc/alertmanager/alertmanager.yml"
    - "--storage.path=/alertmanager"
  deploy:
    resources:
      limits:
        memory: 128M  # Current usage ~17 MB (13%)

alertmanager-discord:
  image: benjojo/alertmanager-discord:latest
  container_name: alertmanager-discord
  restart: unless-stopped
  environment:
    - DISCORD_WEBHOOK=${DISCORD_WEBHOOK}
  deploy:
    resources:
      limits:
        memory: 64M  # Current usage ~1.3 MB (2%)
```

---

## Alert Examples

### System Alert
```
🔴 CRITICAL: HostDown
Host proxmoxbox is unreachable (>2min)
```

### Container Alert
```
⚠️ WARNING: ContainerHighMemory
Container grafana memory usage is 91.2% of configured limit
```

---

## Related Pages

- [[_Monitoring-Stack]]
- [[Prometheus#Alert Rules]]
- [[Environment-Files]]
