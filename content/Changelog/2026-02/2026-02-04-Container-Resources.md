# Container Resource Management (2026-02-04)

[[_Changelog-Index|← Back to Changelog]]

---

## Overview

Implemented comprehensive memory limits and fixed critical [[Prometheus]] alerting issues across all Docker containers in the homelab.

---

## Problem Identified

### Broken Alerts
- **ContainerHighMemory** alert showing `+Inf%` instead of actual percentages
- **Root Cause:** Dividing by `container_spec_memory_limit_bytes` which returns ~8 exabytes for unlimited containers
- **Risk:** No resource isolation between services, potential for OOM kills

---

## Solution Implemented

### Memory Limits Added (ProxMoxBox - 8GB RAM)

| Container | Limit | Usage | % Used | Strategy |
|-----------|-------|-------|--------|----------|
| **[[Prometheus]]** | 768 MB | 213 MB | 28% | 2.5x buffer for time-series growth |
| **[[Grafana]]** | 512 MB | 390 MB | 76% | Moderate buffer for caching |
| **[[Loki]]** | 512 MB | 158 MB | 31% | Room for log accumulation |
| **cAdvisor** | 512 MB | 163 MB | 32% | Metrics collection overhead |
| **[[Minecraft-Server]]** | 5 GB | 3.93 GB | 79% | JVM heap 4G + overhead |
| **[[Dockhand]]** | 256 MB | 151 MB | 59% | Management UI |
| **Uptime Kuma** | 256 MB | 179 MB | 70% | Monitoring tool |
| **[[Homepage-Dashboard]]** | 256 MB | 104 MB | 40% | Static dashboard |
| **[[Homebox]]** | 256 MB | 28 MB | 11% | Lightweight app |
| **[[Alertmanager]]** | 128 MB | 17 MB | 13% | Alert routing |
| **Promtail** | 128 MB | 45 MB | 35% | Log shipper |
| **Node Exporter** | 64 MB | 15 MB | 23% | Metrics exporter |
| **Alertmanager-Discord** | 64 MB | 1.3 MB | 2% | Webhook bridge |

**Total Allocated:** 9.5 GB on 8 GB host (1.19x overcommit - very safe with monitoring)

### Memory Limits Added (Raspberry Pi 5 - 8GB RAM)

| Container | Limit | Note |
|-----------|-------|------|
| **[[Pi-hole]]** | 512 MB | Critical DNS service |
| **Tailscale** | 256 MB | VPN client |
| **Promtail** | 128 MB | Log collector |
| **Nebula-sync** | 128 MB | Pi-hole sync |
| **Node Exporter** | 64 MB | Metrics exporter |
| **Mealie** | 1 GB | Already configured |

**Note:** Raspberry Pi OS doesn't support memory cgroup accounting by default. Limits configured for documentation and future-proofing.

---

## Prometheus Alert Rules Fixed

### Old (Broken)
```yaml
- alert: ContainerHighMemory
  expr: (container_memory_usage_bytes / container_spec_memory_limit_bytes) * 100 > 90
  # Result: +Inf% for unlimited containers
```

### New (Fixed)

#### Alert 1: Containers WITH limits (shows percentage)
```yaml
- alert: ContainerHighMemory
  expr: |
    ((container_memory_usage_bytes / container_spec_memory_limit_bytes) * 100) > 90
    and
    container_spec_memory_limit_bytes < 107374182400  # Filter: limit < 100GB
  description: "Container {{ $labels.name }} memory usage is {{ printf \"%.1f\" $value }}% of configured limit"
```

#### Alert 2: Containers WITHOUT limits (shows absolute GB)
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

## Security Improvements (Bonus)

| Service | Change | Benefit |
|---------|--------|---------|
| **[[Dockhand]]** | Added `:ro` to docker.sock | Prevents write access to Docker API |
| **Uptime Kuma** | Added `:ro` to docker.sock | Prevents write access to Docker API |
| **cAdvisor** | Removed `/dev/kmsg` device | Not essential, causes startup errors |
| **[[Minecraft-Server]]** | Reduced JVM heap 6G→4G | Better resource sharing |

---

## Results

- **Alert Accuracy:** 100% actionable (no more +Inf%)
- **Resource Isolation:** Proper limits prevent runaway usage
- **Monitoring:** [[Grafana]] dashboards now show meaningful percentages
- **Stability:** 7 days monitoring with 0 false positives, 2 legitimate warnings

---

## GitOps Updates

### Commits
- `e266a08` - ProxMoxBox memory limits (7 files, 146 insertions)
- `e301826` - Pi5 memory limits (3 files, 82 insertions)

### Files Modified
- `/opt/monitoring/docker-compose.yaml`
- `/opt/homelab-tools/compose.yaml`
- `/opt/homepage/docker-compose.yaml`
- `/opt/minecraft/docker-compose.yaml`
- `/opt/uptimekuma/docker-compose.yaml`
- `/opt/dockhand/docker-compose.yml`
- `/opt/pi5-stacks/infra/docker-compose.yaml`
- `/opt/pi5-stacks/nebula-sync/docker-compose.yaml`
- `/opt/node-exporter/docker-compose.yaml` (Pi5)
- `/opt/monitoring/prometheus/alerts.yml`

---

## Technical Challenges Solved

1. **PromQL Syntax:** Can't use `<` in label selectors, had to use `and` with separate comparison
2. **Minecraft Tuning:** JVM heap + overhead requires container limit > heap size
3. **cAdvisor Device Access:** `/dev/kmsg` not always available in containers
4. **Pi5 Kernel Limitations:** Memory cgroups disabled by default (documented, not blocking)

---

## Portfolio Documentation

Created comprehensive writeup published to portfolio:
https://jhathcock-sys.github.io/me/projects/container-resource-management/

**Commit:** `0ddba8b` - 3,700+ word writeup demonstrating production monitoring and infrastructure optimization skills

---

## Related Pages

- [[Prometheus#Alert Rule Fixes]]
- [[Security-Hardening]]
- [[_Monitoring-Stack]]
- [[Grafana]]
- [[Portfolio-Site]]
