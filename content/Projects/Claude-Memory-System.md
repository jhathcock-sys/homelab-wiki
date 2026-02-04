# Claude Code Memory System

[[_Index|← Back to Index]]

**Repo:** https://github.com/jhathcock-sys/ai-assistant-config | **Writeup:** https://jhathcock-sys.github.io/me/projects/claude-memory/

---

## Overview

Structured context system for AI-assisted infrastructure development. Converts the default markdown-based `CLAUDE.md` to XML format for better hierarchy and queryability.

---

## Memory Tree Architecture

The memory system uses a hierarchical structure to minimize context loading per session:

| Scope | File | Lines | Contents |
|-------|------|-------|----------|
| **Global** | `~/.claude/CLAUDE.md` | 100 | Persona, directives, workstation, project pointers |
| **Project** | `homelab-ops/CLAUDE.md` | ~267 | Infrastructure, Docker stacks, monitoring, security |
| **Project** | `homelab-docs/CLAUDE.md` | ~116 | Obsidian vault structure, navigation, documentation |
| **Project** | `podcast-studio/CLAUDE.md` | ~166 | LiveKit video recording, architecture, deployment |
| **Project** | `my-portfolio/CLAUDE.md` | ~60 | Hugo site structure, content tips, commands |
| **Project** | `ai-assistant-config/CLAUDE.md` | ~60 | Sync commands, memory architecture, backup tree |
| **Session** | `<project>/CLAUDE.internal.md` | varies | Private notes, credentials (gitignored) |

**Why split?** Context efficiency - infrastructure details only load when working in homelab-ops, portfolio tips only load in my-portfolio.

**Refactored (2026-02-04):** Global memory reduced from 123→100 lines by offloading verbose descriptions to project memories. Credentials moved to gitignored CLAUDE.internal.md files.

---

## File Tree Overview

```
~/.claude/CLAUDE.md (Global - 100 lines)
├── meta_data, persona, directives
├── interaction_rules, learning_path, goals
├── workstation info
└── project references (one-line descriptions)

homelab-ops/CLAUDE.md (Project - 267 lines)
├── infrastructure topology, access_points
├── Docker stacks, services, conventions
├── security_hardening, resource_management
└── monitoring stack (Prometheus, Grafana, Wazuh)

homelab-docs/CLAUDE.md (Project - 116 lines)
├── Obsidian vault structure (8 folders)
├── navigation system (wiki links)
└── workflow and security guidelines

podcast-studio/CLAUDE.md (Project - 166 lines)
├── LiveKit + MinIO architecture
├── storage planning, network requirements
└── deployment checklist, use cases

my-portfolio/CLAUDE.md (Project - 60 lines)
├── Hugo structure, commands
├── content tips, features
└── new_project_template

ai-assistant-config/CLAUDE.md (Project - 60 lines)
├── sync_commands
├── memory_architecture docs
└── memory_tree (all 5 projects)

ai-assistant-config/ (Backup Repository)
├── claude-code/
│   ├── CLAUDE.md        # Global memory backup
│   ├── settings.json    # Status line enabled
│   └── statusline.sh    # Custom status bar script
├── homelab-ops/CLAUDE.md
├── homelab-docs/CLAUDE.md
├── podcast-studio/CLAUDE.md
└── my-portfolio/CLAUDE.md
```

---

## XML Structure

```xml
<root>
    <meta_data>           <!-- Name, location, experience, strengths -->
    <persona>             <!-- Role definition and core directives -->
    <interaction_rules>   <!-- How to work with the user -->
    <learning_path>       <!-- Current focus areas, certifications -->
    <goals>               <!-- Prioritized project goals -->
    <infrastructure>      <!-- Topology, access points, services -->
    <projects>            <!-- Repos, paths, stack mappings -->
    <monitoring_config>   <!-- Dashboards, alerts, Wazuh agents -->
    <documentation_links> <!-- Obsidian log, session notes -->
</root>
```

---

## Core Directives

| Directive | Purpose |
|-----------|---------|
| **Idempotency** | Prefer solutions that can run multiple times without breaking |
| **Security First** | Least-privilege, no chmod 777, always suggest UFW rules |
| **Network Awareness** | Check [[Network-Topology]] before suggesting static IPs |
| **Documentation** | Include educational comments in all scripts |
| **Docker Compose Only** | Never provide `docker run`, always provide compose files |

---

## Benefits

- **Consistent context** across all sessions
- **Enterprise-grade suggestions** via persona definition
- **Security by default** reinforces Security+ studies
- **No IP conflicts** via network topology awareness
- **GitOps-compatible output** via Docker Compose directive

---

## Backup Repository

- **GitHub:** https://github.com/jhathcock-sys/ai-assistant-config
- **Local:** `/home/cib/ai-assistant-config`

```
ai-assistant-config/
├── claude-code/
│   ├── CLAUDE.md       # Backup of ~/.claude/CLAUDE.md (global)
│   ├── settings.json   # Claude Code settings (status line config)
│   ├── statusline.sh   # Custom Powerlevel10k-style status bar
│   └── skills/         # Custom skills (future)
├── homelab-ops/        # Project memory backups
│   └── CLAUDE.md
├── homelab-docs/
│   └── CLAUDE.md
├── podcast-studio/
│   └── CLAUDE.md
├── my-portfolio/
│   └── CLAUDE.md
└── prompts/            # Reusable prompt templates (future)
```

---

## Sync Commands

**Full Backup (All Projects):**
```bash
# Global memory
cp ~/.claude/CLAUDE.md ~/ai-assistant-config/claude-code/CLAUDE.md

# Project memories
cp ~/homelab-ops/CLAUDE.md ~/ai-assistant-config/homelab-ops/CLAUDE.md
cp ~/Documents/HomeLab/HomeLab/CLAUDE.md ~/ai-assistant-config/homelab-docs/CLAUDE.md
cp ~/podcast-studio/CLAUDE.md ~/ai-assistant-config/podcast-studio/CLAUDE.md
cp ~/my-portfolio/CLAUDE.md ~/ai-assistant-config/my-portfolio/CLAUDE.md
cp ~/ai-assistant-config/CLAUDE.md ~/ai-assistant-config/CLAUDE.md

# Commit and push
cd ~/ai-assistant-config && git add -A && git commit -m "Update memory" && git push
```

**Quick Sync (Global Only):**
```bash
cp ~/.claude/CLAUDE.md ~/ai-assistant-config/claude-code/CLAUDE.md
cd ~/ai-assistant-config && git add -A && git commit -m "Update global memory" && git push
```

---

## Portfolio Writeup

Full documentation with examples: https://jhathcock-sys.github.io/me/projects/claude-memory/

---

## Related Pages

- [[Portfolio-Site]]
- [[GitHub-Repositories]]
- [[Workstation-Setup]]
