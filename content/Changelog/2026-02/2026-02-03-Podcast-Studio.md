# Podcast Studio Creation (2026-02-03)

[[_Changelog-Index|← Back to Changelog]]

---

## Overview

Created self-hosted video podcast recording platform for D&D sessions and podcasts. Supports 4K recording, multi-track audio, remote guests, and live streaming.

---

## Repository Created

- **GitHub:** https://github.com/jhathcock-sys/podcast-studio
- **Local:** `/home/cib/podcast-studio`
- **IP Assignment:** [[Network-Topology|192.168.1.XXX]]

**Commit:** `f0d72c0` - Initial repository setup

---

## Tech Stack Selected

### WebRTC & Streaming
- **LiveKit** - Real-time communication server
- **Coturn** - TURN server for NAT traversal

### Application
- **Frontend:** React 18 + TypeScript + Vite
- **Backend:** Node.js/Express

### Storage & Processing
- **MinIO** - S3-compatible object storage
- **FFmpeg** - Post-processing pipeline

---

## Architecture Design

### Hybrid Recording Approach

**LiveKit Handles:**
- Real-time WebRTC communication
- RTMP live streaming output
- Session management

**Local Browser Recording:**
- True 4K quality (no WebRTC compression)
- Multi-track audio isolation
- Upload to MinIO after session

**FFmpeg Post-Processing:**
- Sync tracks from multiple participants
- Audio normalization
- Multi-track export for editing

---

## Storage Planning

### Capacity Requirements

| Quality | Per Hour | 6-Person Session (1hr) |
|---------|----------|----------------------|
| **1080p** | ~3.6 GB | ~21.6 GB |
| **4K** | ~11.25 GB | ~67.5 GB |

**Recommendation:** Plan ~70 GB per 1-hour 6-person 4K session

### Retention Policy

- **Raw uploads:** 7 days (auto-delete after processing)
- **Processed files:** 90 days in MinIO
- **Archive:** Move to [[NAS-Synology]] for long-term storage

---

## Network Configuration

### Firewall Rules Required

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

## Access URLs (When Deployed)

| Service | URL | Purpose |
|---------|-----|---------|
| **Frontend** | http://192.168.1.XXX:8080 | Web application |
| **API** | http://192.168.1.XXX:3333 | Backend API |
| **LiveKit** | ws://192.168.1.XXX:7880 | WebRTC server |
| **MinIO Console** | http://192.168.1.XXX:9001 | Storage management |

---

## Deployment Tasks (Pending)

See [[Current-TODO#Podcast Studio Deployment]] for deployment checklist:

- [ ] Copy `.env.example` to `.env` and configure secrets
- [ ] Generate LiveKit API credentials
- [ ] Apply UFW firewall rules
- [ ] Deploy stack with `docker compose up -d`
- [ ] Test basic 2-person video call
- [ ] Configure external access via NPM

---

## Use Case: D&D Sessions

### Recording Setup
1. DM starts session from main interface
2. Up to 6 players join via browser (no install)
3. Each browser records local 4K video + audio
4. LiveKit handles real-time communication
5. Session can be live-streamed to Twitch/YouTube

### Post-Session
1. All recordings auto-upload to MinIO
2. FFmpeg syncs and normalizes tracks
3. Multi-track file exported for editing
4. Raw files deleted after 7 days
5. Processed files archived to [[NAS-Synology]]

---

## Technical Considerations

### Why Not Just OBS?
- **Multi-participant recording:** Each person records locally (no quality loss)
- **Remote guests:** Browser-based, no software install
- **Multi-track export:** Each participant's audio isolated
- **Live streaming capability:** Built-in RTMP output

### Storage Strategy
- MinIO on local SSD for recording uploads
- [[NAS-Synology|NAS]] for long-term archive (7.2TB available)
- Automatic cleanup prevents disk fill

---

## Updates (2026-02-04)

**Participant Increase:** Updated to support 6 participants (from 4)
- Storage planning adjusted: 6-person 4K = ~70GB
- LiveKit max set to 10 (buffer for flexibility)

**Commit:** `3e5ee87`

---

## Related Pages

- [[Podcast-Studio]]
- [[Current-TODO]]
- [[Network-Topology]]
- [[NAS-Synology]]
- [[Future-Plans]]
- [[GitHub-Repositories]]
