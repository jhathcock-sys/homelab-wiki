# Obsidian LiveSync

Real-time vault synchronization using self-hosted CouchDB database.

---

## Overview

**Purpose:** Real-time sync of Obsidian homelab-docs vault across all devices (desktop, laptop, mobile)

**Deployment:** Pi5 (192.168.1.XXX)

**Technology Stack:**
- **CouchDB:** NoSQL database for document storage
- **Self-hosted LiveSync Plugin:** Obsidian community plugin
- **Docker:** Container deployment
- **End-to-End Encryption:** Optional passphrase-based encryption

---

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Desktop    │     │   Mobile    │     │   Laptop    │
│  Obsidian   │◄───►│  Obsidian   │◄───►│  Obsidian   │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                   ┌───────▼────────┐
                   │   CouchDB      │
                   │ 192.168.1.XXX  │
                   │   Port 5984    │
                   │   (Pi5)        │
                   └────────────────┘
```

**Sync Flow:**
1. Edit note in Obsidian on any device
2. Plugin detects change and uploads to CouchDB
3. Other devices pull changes in real-time
4. Conflicts automatically resolved or flagged for manual review

---

## Deployment Details

### Server: Pi5 (192.168.1.XXX)

**Why Pi5?**
- ✅ 6.9 GB available memory (plenty for CouchDB)
- ✅ Low CPU usage (1-2% idle)
- ✅ Always-on for DNS redundancy (also serves sync)
- ✅ Separates concerns from ProxMoxBox

**Container:** `obsidian-couchdb`

**Docker Compose Location:** `/opt/obsidian-livesync/`

**Resource Limits:**
- Memory: 1GB max, 512MB reserved
- CPU: No limit (CouchDB is not CPU-intensive)

**Data Storage:** `/opt/obsidian-livesync/data/`

---

## Access Information

**CouchDB URL:** http://192.168.1.XXX:5984

**Database:** `obsidian`

**Web UI (Fauxton):** http://192.168.1.XXX:5984/_utils

**Credentials:** Stored in `/home/cib/obsidian-livesync-credentials.txt` (chmod 600)

**Connection String:**
```
http://admin:[PASSWORD]@192.168.1.XXX:5984/obsidian
```

---

## Plugin Configuration

### Installation

1. Obsidian → Settings → Community plugins
2. Search: "Self-hosted LiveSync"
3. Install plugin by **vrtmrz**
4. Enable the plugin

### Setup

**Quick Setup:**
- Settings → Self-hosted LiveSync → Setup wizard
- Select "Setup with another device or remote database"
- Paste connection string
- Enable E2E encryption (optional)
- Click "Apply and Sync"

**Manual Setup:**
- URI: `http://192.168.1.XXX:5984/obsidian`
- Username: `admin`
- password: [REDACTED] credentials file)
- Enable "Live sync" and "Sync on Save"

---

## Features

### Real-Time Sync
- Instant synchronization across all devices
- Works when Obsidian is open
- Sub-second latency on local network

### Conflict Resolution
- Automatic merge for simple conflicts
- Manual resolution UI for complex conflicts
- "Use newer file" option for timestamp-based resolution

### End-to-End Encryption
- Optional passphrase-based encryption
- Encryption happens on device (not server)
- CouchDB stores encrypted blobs
- **Important:** Same passphrase on all devices!

### Selective Sync
- Sync `.obsidian` folder (settings, plugins)
- Skip large files option (>50MB)
- Custom exclude patterns

---

## Integration with Git

### Hybrid Workflow

**LiveSync (CouchDB):**
- Real-time sync for daily editing
- Instant updates across devices
- Great for active note-taking

**Git (GitHub: homelab-docs):**
- Version control with history
- Offsite backup
- Public wiki publishing (via homelab-wiki sanitization)

**They coexist!** No conflicts:
- Use LiveSync for instant sync
- Periodically commit to Git for versioning and backups
- Git commits create checkpoints
- LiveSync handles moment-to-moment editing

---

## Monitoring

### Current Monitoring

**System Metrics (via Node Exporter on Pi5):**
- ✅ CPU usage
- ✅ Memory usage
- ✅ Disk usage
- ✅ Available in Grafana Homelab Overview dashboard

**Container Health:**
- ✅ Docker healthcheck (every 30s)
- ✅ Status visible in `docker ps`

**Manual Checks:**
```bash
# Health check
curl http://192.168.1.XXX:5984/_up

# Database info
curl -s http://admin:[PASSWORD]@192.168.1.XXX:5984/obsidian
```

### Future Enhancements

**Optional:**
- CouchDB Prometheus Exporter for detailed metrics
- Add CouchDB logs to Loki
- Custom Grafana dashboard for replication stats

**Current status:** Basic monitoring sufficient for operation

---

## Remote Access

### Via Tailscale VPN

Tailscale is already running on Pi5 for secure remote access.

**Setup:**
1. Connect device to Tailscale VPN
2. Find Pi5 Tailscale IP: `ssh cib@192.168.1.XXX "tailscale ip -4"`
3. Update Obsidian LiveSync URI to use Tailscale IP
4. Example: `http://admin:[PASSWORD]@100.x.x.x:5984/obsidian`

**Security:**
- Tailscale provides encrypted WireGuard tunnel
- CouchDB uses basic auth (username/password)
- No HTTPS needed when using Tailscale

---

## Maintenance

### Backup

**Database Backup:**
```bash
# Create backup
ssh cib@192.168.1.XXX "sudo tar -czf /tmp/couchdb-backup-$(date +%Y%m%d).tar.gz /opt/obsidian-livesync/data"

# Copy to workstation
scp cib@192.168.1.XXX:/tmp/couchdb-backup-*.tar.gz ~/backups/
```

**Note:** Git already backs up vault content, so CouchDB backup is redundant but provides additional safety.

### Database Compaction

Over time, CouchDB accumulates deleted document revisions:

```bash
# Compact database
ssh cib@192.168.1.XXX "curl -X POST http://admin:[PASSWORD]@localhost:5984/obsidian/_compact -H 'Content-Type: application/json'"

# Check database size
ssh cib@192.168.1.XXX "sudo du -sh /opt/obsidian-livesync/data"
```

**Recommended:** Run compaction monthly or when database exceeds 1GB.

### Updates

**Update CouchDB:**
```bash
ssh cib@192.168.1.XXX
cd /opt/obsidian-livesync
sudo docker compose pull
sudo docker compose up -d
```

**Update Plugin:**
- Obsidian handles plugin updates automatically
- Or manually: Settings → Community plugins → Check for updates

---

## Troubleshooting

### Sync Not Working

**Check CouchDB Status:**
```bash
ssh cib@192.168.1.XXX "sudo docker ps | grep obsidian"
```

**Test Connection:**
```bash
curl http://192.168.1.XXX:5984/_up
# Should return: {"status":"ok"}
```

**View Logs:**
```bash
ssh cib@192.168.1.XXX "sudo docker logs obsidian-couchdb --tail 100"
```

### Conflict Resolution

When two devices edit the same file simultaneously:
1. LiveSync shows ⚠️ conflict warning
2. Open conflicted file
3. Manually merge content
4. Save to resolve

**Auto-resolve:** Settings → "Use newer file" for timestamp-based resolution

### Database Full

If database grows too large:
1. Run compaction (see Maintenance above)
2. Enable "Skip large files" in plugin settings
3. Exclude large attachments from sync

---

## Performance

### Expected Resource Usage

**CouchDB Container:**
- Memory: 500MB-1GB (typical)
- CPU: <2% (idle), <10% (active sync)
- Disk: ~100-500MB for text vault, more with images

**Pi5 Overall:**
- Before CouchDB: 1.0GB used / 7.87GB total
- After CouchDB: ~1.5GB used / 7.87GB total
- Plenty of headroom remaining

**Sync Speed:**
- Local network: Sub-second latency
- Over Tailscale: 1-3 second latency
- Initial sync: Depends on vault size (~1 minute for 100MB vault)

---

## Security

### Current Security

**Network:**
- ✅ Private network (192.168.1.XXX/24)
- ✅ No external exposure
- ✅ Tailscale VPN for remote access

**Authentication:**
- ✅ CouchDB basic auth (username/password)
- ✅ Strong generated password
- ⚠️ No HTTPS (OK on private network)

**Data:**
- ✅ Optional E2E encryption in plugin
- ✅ Passphrase-based encryption
- ✅ Server stores encrypted data only

### Optional Hardening

**Add HTTPS:**
- Route through Nginx Proxy Manager (192.168.1.XXX)
- Create proxy host: `couchdb.internal.lab` → `192.168.1.XXX:5984`
- Enable SSL certificate
- Update Obsidian URI to `https://couchdb.internal.lab/obsidian`

**Not required for local network usage.**

---

## Related Documentation

- [[GitOps-Workflow]] - Git version control for vault
- [[Homelab-Wiki]] - Public wiki publishing pipeline
- [[Pi-hole]] - Other services on Pi5
- [[Tailscale]] - VPN for remote access

---

## Quick Reference

### Commands

```bash
# Check CouchDB status
ssh cib@192.168.1.XXX "sudo docker ps | grep obsidian"

# View logs
ssh cib@192.168.1.XXX "sudo docker logs obsidian-couchdb --tail 50"

# Restart CouchDB
ssh cib@192.168.1.XXX "cd /opt/obsidian-livesync && sudo docker compose restart"

# Health check
curl http://192.168.1.XXX:5984/_up

# Database info
curl -s http://admin:[PASSWORD]@192.168.1.XXX:5984/obsidian | python3 -m json.tool
```

### Files & Locations

| Item | Location |
|------|----------|
| Credentials | `/home/cib/obsidian-livesync-credentials.txt` |
| Setup Guide | `/home/cib/OBSIDIAN-LIVESYNC-SETUP-GUIDE.md` |
| Monitoring Notes | `/home/cib/couchdb-monitoring-notes.md` |
| Docker Compose | `/opt/obsidian-livesync/docker-compose.yml` (on Pi5) |
| Data Directory | `/opt/obsidian-livesync/data/` (on Pi5) |

### Links

- **CouchDB Web UI:** http://192.168.1.XXX:5984/_utils
- **Plugin GitHub:** https://github.com/vrtmrz/obsidian-livesync
- **CouchDB Docs:** https://docs.couchdb.org/

---

## Deployment Info

**Deployed:** 2026-02-04

**CouchDB Version:** Latest (ARM64)

**Plugin:** Self-hosted LiveSync (community)

**Status:** ✅ Active & Syncing

---

## Future Plans

- [ ] Add CouchDB Prometheus exporter for detailed metrics
- [ ] Add CouchDB logs to Loki for centralized logging
- [ ] Create custom Grafana dashboard for sync statistics
- [ ] Test sync performance over Tailscale from mobile
- [ ] Document conflict resolution best practices
- [x] ~~Deploy CouchDB to Pi5~~ (Completed)
- [x] ~~Configure Obsidian plugin~~ (Completed)
- [x] ~~Test real-time sync~~ (Completed)

---

*Last Updated: 2026-02-04*
