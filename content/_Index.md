# Hathcock Infrastructure - HomeLab

## Quick Links

| Category | Links |
|----------|-------|
| **Infrastructure** | [[Network-Topology]] · [[GitOps-Workflow]] · [[Workstation-Setup]] |
| **Services** | [[Homepage-Dashboard]] · [[Dockhand]] · [[NAS-Synology]] · [[Pi-hole]] · [[Minecraft-Server]] · [[Homebox]] · [[Obsidian-LiveSync]] |
| **Monitoring** | [[_Monitoring-Stack]] · [[Prometheus]] · [[Grafana]] · [[Alertmanager]] · [[Loki]] |
| **Security** | [[Wazuh-SIEM]] · [[Security-Hardening]] · [[Best-Practices]] · [[Monitoring-Stack-Security-Audit]] |
| **Projects** | [[Podcast-Studio]] · [[Portfolio-Site]] · [[Homelab-Wiki]] · [[Claude-Memory-System]] · [[Claude-Code-Agents]] |
| **Reference** | [[Personal-Context]] · [[Docker-Commands]] · [[Troubleshooting]] · [[Environment-Files]] · [[GitHub-Repositories]] |
| **Planning** | [[Future-Plans]] · [[Current-TODO]] |
| **Changelog** | [[_Changelog-Index]] |

---

## Overview

This document covers the setup and configuration of the Hathcock Infrastructure home lab, including Docker management, dashboard configuration, and service deployment.

---

## Network Topology

| IP | Device | Role |
|----|--------|------|
| 192.168.1.XXX | Primary Pi-hole | Main DNS server (ns1.internal.lab) |
| 192.168.1.XXX | ProxMoxBox (Dell R430) | Main Docker host, Dockhand server |
| 192.168.1.XXX | Synology NAS | Network storage |
| 192.168.1.XXX | Nginx Proxy Manager | Reverse proxy |
| 192.168.1.XXX | Wazuh VM (Debian 12) | SIEM - manager, indexer, dashboard |
| 192.168.1.XXX | Podcast Studio | Video recording platform (LiveKit, multi-track 4K) |
| 192.168.1.XXX | Pi5 (Raspberry Pi 5) | Secondary DNS, Tailscale, Mealie, Obsidian LiveSync (CouchDB) |
| 192.168.1.XXX | Proxmox | Hypervisor |

---

## Running Containers

### ProxMoxBox Stacks

| Container | Stack | Port | Status |
|-----------|-------|------|--------|
| homepage | homepage | 4000 | healthy |
| homebox | homelab-tools | 3100 | healthy |
| mc-server | minecraft | 25565, 19132/udp | healthy |
| uptime-kuma | uptimekuma | 3001 | healthy |
| dockhand | dockhand | 3000 | healthy |
| grafana | monitoring | 3030 | healthy |
| prometheus | monitoring | 9090 | healthy |
| alertmanager | monitoring | 9093 | healthy |
| alertmanager-discord | monitoring | 9094 (internal) | healthy |
| loki | monitoring | 3101 | healthy |
| promtail | monitoring | - | healthy |
| node-exporter | monitoring | 9100 | healthy |
| cadvisor | monitoring | 8081 | healthy |

### Stack Locations
```
/opt/
├── dockhand/
├── homelab-tools/
├── homepage/
├── minecraft/
├── monitoring/
├── uptimekuma/
└── pi5-stacks/      # For Hawser-managed Pi5 stacks
```

---

---

*Last updated: 2026-02-04*
