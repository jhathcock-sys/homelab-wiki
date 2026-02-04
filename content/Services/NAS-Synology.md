# Synology NAS Integration

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX]] | **Model:** DS220j (ARM64)

---

## Overview

Centralized storage for backups, media, and shared files. Integrated with homelab monitoring and logging infrastructure.

---

## Storage Capacity

- **Total:** 7.2 TB
- **Used:** 4.9 TB
- **Available:** 2.4 TB

---

## SNMP Monitoring - ✅ COMPLETED

Successfully added [[Prometheus]] monitoring for NAS health and network metrics.

### Implementation
- Added `snmp-exporter` service to [[_Monitoring-Stack]]
- Uses built-in `if_mib` module for network interface metrics
- Collects traffic counters (ifHCInOctets) and interface status (ifOperStatus)

### DSM Configuration
- SNMP enabled in Control Panel → Terminal & SNMP
- Community: `public`
- SNMP v2c protocol

### Metrics Collected
- Network interface statistics (eth0 traffic, status)
- Ready for [[Grafana]] dashboard visualization (suggested Dashboard ID: 14284)

---

## Wazuh Agent - ⚠️ SKIPPED (ARM64 Incompatibility)

**Decision:** Skipped [[Wazuh-SIEM]] agent installation due to architecture incompatibility.

### Root Cause
- Synology DS220j uses ARM64 (aarch64) architecture
- Official Wazuh packages expect x86_64 or ARM 32-bit
- No official ARM64 Docker image available

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

### Synology Config
- `/usr/local/etc/syslog-ng/conf.d/remote-loki.conf` - Custom forwarding config
- `/usr/local/etc/rc.d/syslog-remote.sh` - Startup script for persistence

### Future Enhancement
- Add syslog relay container for RFC 3164 → RFC 5424 conversion
- Or use Promtail file scraping via NFS mount of `/var/log`

**Decision:** Accepted partial implementation - messages arriving and searchable in [[Loki]], format conversion can be addressed later if needed.

---

## SMB Shares - ✅ COMPLETED

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

3. Made persistent with `/etc/fstab` on Proxmox host:
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

### UID Mapping Quirk
- Shell writes from LXC container fail (UID mapping issue)
- Docker containers have full read/write access (Docker handles mapping differently)
- Acceptable for use case - backups and media access work correctly

### Credentials
- **User:** `HomeLab`
- **password: [REDACTED] Stored in `/root/.smbcredentials` (mode 600)

---

## Use Cases Enabled

- Automated Docker volume backups to NAS
- Centralized media storage for future [[Future-Plans|Jellyfin/Plex stack]]
- Shared storage between ProxMoxBox and Pi5

---

## Future Enhancements

- [ ] Add syslog format conversion for complete log parsing
- [ ] Create [[Grafana]] dashboard for NAS metrics (ID: 14284)
- [ ] Deploy media stack (Jellyfin/Plex) using NAS storage
- [ ] Implement automated Docker backup solution to NAS
- [ ] Consider NFS for better performance (after fixing subnet/auth issues)

---

## Related Pages
- [[_Monitoring-Stack]]
- [[Prometheus]]
- [[Loki]]
- [[Wazuh-SIEM]]
- [[Future-Plans]]
