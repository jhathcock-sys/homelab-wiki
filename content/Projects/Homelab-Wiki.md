# Homelab Wiki

**Status**: ✅ Live
**URL**: https://jhathcock-sys.github.io/homelab-wiki/
**Repository**: https://github.com/jhathcock-sys/homelab-wiki
**Created**: 2026-02-04

---

## Overview

Public-facing documentation wiki built from this Obsidian vault using **Quartz v4**. The wiki is a **mirror repository** that automatically sanitizes sensitive information before publishing.

## Purpose

- Share homelab knowledge publicly
- Portfolio piece demonstrating infrastructure documentation
- Practice security-conscious content publishing
- Maintain WikiLinks and graph view from Obsidian

## Architecture

### Mirror Repository Approach

```
homelab-docs (Private Obsidian Vault)
         ↓
   sync-sanitize.sh
         ↓
  homelab-wiki (Public Repo)
         ↓
   GitHub Actions
         ↓
   GitHub Pages (Live Site)
```

**Benefits:**
- Original vault stays pure Obsidian
- Test wiki changes without affecting vault
- Controlled content publication
- No plugin conflicts

## Repository Structure

```
~/homelab-wiki/
├── content/              # Sanitized markdown files
├── sync-sanitize.sh      # Sync + sanitize pipeline
├── sanitize-content.sh   # Security scrubbing rules
├── .publish-exclude      # Files to never publish
├── quartz.config.ts      # Site configuration
└── .github/workflows/
    └── deploy.yml        # Auto-deployment
```

## Content Sanitization

### Information Scrubbed

| Category | Example | Replacement |
|----------|---------|-------------|
| IP Addresses | `192.168.1.XXX` | `192.168.1.XXX` |
| Credentials | `password: [REDACTED] | `password: [REDACTED] |
| MAC Addresses | `XX:XX:XX:XX:XX:XX` | `XX:XX:XX:XX:XX:XX` |
| Internal Domains | `.local`, `.home` | `.internal` |
| Personal Email | `admin@example.com` | `admin@example.com` |

### Files Excluded

- `credentials.md`, `passwords.md`, `secrets.md`
- `.obsidian/` metadata
- `.git/` version control
- Draft and WIP files
- Personal notes and journals

## Publishing Workflow

1. **Update Documentation**
   ```bash
   # Edit files in ~/Documents/HomeLab/HomeLab/
   ```

2. **Sync and Sanitize**
   ```bash
   cd ~/homelab-wiki
   ./sync-sanitize.sh
   ```

3. **Review Changes**
   ```bash
   git status
   git diff
   # Security checks
   grep -r '192\.168\.1\.[0-9]' content/
   ```

4. **Publish**
   ```bash
   git add -A
   git commit -m "Update documentation"
   git push
   ```

5. **Auto-Deploy**
   - GitHub Actions builds Quartz (~20s)
   - Deploys to GitHub Pages (~10s)
   - Site live in ~30 seconds

## Features

- ✅ **Search**: Full-text search across all pages
- ✅ **Graph View**: Visual connection map of WikiLinks
- ✅ **Backlinks**: Shows pages linking to current page
- ✅ **Dark Mode**: Theme toggle
- ✅ **Explorer**: Folder structure navigation
- ✅ **Table of Contents**: Auto-generated per page
- ✅ **WikiLinks**: Native Obsidian link support
- ✅ **SPA Routing**: Fast page transitions

## Technical Stack

- **Static Site Generator**: Quartz v4
- **Build Tool**: Node.js 22 + npm
- **CI/CD**: GitHub Actions
- **Hosting**: GitHub Pages
- **Theme**: Quartz default (customizable)

## Security Verification

Run these commands after each sync:

```bash
# Check for unsanitized IPs
grep -r '192\.168\.1\.[0-9]' content/

# Check for credentials
grep -ri 'password: [REDACTED] content/ | grep -v '\[REDACTED\]'

# Check for personal info
grep -ri 'hathcock' content/
```

## Statistics

- **Content**: 37 markdown files
- **Build Output**: 96 files
- **Deployment Time**: ~32 seconds
- **Features**: 7+ interactive components

## Related Pages

- [[GitOps-Workflow|GitOps Workflow]] - Version control practices
- [[GitHub-Repositories|GitHub Repositories]] - All project repos
- [[Portfolio-Site|Portfolio Site]] - Personal website
- [[Claude-Code-Agents|Claude Code Agents]] - Automation tools

## Resources

- [Quartz v4 Documentation](https://quartz.jzhao.xyz/)
- [GitHub Repository](https://github.com/jhathcock-sys/homelab-wiki)
- [Live Wiki](https://jhathcock-sys.github.io/homelab-wiki/)

---

**Last Updated**: 2026-02-04
**Maintainer**: James Hathcock
