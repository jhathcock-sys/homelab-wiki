# Homelab Wiki

Public documentation wiki for the Hathcock homelab, powered by [Quartz v4](https://quartz.jzhao.xyz/).

## Overview

This repository is a **mirror** of the private `homelab-docs` Obsidian vault, with:
- Content sanitization to remove sensitive information
- Public-facing documentation at https://jhathcock-sys.github.io/homelab-wiki/
- WikiLinks, backlinks, and graph view support

## Repository Structure

- `content/` - Sanitized markdown files from homelab-docs
- `sync-sanitize.sh` - Pipeline to sync and sanitize content
- `sanitize-content.sh` - Sanitization rules
- `.publish-exclude` - Files to never publish

## Workflow

1. Update documentation in the private homelab-docs vault
2. Run `./sync-sanitize.sh` to mirror and sanitize content
3. Commit and push to trigger GitHub Pages deployment
4. Changes appear at https://jhathcock-sys.github.io/homelab-wiki/

## Sanitization

The following information is automatically scrubbed before publishing:
- Internal IP addresses
- Credentials and API keys
- Personal information
- MAC addresses
- Internal hostnames

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
