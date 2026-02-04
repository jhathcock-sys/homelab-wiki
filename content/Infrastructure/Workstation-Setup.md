# Laptop Workstation Setup

[[_Index|← Back to Index]]

**Last Updated**: 2026-02-04

---

## Hardware Specifications

### System Overview

| Component | Specification |
|-----------|---------------|
| **Model** | Dell Inspiron 7506 2-in-1 Convertible |
| **Hostname** | pop-os |
| **Form Factor** | Convertible laptop (2-in-1) |
| **Firmware** | Version 1.25.0 (2023-08-09) |

### Processor

| Item | Value |
|------|-------|
| **CPU** | Intel Core i5-1135G7 (11th Gen) |
| **Base Clock** | 2.40 GHz |
| **Architecture** | x86_64 (64-bit) |
| **Cores** | 4 physical cores |
| **Threads** | 8 threads (2 per core) |
| **Technology** | Intel Tiger Lake |

### Memory

| Item | Value |
|------|-------|
| **RAM** | 12 GB DDR4 |
| **Currently Used** | 8.9 GB |
| **Available** | 2.5 GB |
| **Swap** | 15 GB (4 GB currently used) |

### Graphics

| Item | Value |
|------|-------|
| **GPU** | Intel Iris Xe Graphics (TigerLake-LP GT2) |
| **Type** | Integrated graphics |
| **Driver** | Intel (no NVIDIA) |

### Storage

**Primary SSD**: Samsung NVMe 512GB (nvme1n1)

| Partition | Size | Mount Point | Usage |
|-----------|------|-------------|-------|
| nvme1n1p1 | 1 GB | /boot/efi | EFI boot partition |
| nvme1n1p2 | 4 GB | /recovery | Recovery partition |
| nvme1n1p3 | 468 GB | / (root) | Main system partition |
| nvme1n1p4 | 4 GB | cryptswap | Encrypted swap |

**Current Usage**:
- **Total Space**: 460 GB
- **Used**: 90 GB (21%)
- **Available**: 348 GB

**Secondary Storage**: 27.3 GB NVMe (nvme0n1) - RAID metadata device

**Virtual Memory**:
- **zram0**: 11.4 GB compressed RAM disk (swap)

### Power

| Item | Value |
|------|-------|
| **Battery Model** | DELL TXD0309 |
| **Current Charge** | 100% |
| **Type** | Lithium-ion |

---

## Operating System

### System Information

| Item | Value |
|------|-------|
| **OS** | Pop!_OS 24.04 LTS |
| **Desktop Environment** | COSMIC (Rust-based) |
| **Kernel** | Linux 6.17.9-76061709-generic |
| **Architecture** | x86-64 |
| **Shell** | Zsh 5.9 with Powerlevel10k theme |
| **Init System** | systemd |

### Security

| Item | Status |
|------|--------|
| **Firewall** | UFW (status unknown - requires sudo to check) |
| **Backups** | Timeshift (RSYNC snapshots) |
| **Disk Encryption** | Encrypted swap partition (cryptswap) |

---

## Development Environment

### Core Development Tools

| Tool | Version | Purpose |
|------|---------|---------|
| **Claude Code** | 2.1.31 | AI-powered CLI assistant |
| **Git** | 2.43.0 | Version control |
| **GitHub CLI (gh)** | 2.45.0 | GitHub integration |
| **Python** | 3.12.3 | Programming language |
| **Docker** | 28.2.2 | Container runtime |
| **VS Code** | 1.108.2 | Code editor |

### Text Editors

- **Nano** 7.2 (default simple editor)
- **Vim** 9.1.0016 (advanced text editor)
- **VS Code** 1.108.2 (GUI IDE)

### Docker Configuration

- **Installation**: docker.io package (28.2.2-0ubuntu1~24.04.1)
- **User Permissions**: User `cib` is in `docker` group (rootless access)
- **Compose**: Built-in Docker Compose plugin
- **Local Management**: Portainer at http://localhost:9000

### User Groups

User `cib` belongs to:
- `adm` - System administration
- `sudo` - Root privileges
- `lpadmin` - Printer administration
- `docker` - Docker container management
- `wireshark` - Network packet capture

---

## Installed Applications

### Flatpak Applications

| Application | Package ID | Purpose |
|-------------|-----------|---------|
| **Discord** | com.discordapp.Discord | Communication |
| **Alpaca** | com.jeffser.Alpaca | AI chat client |
| **COSMIC Tweaks** | dev.edfloreshz.CosmicTweaks | Desktop customization |
| **AppFlowy** | io.appflowy.AppFlowy | Note-taking, project management |
| **Obsidian** | md.obsidian.Obsidian | Knowledge base (homelab docs) |
| **Flameshot** | org.flameshot.Flameshot | Screenshot tool |
| **Freeplane** | org.freeplane.App | Mind mapping |
| **Thonny** | org.thonny.Thonny | Python IDE (beginner-friendly) |
| **Wireshark** | org.wireshark.Wireshark | Network protocol analyzer |

### System Packages (APT)

**Key Installed Packages**:
- **curl** - Data transfer tool
- **htop** - Interactive process viewer
- **flatpak** - Flatpak application manager
- **code** - Visual Studio Code
- **docker.io** - Docker container engine

---

## Network Configuration

### Network Tools

| Tool | Purpose |
|------|---------|
| **Tailscale** | VPN mesh for remote homelab access |
| **SSH** | Remote server management |
| **curl/wget** | HTTP clients for API testing |

### SSH Configuration

**Key Type**: Ed25519 (modern, secure)

**Passwordless Access Configured For**:
```bash
ssh root@192.168.1.XXX      # ProxMoxBox
ssh cib@192.168.1.XXX     # Pi5
```

**Note**: No `~/.ssh/config` file currently exists (direct IP connections used)

### Firewall

**UFW (Uncomplicated Firewall)**: Installed and configured
- Requires sudo to check status
- Protects against unauthorized network access

---

## Shell Configuration

### Zsh with Powerlevel10k

**Shell**: `/usr/bin/zsh` (version 5.9)
**Theme**: Powerlevel10k (Git-aware, customizable prompt)

### Shell Aliases (~/.zshrc)

| Alias | Command | Description |
|-------|---------|-------------|
| `update` | `sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y` | Full system update |
| `install` | `sudo apt install` | Quick package install |
| `myip` | `curl ifconfig.me` | Show public WAN IP |
| `ports` | `sudo lsof -i -P -n \| grep LISTEN` | Show open ports |
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `c` | `clear` | Clear terminal |
| `rm` | `rm -i` | Interactive delete (asks confirmation) |
| `mv` | `mv -i` | Interactive move (asks before overwrite) |

### Environment

**Default Shell**: Zsh
**Terminal Emulator**: COSMIC Terminal
**Prompt**: Powerlevel10k with Git integration

---

## COSMIC Desktop Environment

### About COSMIC

**Name**: COSMIC (Computer Operating System Main Interface Components)
**Developer**: System76
**Language**: Rust (memory-safe, performant)
**Status**: Beta release with Pop!_OS 24.04 LTS

### Configuration

| Setting | Location |
|---------|----------|
| **Terminal Headerbar** | `~/.config/cosmic/com.system76.CosmicTerm/v1/show_headerbar` |
| **Window Manager** | COSMIC Compositor (Wayland) |
| **Display Server** | Wayland (not X11) |

### Known Limitations

**Night Light**:
- Standard COSMIC Night Light may not work on Intel Iris Xe with Wayland
- **Workaround**: Use `gammastep` (Wayland-compatible alternative)

---

## Claude Code Configuration

### Installation

- **Location**: `~/.local/bin/claude`
- **Version**: 2.1.31
- **Model**: Sonnet (with Opus for planning)

### Configuration Files

| File | Purpose |
|------|---------|
| `~/.claude/settings.json` | Model settings, custom statusline |
| `~/.claude/settings.internal.json` | SSH/SCP permissions |
| `~/.claude/CLAUDE.md` | Global memory and preferences |
| `~/.claude/statusline.sh` | Powerlevel10k-style status display |
| `~/.claude/agents/` | Custom sub-agents (4 agents) |

### Custom Agents

See [[Claude-Code-Agents]] for full documentation.

**Installed Agents**:
1. **security-reviewer** - Docker Compose security auditing
2. **infra-validator** - Pre-deployment conflict detection
3. **doc-sync** - Obsidian vault synchronization
4. **deploy-helper** - Docker Compose convention enforcement

---

## Backup Strategy

### Timeshift

**Method**: RSYNC snapshots
**Purpose**: System state backups for disaster recovery
**Location**: Separate partition or external drive

### Git Repositories

All critical configurations version-controlled:

| Repository | Path | Purpose |
|------------|------|---------|
| **homelab-ops** | `/home/cib/homelab-ops` | Docker Compose stacks |
| **homelab-docs** | `/home/cib/Documents/HomeLab/HomeLab` | Obsidian vault |
| **ai-assistant-config** | `/home/cib/ai-assistant-config` | Claude Code configs |
| **my-portfolio** | `/home/cib/my-portfolio` | Hugo portfolio site |
| **podcast-studio** | `/home/cib/podcast-studio` | Video platform project |

---

## Performance Characteristics

### Current Resource Usage

**Memory**: 8.9 GB / 12 GB (74% used)
- High usage likely due to:
  - COSMIC desktop environment (Rust-based, but still memory-intensive)
  - VS Code
  - Multiple browser tabs
  - Docker containers (if running locally)
  - Flatpak applications

**Swap**: 4 GB / 15 GB used
- System using swap despite available RAM (normal Linux behavior)
- zram compression likely helping performance

**Disk**: 90 GB / 460 GB (21% used)
- Plenty of space available for projects and containers

**CPU**: Intel i5-1135G7 (4C/8T)
- Mid-range Tiger Lake processor
- Good balance for development work and homelab management
- Integrated graphics (no discrete GPU)

---

## Use Cases

### Primary Functions

1. **Homelab Management**
   - SSH access to ProxMoxBox, Pi5, and other devices
   - Docker Compose development and testing
   - Portainer for local container management
   - Git-based infrastructure as code

2. **Development**
   - VS Code for code editing
   - Claude Code for AI-assisted development
   - Python 3.12 for scripting
   - Docker for containerized testing

3. **Documentation**
   - Obsidian for homelab knowledge base
   - Git for version control
   - Markdown for all documentation

4. **Security**
   - Wireshark for network analysis
   - Timeshift for system backups
   - UFW firewall for network protection
   - Wazuh agent (planned) for SIEM integration

### Workflow

**Typical Session**:
1. Open COSMIC Terminal with Zsh + Powerlevel10k
2. SSH into ProxMoxBox for Docker management
3. Edit compose files locally in VS Code
4. Use Claude Code agents for pre-deployment validation
5. Deploy via Git push or direct SSH commands
6. Document changes in Obsidian vault
7. Commit and push to GitHub

---

## Maintenance

### Regular Updates

```bash
# Run weekly
update  # Alias for full system upgrade

# Check disk space
df -h /

# Review running services
systemctl list-units --type=service --state=running

# Check Docker containers (if running locally)
docker ps
```

### Backup Verification

- **Timeshift**: Verify snapshots exist and are recent
- **Git**: Ensure all repositories are pushed to GitHub
- **Claude Code agents**: Backed up to `~/ai-assistant-config/agents/`

### Monitoring

- **Battery Health**: Check capacity regularly (currently 100%)
- **Disk Usage**: Keep root partition below 80% full
- **Memory**: Monitor for memory leaks (currently high usage)
- **Swap Usage**: Excessive swap use indicates RAM shortage

---

## Known Issues

### Current Issues

1. **High Memory Usage** (8.9 GB / 12 GB)
   - COSMIC desktop is memory-intensive
   - Consider closing unused applications
   - Flatpak apps can be resource-heavy

2. **No SSH Config File**
   - SSH connections use direct IPs
   - **TODO**: Create `~/.ssh/config` for easier connections

3. **Night Light Limitations**
   - Native COSMIC Night Light may not work with Intel Iris Xe + Wayland
   - Use `gammastep` as workaround

### Workarounds Applied

- **Claude Code agents**: Backed up to Git (agent execution errors resolved)
- **Docker permissions**: User added to `docker` group (no sudo required)

---

## Future Enhancements

### Planned Improvements

- [ ] Create `~/.ssh/config` for named SSH connections
- [ ] Install and configure `gammastep` for night light
- [ ] Set up Wazuh agent for SIEM integration
- [ ] Configure automatic Timeshift snapshots schedule
- [ ] Reduce memory usage (close unused Flatpak apps)
- [ ] Set up SSH tunneling for secure remote homelab access
- [ ] Configure Claude Code hooks for pre-commit validation

### Software to Evaluate

- **Neovim**: Advanced Vim fork for terminal editing
- **Tmux**: Terminal multiplexer for persistent SSH sessions
- **Node.js/npm**: JavaScript runtime (not currently installed)
- **Ansible**: Configuration management (for homelab automation)

---

## Related Documentation

- [[Claude-Code-Agents]] - Custom agent system documentation
- [[Claude-Memory-System]] - Claude Code global configuration
- [[Personal-Context]] - User preferences and context
- [[Docker-Commands]] - Common Docker commands and patterns
- [[GitOps-Workflow]] - Infrastructure as Code workflow
- [[Network-Topology]] - Homelab network layout

---

## Quick Reference

### Common Commands

```bash
# System info
hostnamectl
lscpu
free -h
df -h

# Updates
update  # Alias

# Network
myip    # Alias for public IP
ports   # Alias for open ports
ssh root@192.168.1.XXX  # ProxMoxBox

# Docker
docker ps
docker stats
docker system prune  # Clean up unused resources

# Claude Code
claude  # Start interactive session
claude "Use security-reviewer to check proxmox/monitoring/"

# Git
git status
git pull
git add . && git commit -m "message" && git push
```

---

**Workstation Role**: Development and homelab management laptop
**Owner**: James Hathcock
**Primary Purpose**: Remote infrastructure management, documentation, and development

---

*Last hardware audit: 2026-02-04*
*Next review: After major system changes or quarterly*
