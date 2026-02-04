# Minecraft Server

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX]] | **Stack:** [[GitOps-Workflow|homelab-ops/proxmox/minecraft/]]

---

## Access

- **Java Edition:** 192.168.1.XXX:25565
- **Bedrock Edition:** 192.168.1.XXX:19132/udp

---

## Stack Location

```
/opt/minecraft/docker-compose.yaml
```

---

## Container Resources

| Resource | Value | Notes |
|----------|-------|-------|
| **Memory Limit** | 5 GB | JVM heap 4G + overhead |
| **Current Usage** | ~3.93 GB | ~79% of limit |
| **JVM Heap** | 4G | Reduced from 6G for better resource sharing |

---

## Docker Compose Fixes

### 1. Floodgate Plugin URL
**Issue:** Truncated plugin URL
**Fix:** Completed the URL:
```
https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot
```

### 2. Memory Allocation
**Previous:** 6G JVM heap
**Current:** 4G JVM heap
**Reason:** Better resource sharing with other services, 5GB container limit provides adequate overhead

---

## Monitoring

- **Prometheus:** Container metrics via [[Services/Monitoring/Prometheus|cAdvisor]]
- **Alerts:** ContainerHighMemory, ContainerRestarting

---

## Related Pages
- [[GitOps-Workflow]]
- [[_Monitoring-Stack]]
- [[Container-Resources]]
