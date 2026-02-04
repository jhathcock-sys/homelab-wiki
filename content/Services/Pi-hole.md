# Pi-hole DNS Server

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX]] (Primary), [[Network-Topology|192.168.1.XXX]] (Secondary) | **Stack:** pi5/infra/

---

## Overview

Network-wide DNS server and ad blocker. Primary instance runs on dedicated LXC container, secondary on Pi5.

---

## Access

- **Primary:** http://192.168.1.XXX/admin (ns1.internal.lab)
- **Secondary:** http://192.168.1.XXX/admin

---

## Pi-hole v6 API Changes

Pi-hole v6 uses a different API structure. For [[Homepage-Dashboard]] widgets:

```yaml
widget:
  type: pihole
  url: http://192.168.1.XXX
  version: 6
  key: your_pihole_password  # Web password directly, not API token
```

**Note:** Environment variable substitution may not work - use direct values in `services.yaml`.

---

## Monitoring

- **Prometheus Scrape Target:** 192.168.1.XXX:9100 (node-exporter on LXC)
- **Wazuh Agent:** SRV-DNS01 (192.168.1.XXX)
- **Logs:** Collected by [[Loki|Promtail]]

---

## Nebula-sync

Automatic synchronization between primary and secondary Pi-hole instances.

### Configuration
Located on Pi5: `/opt/pi5-stacks/nebula-sync/`

```bash
# .env
NEBULA_PRIMARY=http://192.168.1.XXX|your_password
NEBULA_REPLICAS=http://192.168.1.XXX:8080|your_password
```

---

## Related Pages
- [[Homepage-Dashboard#Pi-hole v6 Widget Configuration]]
- [[_Monitoring-Stack]]
- [[Wazuh-SIEM]]
