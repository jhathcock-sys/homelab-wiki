# Network Topology

[[_Index|← Back to Index]]

---

## IP Assignments

| IP | Device | Role |
|----|--------|------|
| 192.168.1.XXX | Primary Pi-hole | Main DNS server (ns1.internal.lab) |
| 192.168.1.XXX | ProxMoxBox (Dell R430) | Main Docker host, Dockhand server |
| 192.168.1.XXX | Synology NAS | Network storage |
| 192.168.1.XXX | Nginx Proxy Manager | Reverse proxy |
| 192.168.1.XXX | Wazuh VM (Debian 12) | SIEM - manager, indexer, dashboard |
| 192.168.1.XXX | Podcast Studio | Video recording platform (LiveKit, multi-track 4K) |
| 192.168.1.XXX | Pi5 (Raspberry Pi 5) | Secondary DNS, Tailscale, Mealie |
| 192.168.1.XXX | Proxmox | Hypervisor |

---

## Network: 192.168.1.XXX/24

Before assigning new static IPs, always check this table to avoid conflicts.

---

## Related Pages
- [[GitOps-Workflow]]
- [[Wazuh-SIEM|Wazuh Agent Table]]
- [[_Monitoring-Stack|Prometheus Scrape Targets]]
