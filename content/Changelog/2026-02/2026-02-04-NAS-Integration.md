# NAS Integration (2026-02-04)

[[_Changelog-Index|← Back to Changelog]]

---

## Overview

Integrated Synology DS220j ([[Network-Topology|192.168.1.XXX]]) with homelab infrastructure for centralized storage, monitoring, and logging.

---

## SNMP Monitoring - ✅ COMPLETED

Successfully added [[Prometheus]] monitoring for NAS health and network metrics.

### Implementation
- Added `snmp-exporter` service to [[_Monitoring-Stack|monitoring stack]]
- Uses built-in `if_mib` module for network interface metrics
- Collects traffic counters (ifHCInOctets) and interface status (ifOperStatus)
- Prometheus scrapes via `snmp-exporter:9116` with relabel configs

### Files Modified
- `/opt/monitoring/docker-compose.yaml` - Added snmp-exporter service
- `/opt/monitoring/prometheus/prometheus.yml` - Added synology-snmp job

### Metrics Collected
- Network interface statistics (eth0 traffic, status)
- Ready for [[Grafana]] dashboard visualization (suggested Dashboard ID: 14284)

### DSM Configuration
- SNMP enabled in Control Panel → Terminal & SNMP
- Community: `public`
- SNMP v2c protocol

**Commit:** `31c7047`

---

## Wazuh Agent - ⚠️ SKIPPED (ARM64 Incompatibility)

**Decision:** Skipped [[Wazuh-SIEM]] agent installation due to architecture incompatibility.

### Root Cause
- Synology DS220j uses ARM64 (aarch64) architecture
- Official Wazuh packages expect x86_64 or ARM 32-bit
- dpkg installation partially succeeded but post-install script failed
- No official ARM64 Docker image available

### Alternatives Considered
- Custom ARM64 build from source (too complex for homelab)
- Docker container (no official image)

### Justification
NAS is lower priority for SIEM than servers. SNMP monitoring provides sufficient hardware/network visibility. Wazuh agent coverage on ProxMoxBox, Pi5, Pi-hole LXC, and NPM LXC is adequate for security monitoring.

---

## Syslog Forwarding - 🟡 PARTIAL IMPLEMENTATION

**Status:** Messages arriving but format mismatch causes parse warnings.

### Implementation
- [[Loki#Promtail]] configured with syslog listener on port 1514/tcp
- Synology syslog-ng forwarding configured to ProxMoxBox
- Logs arriving at Promtail successfully

### Issue
- Synology sends BSD format (RFC 3164)
- Promtail expects RFC 5424 format with version number
- Parse warnings: `expecting a version value in the range 1-999`

### Files Modified
- `/opt/monitoring/promtail/promtail-config.yml` - Added syslog-synology job
- `/opt/monitoring/docker-compose.yaml` - Exposed port 1514 on Promtail

### Synology Config
- `/usr/local/etc/syslog-ng/conf.d/remote-loki.conf` - Custom forwarding config
- `/usr/local/etc/rc.d/syslog-remote.sh` - Startup script for persistence

### Future Enhancement
- Add syslog relay container for RFC 3164 → RFC 5424 conversion
- Or use Promtail file scraping via NFS mount of `/var/log`

**Decision:** Accepted partial implementation - messages arriving and searchable in [[Loki]], format conversion can be addressed later if needed.

---

## NFS/SMB Storage - ✅ COMPLETED

Successfully mounted Synology NAS storage on both ProxMoxBox and Pi5 with full Docker container access.

### Challenge - LXC Container Limitation
- ProxMoxBox discovered to be unprivileged LXC container (ID 103)
- LXC containers cannot mount remote filesystems directly
- Both NFS and SMB mount attempts failed with `Operation not permitted`

### Solution - Proxmox Host Bind Mount

1. Mounted SMB share on Proxmox host (192.168.1.XXX):
   ```bash
   mount -t cifs //192.168.1.XXX/HomeLab /mnt/nas/homelab \
     -o credentials=/root/.smbcredentials,vers=3.0,uid=0,gid=0,file_mode=0777,dir_mode=0777,noperm
   ```

2. Added bind mount to LXC container config (`/etc/pve/lxc/103.conf`):
   ```
   mp0: /mnt/nas/homelab,mp=/mnt/nas/homelab,backup=0,replicate=0,shared=1
   ```

3. Restarted container to apply bind mount

4. Made persistent with `/etc/fstab` on Proxmox host:
   ```
   //192.168.1.XXX/HomeLab /mnt/nas/homelab cifs credentials=/root/.smbcredentials,vers=3.0,uid=0,gid=0,file_mode=0777,dir_mode=0777,noperm,_netdev 0 0
   ```

### Storage Access
- **Path:** `/mnt/nas/homelab/`
- **Directories:** `docker-backups/`, `media/`
- **Capacity:** 7.2TB total, 4.9TB used, 2.4TB available

### Raspberry Pi 5 Access
- Direct SMB mount (not in container)
- Same credentials file: `/root/.smbcredentials`
- Persistent mount via `/etc/fstab`:
  ```
  //192.168.1.XXX/HomeLab /mnt/nas/homelab cifs credentials=/root/.smbcredentials,vers=3.0,uid=1000,gid=1000,_netdev 0 0
  ```
- Full read/write access confirmed

### UID Mapping Quirk
- Shell writes from LXC container fail (UID mapping issue)
- Docker containers have full read/write access (Docker handles mapping differently)
- Acceptable for use case - backups and media access work correctly

### Credentials
- **User:** `HomeLab`
- **password: [REDACTED] Stored in `/root/.smbcredentials` (mode 600)

### Use Cases Enabled
- Automated Docker volume backups to NAS
- Centralized media storage for future Jellyfin/Plex stack
- Shared storage between ProxMoxBox and Pi5

---

## Documentation & Memory Updates

### Portfolio Update
- Added NAS Integration section to `home-lab.md`
- Documented SNMP monitoring, SMB shares, syslog status, storage capacity

### Memory Backup
- Synced all CLAUDE.md files to `ai-assistant-config` repository
- Updated global memory (`~/.claude/CLAUDE.md`)
- Updated project memories (homelab-ops, my-portfolio)
- Committed with comprehensive message documenting NAS integration

**Repository:** https://github.com/jhathcock-sys/ai-assistant-config
**Commit:** `96e55ef`

---

## Technical Lessons Learned

### LXC Containers
- Unprivileged containers cannot mount remote filesystems
- Bind mounts from host are the correct solution
- UID mapping (100000 offset) affects file access patterns
- Docker containers bypass some LXC UID mapping restrictions

### SNMP Monitoring
- Built-in snmp_exporter modules often sufficient (avoid custom configs)
- `if_mib` module works well for most network devices
- Prometheus relabel configs essential for proper target labeling

### Syslog Standards
- RFC 3164 (BSD syslog) vs RFC 5424 (modern syslog) incompatibility common
- Format conversion may require relay/translator service
- Partial implementation acceptable if messages still searchable

### ARM64 Ecosystem
- Not all security tools support ARM64 yet
- Synology DiskStations (J-series) use ARM processors
- Check architecture compatibility before planning deployments

---

## Files Modified

| File | Change |
|------|--------|
| `/opt/monitoring/docker-compose.yaml` | Added snmp-exporter, exposed Promtail port 1514 |
| `/opt/monitoring/prometheus/prometheus.yml` | Added synology-snmp scrape job |
| `/opt/monitoring/promtail/promtail-config.yml` | Added syslog-synology listener |
| `/etc/pve/lxc/103.conf` (Proxmox host) | Added NAS bind mount |
| `/etc/fstab` (Proxmox host) | Made SMB mount persistent |
| `/etc/fstab` (Pi5) | Made SMB mount persistent |
| `home-lab.md` (portfolio) | Documented NAS integration |

---

## Commits

- `31c7047` - Add snmp-exporter for NAS monitoring
- `96e55ef` - Update memories with NAS integration details

---

## Future Enhancements

- [ ] Add syslog format conversion for complete log parsing
- [ ] Create [[Grafana]] dashboard for NAS metrics (ID: 14284)
- [ ] Deploy [[Future-Plans|media stack]] (Jellyfin/Plex) using NAS storage
- [ ] Implement automated Docker backup solution to NAS
- [ ] Consider NFS for better performance (after fixing subnet/auth issues)

---

## Related Pages

- [[NAS-Synology]]
- [[_Monitoring-Stack]]
- [[Prometheus]]
- [[Loki]]
- [[Wazuh-SIEM]]
- [[Future-Plans]]
