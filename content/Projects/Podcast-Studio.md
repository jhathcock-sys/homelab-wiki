# Podcast Studio (Video Recording Platform)

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX]] | **Repo:** https://github.com/jhathcock-sys/podcast-studio

---

## Overview

Self-hosted video podcast recording platform for D&D sessions and podcasts. Supports 4K recording, multi-track audio, remote guests, and live streaming.

---

## Access URLs

| Service | URL | Purpose |
|---------|-----|---------|
| **Frontend** | http://192.168.1.XXX:8080 | Web application |
| **API** | http://192.168.1.XXX:3333 | Backend API |
| **LiveKit** | ws://192.168.1.XXX:7880 | WebRTC server |
| **MinIO Console** | http://192.168.1.XXX:9001 | Storage management |

---

## Tech Stack

- **WebRTC Server:** LiveKit (real-time communication)
- **Frontend:** React 18 + TypeScript + Vite
- **Backend:** Node.js/Express
- **Storage:** MinIO (S3-compatible)
- **Processing:** FFmpeg (post-processing)
- **TURN Server:** Coturn (NAT traversal)

---

## Repository

- **GitHub:** https://github.com/jhathcock-sys/podcast-studio
- **Local:** `/home/cib/podcast-studio`

---

## Architecture

Hybrid LiveKit + Double-Ended Recording:
- LiveKit handles real-time WebRTC and RTMP streaming
- Local recording on each browser for true 4K quality
- MinIO stores recordings
- FFmpeg post-processes with sync and normalization

---

## Storage Planning

| Quality | Per Hour | 6-Person 1hr Session |
|---------|----------|---------------------|
| **1080p** | ~3.6 GB | ~21.6 GB |
| **4K** | ~11.25 GB | ~67.5 GB |

**Recommendation:** Plan ~70 GB per 1-hour 6-person 4K session

### Retention Policy

- **Raw uploads:** 7 days (auto-delete after processing)
- **Processed files:** 90 days in MinIO
- **Archive:** Move to [[NAS-Synology]] for long-term storage

---

## Network Configuration

### Required Firewall Rules

```bash
# LiveKit
sudo ufw allow 7880/tcp comment "LiveKit API"
sudo ufw allow 7881/tcp comment "WebRTC TCP"
sudo ufw allow 7882/udp comment "WebRTC UDP"

# TURN Server
sudo ufw allow 3478 comment "TURN"
sudo ufw allow 10000:20000/udp comment "TURN relay"

# Application (local network only)
sudo ufw allow from 192.168.1.XXX/24 to any port 8080 comment "Podcast Frontend"
sudo ufw allow from 192.168.1.XXX/24 to any port 3333 comment "Podcast API"
sudo ufw allow from 192.168.1.XXX/24 to any port 9000:9001 comment "MinIO"
```

---

## Development Phases

- **Phase 1:** MVP - Basic 2-person video call with recording
- **Phase 2:** Multi-track recording (up to 6 participants)
- **Phase 3:** Post-processing pipeline (sync, normalize, multi-track export)
- **Phase 4:** Live streaming (YouTube/Twitch)
- **Phase 5:** Scene switching & polish (layouts, overlays, waiting room)

---

## Status

**Created:** 2026-02-03
**Status:** Initial setup complete, ready for deployment

---

## TODO

- [ ] Copy `.env.example` to `.env` and configure secrets
- [ ] Generate LiveKit API credentials
- [ ] Apply UFW firewall rules
- [ ] Deploy stack with `docker compose up -d`
- [ ] Test basic 2-person video call
- [ ] Configure Nginx Proxy Manager for SSL (`podcast.yourdomain.com`)

---

## Related Pages

- [[Network-Topology]]
- [[Current-TODO|Deployment Tasks]]
- [[NAS-Synology|Storage for Archives]]
- [[GitHub-Repositories]]
