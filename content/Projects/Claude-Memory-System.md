# Claude Code Memory System

[[_Index|← Back to Index]]

**Repo:** https://github.com/jhathcock-sys/ai-assistant-config | **Writeup:** https://jhathcock-sys.github.io/me/projects/claude-memory/

---

## Overview

Structured context system for AI-assisted infrastructure development. Uses XML format for better hierarchy and queryability. **Version 2.0 (Feb 2026)** implements symlink-based architecture for zero-copy sync workflow.

---

## Memory System 2.0 Architecture (Feb 2026)

**Major Refactoring:** Eliminated duplicate directories, manual sync commands, and content overlap. New symlink-based workflow makes the backup repository the single source of truth.

### Three-Layer Hierarchy

| Layer | File | Size | Contents |
|-------|------|------|----------|
| **Global** | `~/.claude/CLAUDE.md` → `ai-assistant-config/global/CLAUDE.md` | ~3KB | User profile, persona, core directives, interaction rules |
| **Session** | `~/.claude/projects/-home-cib--claude/memory/MEMORY.md` → `ai-assistant-config/session/MEMORY.md` | ~8KB | Workflow reminders, infrastructure notes, project quick-ref, active services |
| **Project** | `homelab-ops/CLAUDE.md` | ~15KB | Infrastructure topology, Docker stacks, monitoring, security |
| **Project** | `homelab-docs/CLAUDE.md` | ~5KB | Obsidian vault structure, navigation, documentation |
| **Project** | `homelab-wiki/CLAUDE.md` | ~6KB | Quartz v4 wiki, sanitization pipeline, deployment |
| **Project** | `podcast-studio/CLAUDE.md` | ~8KB | LiveKit video recording, architecture, deployment |
| **Project** | `my-portfolio/CLAUDE.md` | ~3KB | Hugo site structure, content tips, commands |
| **Local** | `<project>/CLAUDE.internal.md` | varies | Private notes, credentials (gitignored) |

**Why this works:**
- **Global** = Rarely changes (who I am, how I think)
- **Session** = Updates frequently (operational knowledge, recent changes)
- **Project** = Repository-specific context (loaded when in that directory)
- **Local** = Never committed (credentials, session history)

### Symlink Workflow

```bash
# Active locations are symlinked to backup repo
~/.claude/CLAUDE.md → ~/ai-assistant-config/global/CLAUDE.md
~/.claude/projects/-home-cib--claude/memory/MEMORY.md → ~/ai-assistant-config/session/MEMORY.md

# Edits anywhere propagate immediately (same file)
# No manual copy commands needed
```

---

## Repository Structure (2.0)

```
ai-assistant-config/ (Single source of truth)
├── global/
│   └── CLAUDE.md              # User profile, persona, directives (~3KB)
│                              # Symlinked from ~/.claude/CLAUDE.md
├── session/
│   └── MEMORY.md              # Operational knowledge, active services (~8KB)
│                              # Symlinked from ~/.claude/projects/-home-cib--claude/memory/
├── projects/                  # Project-specific context (ONE location per project)
│   ├── homelab-ops/CLAUDE.md  # Infrastructure, topology, monitoring (~15KB)
│   ├── homelab-docs/CLAUDE.md # Obsidian vault structure (~5KB)
│   ├── homelab-wiki/CLAUDE.md # Quartz wiki, sanitization (~6KB)
│   ├── podcast-studio/CLAUDE.md # LiveKit architecture (~8KB)
│   └── my-portfolio/CLAUDE.md # Hugo site structure (~3KB)
├── agents/                    # Custom agent definitions
│   ├── deploy-helper.md       # Validate Docker Compose files
│   ├── infra-validator.md     # Pre-deployment validation
│   ├── security-reviewer.md   # Security audit for stacks
│   └── doc-sync.md            # Vault synchronization
├── claude-code/               # Claude Code settings
│   ├── settings.json          # Status line enabled
│   ├── statusline.sh          # Custom status bar script
│   └── skills/                # Custom skills (future)
├── scripts/
│   ├── install-symlinks.sh    # One-time setup (creates symlinks)
│   └── sync.sh                # Commit and push changes
├── prompts/                   # Reusable prompt templates (future)
├── .gitignore                 # Protect credentials (*.local.md)
└── README.md                  # Documentation
```

### Content by Layer

**global/CLAUDE.md (~65 lines, ~3KB):**
- meta_data (name, location, experience, strengths)
- persona (role, mission, core directives)
- interaction_rules
- learning_path (certifications, focus areas)
- goals (prioritized projects)

**session/MEMORY.md (~130 lines, ~8KB):**
- Project quick-reference table (paths, repos, URLs)
- Workstation configuration (shell, aliases, tools)
- Workflow reminders (Quartz wiki, documentation sync)
- Infrastructure notes (server resources, GitOps workflow)
- Common mistakes avoided (SSH auth, Docker networks)
- Active services (URLs, monitoring stack)
- Recent changes log

**projects/*/CLAUDE.md (varies):**
- Repository structure and file organization
- Deployment conventions and commands
- Access points (SSH, web interfaces)
- Technology stack and dependencies
- Project-specific workflows

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

## Setup (One-Time)

**Install symlinks to enable zero-copy workflow:**

```bash
cd ~/ai-assistant-config
./scripts/install-symlinks.sh

# This script:
# 1. Backs up existing files to *.bak
# 2. Creates symlinks from active locations to backup repo
# 3. Makes backup repo the single source of truth
```

**Verify installation:**
```bash
ls -la ~/.claude/CLAUDE.md
# Should show: ~/.claude/CLAUDE.md -> /home/cib/ai-assistant-config/global/CLAUDE.md

ls -la ~/.claude/projects/-home-cib--claude/memory/MEMORY.md
# Should show: ...memory/MEMORY.md -> /home/cib/ai-assistant-config/session/MEMORY.md
```

---

## Daily Workflow

**Edit memory files (same as before):**
```bash
# Edit directly in repo (or through symlinks - same file!)
vim ~/ai-assistant-config/global/CLAUDE.md
vim ~/ai-assistant-config/session/MEMORY.md
vim ~/ai-assistant-config/projects/homelab-ops/CLAUDE.md
```

**Sync to GitHub (one command):**
```bash
cd ~/ai-assistant-config
./scripts/sync.sh "Optional commit message"

# ✅ Committed and pushed in one command
# No manual copy commands needed!
```

**Manual sync (if preferred):**
```bash
cd ~/ai-assistant-config
git add -A
git commit -m "Memory update"
git push
```

---

## Benefits of 2.0 Refactoring

| Metric | Before (1.0) | After (2.0) |
|--------|--------------|-------------|
| **Sync workflow** | 3 manual commands | `./scripts/sync.sh` |
| **Duplicate files** | 3+ copies per project | 1 canonical location |
| **Edit-to-commit time** | ~2 minutes | ~10 seconds |
| **Credential exposure risk** | Medium (no gitignore) | Low (.gitignore + patterns) |
| **File size (global)** | ~6KB | ~3KB |
| **File size (session)** | ~4KB | ~8KB |
| **Clarity** | Confusing duplicates | Clear 3-layer hierarchy |

---

## Security Improvements

**.gitignore added:**
```gitignore
# Sensitive files - credentials and tokens
*.local.md
**/CLAUDE.internal.md
secrets/
credentials/
```

**Credential pattern:**
```xml
<web_interface name="Grafana" url="http://192.168.1.XXX:3030" />
<note>Credentials stored in CLAUDE.internal.md (gitignored)</note>
```

Instead of hardcoding passwords in committed files.

---

## Refactoring History

### Version 1.0 (Feb 2-4, 2026)
- Initial XML-based memory system
- Manual copy commands for backup
- Global memory at `~/.claude/CLAUDE.md` (~6KB)
- Project files scattered at root level
- No gitignore for credentials

### Version 2.0 (Feb 5, 2026)
- **Symlink-based architecture** - zero-copy workflow
- **Three-layer hierarchy** - global (3KB), session (8KB), projects
- **Helper scripts** - `install-symlinks.sh`, `sync.sh`
- **Consolidated structure** - all projects in `projects/` directory
- **Security improvements** - `.gitignore` for `*.local.md` files
- **Content reorganization** - moved workstation/project details to session layer
- **Eliminated duplicates** - single source of truth in backup repo

**Problems solved:**
- Duplicate directories (`homelab-ops/` at root AND in `projects/`)
- Manual 3-command sync workflow (error-prone, easy to forget)
- Content overlap (workstation details in multiple files)
- No protection against accidentally committing credentials

**Key lessons:**
- Symlinks eliminate an entire class of sync problems
- Separation of concerns applies to context too (global/session/project)
- Automation compounds (30-second script saves hours over time)
- Git is the perfect memory backend (history, rollback, backup)

---

## Portfolio Writeup

Full documentation with examples and technical deep-dive: https://jhathcock-sys.github.io/me/projects/claude-memory/

---

## Related Pages

- [[Portfolio-Site]]
- [[GitHub-Repositories]]
- [[Workstation-Setup]]
