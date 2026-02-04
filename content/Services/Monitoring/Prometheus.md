# Prometheus

[[_Monitoring-Stack|← Back to Monitoring Stack]]

**IP:** [[Network-Topology|192.168.1.XXX:9090]]

---

## Overview

Time-series metrics database. Scrapes exporters across the homelab for system and container metrics.

---

## Access

```
http://192.168.1.XXX:9090
```

---

## Scrape Targets

```yaml
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'proxmoxbox'
    static_configs:
      - targets: ['node-exporter:9100']
        labels:
          instance: 'proxmoxbox'

  - job_name: 'pi5'
    static_configs:
      - targets: ['192.168.1.XXX:9100']
        labels:
          instance: 'pi5'

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'pihole'
    static_configs:
      - targets: ['192.168.1.XXX:9100']
        labels:
          instance: 'pihole-lxc'

  - job_name: 'npm'
    static_configs:
      - targets: ['192.168.1.XXX:9100']
        labels:
          instance: 'npm-lxc'

  - job_name: 'wazuh'
    static_configs:
      - targets: ['192.168.1.XXX:9100']
        labels:
          instance: 'wazuh-vm'

  - job_name: 'synology-snmp'
    static_configs:
      - targets: ['192.168.1.XXX']
    metrics_path: /snmp
    params:
      module: [if_mib]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: snmp-exporter:9116
```

**Total Scrape Targets:** 8 (Prometheus, ProxMoxBox, Pi5, cAdvisor, Pi-hole, NPM, Wazuh, Synology NAS)

---

## Alert Rules

### System Alerts

| Alert | Condition | Severity |
|-------|-----------|----------|
| **DiskSpaceWarning** | >80% full | warning |
| **DiskSpaceCritical** | >90% full | critical |
| **HighMemoryUsage** | >90% for 5min | warning |
| **HighCPUUsage** | >90% for 5min | warning |
| **HostDown** | Unreachable 2min | critical |
| **PrometheusTargetDown** | Scrape fail 2min | critical |

### Container Alerts

| Alert | Condition | Severity |
|-------|-----------|----------|
| **ContainerDown** | Missing 2min | warning |
| **ContainerHighCPU** | >80% for 5min | warning |
| **ContainerRestarting** | >3x/hour | warning |
| **ContainerHighMemory** | >90% of limit | warning |
| **ContainerHighMemoryAbsolute** | >4GB (no limit) | info |

---

## Alert Rule Fixes (2026-02-04)

### Problem
ContainerHighMemory alert showing `+Inf%` instead of actual percentages.

### Root Cause
Dividing by `container_spec_memory_limit_bytes` which returns ~8 exabytes for unlimited containers.

### Solution
Split into two alerts:

**Alert 1: Containers WITH limits (shows percentage)**
```yaml
- alert: ContainerHighMemory
  expr: |
    ((container_memory_usage_bytes / container_spec_memory_limit_bytes) * 100) > 90
    and
    container_spec_memory_limit_bytes < 107374182400  # Filter: limit < 100GB
  description: "Container {{ $labels.name }} memory usage is {{ printf \"%.1f\" $value }}% of configured limit"
```

**Alert 2: Containers WITHOUT limits (shows absolute GB)**
```yaml
- alert: ContainerHighMemoryAbsolute
  expr: |
    (container_memory_usage_bytes / 1073741824) > 4  # Over 4GB
    and
    container_spec_memory_limit_bytes >= 107374182400
  severity: info
  description: "Container {{ $labels.name }} is using {{ printf \"%.2f\" $value }}GB (no limit configured)"
```

---

## Docker Compose

```yaml
prometheus:
  image: prom/prometheus:latest
  container_name: prometheus
  restart: unless-stopped
  ports:
    - "9090:9090"
  volumes:
    - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
    - ./prometheus/alerts.yml:/etc/prometheus/alerts.yml:ro
    - prometheus_data:/prometheus
  command:
    - "--config.file=/etc/prometheus/prometheus.yml"
    - "--storage.tsdb.path=/prometheus"
    - "--storage.tsdb.retention.time=30d"
    - "--web.enable-lifecycle"
  deploy:
    resources:
      limits:
        memory: 768M  # 2.5x buffer for time-series growth
```

**Memory Limit:** 768 MB (current usage ~213 MB, 28%)

---

## Configuration Files

- `/opt/monitoring/prometheus/prometheus.yml` - Scrape configs
- `/opt/monitoring/prometheus/alerts.yml` - Alert rules

---

## Related Pages

- [[_Monitoring-Stack]]
- [[Grafana]]
- [[Alertmanager]]
- [[NAS-Synology#SNMP Monitoring]]
- [[Changelog/2026-02/2026-02-04-Container-Resources|Container Resource Management]]
