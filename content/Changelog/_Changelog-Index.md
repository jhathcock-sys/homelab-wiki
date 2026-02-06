# Changelog

[[_Index|← Back to Index]]

---

## Recent Changes

- **2026-02-05:** [[2026-02-05-Memory-System-2.0|Memory System 2.0 - Symlink Architecture]] - Complete architectural refactoring of Claude Code memory system. Implemented symlink-based workflow eliminating manual sync commands. Consolidated duplicate directories into `global/`, `session/`, `projects/` structure. Created helper scripts (`install-symlinks.sh`, `sync.sh`). Reduced global memory to ~3KB, expanded session to ~8KB. Added `.gitignore` for credential protection. Sync workflow improved from 3 commands → 1 command, edit-to-commit from ~2 minutes → ~10 seconds. (commits `da44f38`, `4bbba5a`)

- **2026-02-04:** [[2026-02-04-Memory-Architecture-Refactoring|Memory Architecture Refactoring]] - Refactored Claude Code memory system (v1.0) to eliminate duplication and secure credentials. Reduced global memory from 123→100 lines by offloading verbose descriptions to project memories. Moved all credentials to gitignored CLAUDE.internal.md files. Expanded memory tree to document all 5 projects (homelab-ops, homelab-docs, podcast-studio, my-portfolio, ai-assistant-config). Verified no credentials in committed files. (commit `c837298`)

- **2026-02-04:** [[2026-02-04-GitOps-Drift-Detection|GitOps Drift Detection]] - Created automated drift detection script (`scripts/drift-detection.sh`) to validate infrastructure matches repository. Checks 21 containers across ProxMoxBox and Pi5. Removed nginx-proxy-manager compose file (LXC, not Docker). Synced missing Pi5 stacks (mealie, node-exporter, obsidian-livesync) to `proxmox/pi5-stacks/` for Hawser remote management. Infrastructure now validates clean. (commits `ba4061e`, `cdc75f4`)

- **2026-02-04:** [[2026-02-04-NAS-Integration|NAS Integration]] - Integrated Synology DS220j (7.2TB) with homelab infrastructure. SNMP monitoring added to Prometheus for network metrics. Wazuh agent skipped due to ARM64 incompatibility. Syslog forwarding partially implemented (messages arriving but format mismatch). SMB shares successfully mounted on both ProxMoxBox (via Proxmox host bind mount) and Pi5 with full Docker container access. Storage ready for media stack and backups. (commits `31c7047`, `96e55ef`)

- **2026-02-04:** [[2026-02-04-Container-Resources|Container Resource Management]] - Added comprehensive memory limits to all 20 containers across ProxMoxBox and Pi5. Analyzed usage patterns, set appropriate limits (768MB for Prometheus down to 64MB for node-exporter). Total: 9.5GB allocated on 8GB host with very safe 1.19x overcommit. (commits `e266a08`, `e301826`)

- **2026-02-04:** Fixed Prometheus ContainerHighMemory alert showing +Inf% - Rewrote alert rules to handle containers with and without limits. Created ContainerHighMemory (percentage-based, >90%) and ContainerHighMemoryAbsolute (absolute usage, >4GB) alerts. Now shows actionable percentages instead of infinity.

- **2026-02-04:** Security improvements - Added `:ro` (read-only) flags to docker.sock mounts in [[Dockhand]] and Uptime Kuma. Removed problematic `/dev/kmsg` device from cAdvisor. Reduced [[Minecraft-Server]] JVM from 6G to 4G for better resource management.

- **2026-02-04:** Updated Claude Code status line - Added session usage percentage tracking alongside context window percentage. Now displays both "Ctx:X%" (per-message context) and "Sess:X%" (cumulative session budget) for better resource awareness. (commit `484c4b7` in ai-assistant-config)

- **2026-02-04:** Updated [[Podcast-Studio]] to support 6 participants (increased from 4) - Storage planning updated: 6-person 4K sessions require ~70GB (up from ~50GB for 4 people). LiveKit config clarified with comment about 10 max participants providing buffer. (commit `3e5ee87`)

- **2026-02-04:** Created Container Resource Management portfolio project - Comprehensive 3,700+ word writeup documenting memory limit implementation, Prometheus alert fixes, usage analysis methodology, and technical challenges. Demonstrates production monitoring and infrastructure optimization skills. Published to https://jhathcock-sys.github.io/me/projects/container-resource-management/ (commit `0ddba8b`)

- **2026-02-03:** [[2026-02-03-Podcast-Studio|Podcast Studio Creation]] - Created podcast-studio repository: Self-hosted video podcast recording platform with LiveKit, React, MinIO, FFmpeg. Supports 4K multi-track recording, remote guests, and live streaming. Architecture designed for D&D sessions. Assigned IP [[Network-Topology|192.168.1.XXX]]. (commit `f0d72c0`)

- **2026-02-03:** [[2026-02-03-Security-Hardening|Security Hardening]] - Created Docker Security Review portfolio project: full audit documentation with methodology, findings, and Security+ tie-ins. Removed cAdvisor privileged mode, added docker.sock read-only to Uptime Kuma/Dockhand, removed Grafana default password fallback. (commit `d403912`, commit `6a26be2`)

- **2026-02-03:** Added Personal Context section to Obsidian note (profile, learning path, goals, workflow preferences)

- **2026-02-03:** Added custom status line (statusline.sh, settings.json) to ai-assistant-config repo - Powerlevel10k-style status bar showing model, git branch, context %, lines changed, cost

- **2026-02-03:** Memory tree restructure - split global CLAUDE.md into project-specific files (homelab-ops, my-portfolio, ai-assistant-config)

- **2026-02-03:** Converted all project CLAUDE.md files to pure XML format for efficient parsing

- **2026-02-03:** Added laptop workstation documentation to global memory (Pop!_OS COSMIC setup)

- **2026-02-03:** Fixed COSMIC Terminal missing headerbar/tabs (show_headerbar config)

- **2026-02-02:** Created ai-assistant-config repo for memory backup (github.com/jhathcock-sys/ai-assistant-config)

- **2026-02-02:** [[Claude-Memory-System|Claude Code Memory System]] - converted CLAUDE.md to structured XML, added persona/directives, published portfolio writeup

- **2026-02-02:** [[2026-02-02-Wazuh-Deployment|Wazuh Deployment]] - Expanded monitoring: installed node-exporter on Pi-hole LXC, NPM LXC, and Wazuh VM. Added Prometheus scrape targets (7 total). Added Wazuh agents to Pi-hole LXC (SRV-DNS01) and NPM LXC (SRV-NPM01) - 4 agents total.

- **2026-02-02:** Rebuilt [[Wazuh-SIEM|Wazuh VM]] with Debian 12, upgraded to v4.14.2, re-registered agents. Dashboard fully operational.

- **2026-02-02:** (earlier) Deployed Wazuh SIEM on dedicated VM (192.168.1.XXX), installed agents on ProxMoxBox and Pi5

- **2026-02-02:** Added [[Prometheus]] alerting with Discord notifications via [[Alertmanager]]

- **2026-02-02:** Created Homelab Overview and Docker Containers [[Grafana]] dashboards

- **2026-02-02:** Added 9 alert rules (disk, CPU, memory, container, target monitoring)

- **2026-02-01:** Added [[GitOps-Workflow|GitOps repository]] structure, configs now managed via git at `homelab-ops/`

- **2026-02-01:** [[Portfolio-Site]] updates - rewrote project pages, added PDF resume, fixed subdirectory links, added SEO metadata

- **2026-02-01:** Added [[Loki]] + Promtail for centralized log aggregation from ProxMoxBox and Pi5

- **2026-02-01:** Updated [[Homepage-Dashboard]] bookmarks with portfolio, LinkedIn, and repo links

- **2026-02-01:** Created project roadmap ([[Future-Plans|OPNsense → Wazuh → NAS → Media stack]])

---

## Homarr Removal

Homarr was removed in favor of [[Homepage-Dashboard]] as the primary dashboard:
- Removed from homelab-tools compose
- Deleted container and data directory
- Homepage now serves as the single dashboard

---

## Detailed Session Notes

### 2026-02
- [[2026-02-05-Memory-System-2.0]]
- [[2026-02-04-Memory-Architecture-Refactoring]]
- [[2026-02-04-GitOps-Drift-Detection]]
- [[2026-02-04-NAS-Integration]]
- [[2026-02-04-Container-Resources]]
- [[2026-02-03-Security-Hardening]]
- [[2026-02-03-Podcast-Studio]]
- [[2026-02-02-Wazuh-Deployment]]

---

*For current tasks, see [[Current-TODO]]*
