# GitHub Repositories

[[_Index|← Back to Index]]

---

## Active Repositories

| Repository | Purpose | Local Path | URL |
|------------|---------|------------|-----|
| **homelab-ops** | Infrastructure as Code (Docker Compose) | `/home/cib/homelab-ops` | https://github.com/jhathcock-sys/Dockers |
| **homelab-docs** | Obsidian vault documentation (wiki-linked) | `/home/cib/Documents/HomeLab/HomeLab` | https://github.com/jhathcock-sys/homelab-docs |
| **ai-assistant-config** | Claude Code memory backup & skills | `/home/cib/ai-assistant-config` | https://github.com/jhathcock-sys/ai-assistant-config |
| **me** | Portfolio site (Hugo + PaperMod) | `/home/cib/my-portfolio` | https://github.com/jhathcock-sys/me |
| **podcast-studio** | Video podcast recording platform (4K, multi-track) | `/home/cib/podcast-studio` | https://github.com/jhathcock-sys/podcast-studio |

---

## Live Sites

- **Portfolio:** https://jhathcock-sys.github.io/me/

---

## Repository Details

### homelab-ops
- **Purpose:** [[GitOps-Workflow|GitOps repository]] for all Docker compose files
- **Structure:** Organized by host (`proxmox/`, `pi5/`)
- **Deployment:** Files deployed to `/opt/` on servers

### ai-assistant-config
- **Purpose:** [[Claude-Memory-System]] backup and custom skills
- **Contents:** CLAUDE.md files, settings.json, statusline.sh
- **Sync:** Manual sync via shell script

### me (Portfolio)
- **Purpose:** [[Portfolio-Site|Personal portfolio]] and resume
- **Tech:** Hugo static site generator with PaperMod theme
- **Deploy:** GitHub Actions auto-deploys to GitHub Pages

### podcast-studio
- **Purpose:** [[Podcast-Studio|Video podcast platform]] for D&D sessions
- **Tech:** LiveKit, React, MinIO, FFmpeg
- **Status:** Initial setup complete, pending deployment

---

## Related Pages

- [[GitOps-Workflow]]
- [[Claude-Memory-System]]
- [[Portfolio-Site]]
- [[Podcast-Studio]]
