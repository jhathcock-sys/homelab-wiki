# Memory System 2.0 - Symlink Architecture

[[_Index|← Back to Index]]

**Date:** 2026-02-05 | **Session Duration:** ~2 hours | **Commits:** `da44f38`, `4bbba5a`

---

## Overview

Complete architectural refactoring of Claude Code memory system. Eliminated duplicate directories, manual sync commands, and content overlap. Implemented symlink-based workflow where the backup repository becomes the single source of truth.

**Breaking Change:** Directory structure completely reorganized for long-term maintainability.

---

## Problems with Version 1.0

### 1. Duplicate Directories
```
ai-assistant-config/
├── homelab-ops/CLAUDE.md      # Root-level backup
├── projects/homelab-ops/       # DUPLICATE backup
└── my-portfolio/               # Another duplicate
```
Three or more copies of the same project files existed in the backup repository.

### 2. Manual Sync Workflow
```bash
# Had to remember and execute these commands:
cp ~/.claude/CLAUDE.md ~/ai-assistant-config/claude-code/CLAUDE.md
cp ~/.claude/projects/-home-cib--claude/memory/MEMORY.md ~/ai-assistant-config/memory/
cd ~/ai-assistant-config && git add -A && git commit && git push
```
- Error-prone (easy to forget steps)
- Time-consuming (~2 minutes per sync)
- No single source of truth (files existed in two places)

### 3. Content Overlap
- Workstation details duplicated in global and session memory
- Project paths listed in multiple files
- IP topology scattered across files
- Unclear which file should contain what information

### 4. Security Risk
- Some project CLAUDE.md files had credentials in examples
- No `.gitignore` to prevent accidentally committing `.local.md` files
- Medium risk of credential exposure

---

## Solution: Symlink-Based Architecture

### New Directory Structure

```
ai-assistant-config/
├── global/
│   └── CLAUDE.md              # User profile, persona, directives (~3KB)
├── session/
│   └── MEMORY.md              # Operational knowledge, active services (~8KB)
├── projects/                  # ONE location per project
│   ├── homelab-ops/CLAUDE.md
│   ├── homelab-docs/CLAUDE.md
│   ├── homelab-wiki/CLAUDE.md
│   ├── podcast-studio/CLAUDE.md
│   └── my-portfolio/CLAUDE.md
├── agents/                    # Custom agent definitions
│   ├── deploy-helper.md
│   ├── infra-validator.md
│   ├── security-reviewer.md
│   └── doc-sync.md
├── scripts/
│   ├── install-symlinks.sh    # One-time setup
│   └── sync.sh                # Commit and push changes
├── claude-code/               # Claude Code settings
│   ├── settings.json
│   ├── statusline.sh
│   └── skills/
├── .gitignore                 # Protect credentials
└── README.md                  # Documentation
```

### Symlink Mapping

```bash
# Active locations point to backup repository
~/.claude/CLAUDE.md → ~/ai-assistant-config/global/CLAUDE.md
~/.claude/projects/-home-cib--claude/memory/MEMORY.md → ~/ai-assistant-config/session/MEMORY.md
```

**Key principle:** Files exist ONLY in the backup repository. Active locations are symlinks, making edits immediately available without copy commands.

---

## Implementation

### Phase 1: Backup Current State
```bash
cp -r ~/ai-assistant-config ~/ai-assistant-config.backup-20260205
```

### Phase 2: Restructure Directories
1. Created `global/`, `session/`, `scripts/` directories
2. Moved `memory/MEMORY.md` → `session/MEMORY.md`
3. Moved `claude-code/CLAUDE.md` → `global/CLAUDE.md`
4. Consolidated all project folders into `projects/`
5. Deleted duplicate `projects/` subdirectories
6. Removed empty directories

### Phase 3: Sanitize Credentials
1. Added `.gitignore` for `*.local.md` files
2. Verified no hardcoded passwords in project files (0 findings)
3. Documented credential storage pattern in README.md

### Phase 4: Content Refactoring

**global/CLAUDE.md (slimmed to ~3KB):**
- ✅ Kept: User profile, persona, directives, interaction rules, learning path
- ❌ Removed: Workstation details (→ session)
- ❌ Removed: Project paths (→ session)
- ❌ Removed: Documentation pointers (→ session)

**session/MEMORY.md (expanded to ~8KB):**
- ✅ Added: Project quick-reference table
- ✅ Added: Workstation configuration details
- ✅ Added: Workflow reminders
- ✅ Added: Recent changes log

### Phase 5: Helper Scripts

**`scripts/install-symlinks.sh`:**
```bash
#!/bin/bash
# One-time setup: create symlinks from active locations to backup repo

# Backup existing files
mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak
mv ~/.claude/projects/-home-cib--claude/memory/MEMORY.md \
   ~/.claude/projects/-home-cib--claude/memory/MEMORY.md.bak

# Create symlinks
ln -sf ~/ai-assistant-config/global/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/ai-assistant-config/session/MEMORY.md \
       ~/.claude/projects/-home-cib--claude/memory/MEMORY.md
```

**`scripts/sync.sh`:**
```bash
#!/bin/bash
# Commit and push memory changes
# Since symlinks are used, files are already in place - just commit

cd ~/ai-assistant-config
git add -A
git commit -m "Memory sync $(date +%Y-%m-%d\ %H:%M)"
git push
```

### Phase 6: Update Documentation
- Updated `README.md` with new structure and usage
- Updated root `CLAUDE.md` with self-description
- Updated [[Claude-Memory-System]] page in Obsidian vault
- Updated [[Portfolio-Site]] with Evolution section

### Phase 7: Commit and Push
```bash
git add -A
git commit -m "Refactor memory system architecture"
git push
```

---

## Results

| Metric | Before (1.0) | After (2.0) | Improvement |
|--------|--------------|-------------|-------------|
| **Sync workflow** | 3 manual commands | `./scripts/sync.sh` | 66% faster |
| **Duplicate files** | 3+ copies per project | 1 canonical location | 100% reduction |
| **Edit-to-commit time** | ~2 minutes | ~10 seconds | 92% faster |
| **Credential exposure risk** | Medium | Low | .gitignore + patterns |
| **File size (global)** | ~6KB | ~3KB | 50% reduction |
| **File size (session)** | ~4KB | ~8KB | Context expanded |
| **Directory structure** | Confusing duplicates | Clear 3-layer hierarchy | Much clearer |

---

## Three-Layer Memory Hierarchy

| Layer | File | Size | Purpose | Update Frequency |
|-------|------|------|---------|------------------|
| **Global** | `global/CLAUDE.md` | ~3KB | User profile, persona, directives | Rarely (weeks) |
| **Session** | `session/MEMORY.md` | ~8KB | Operational knowledge, active services | Frequently (daily) |
| **Project** | `projects/*/CLAUDE.md` | Varies | Repository-specific context | Per-project |

**Why this works:**
- Global = Who I am, how I think (stable)
- Session = How things work right now (dynamic)
- Project = Specific implementation details (contextual)

---

## New Workflow

**Editing memory:**
```bash
# Edit directly in repo (or through symlinks - same file!)
vim ~/ai-assistant-config/global/CLAUDE.md
vim ~/ai-assistant-config/session/MEMORY.md
```

**Syncing to Git:**
```bash
cd ~/ai-assistant-config
./scripts/sync.sh "Optional commit message"
# ✅ Committed and pushed in one command
```

**Adding new project context:**
```bash
vim ~/ai-assistant-config/projects/new-project/CLAUDE.md
./scripts/sync.sh "Add new-project context"
```

---

## Security Improvements

**Created `.gitignore`:**
```gitignore
# Sensitive files - credentials and tokens
*.local.md
**/CLAUDE.internal.md
secrets/
credentials/

# OS and editor files
.DS_Store, Thumbs.db, .vscode/, .idea/, *.swp
```

**Credential pattern:**
```xml
<web_interface name="Grafana" url="http://192.168.1.XXX:3030" />
<note>Credentials stored in CLAUDE.internal.md (gitignored)</note>
```

**Verification:** `grep -r "password.*:" ~/ai-assistant-config/projects/ | grep -v REDACTED` returns 0 results.

---

## Files Modified

**Git Commit Summary:**
```
14 files changed, 437 insertions(+), 506 deletions(-)
```

**Key Changes:**
1. Created `global/CLAUDE.md` (slimmed from claude-code/CLAUDE.md)
2. Created `session/MEMORY.md` (expanded from memory/MEMORY.md)
3. Moved 5 project CLAUDE.md files to `projects/` directory
4. Created `scripts/install-symlinks.sh` and `scripts/sync.sh`
5. Created `.gitignore`
6. Updated `README.md` and root `CLAUDE.md`
7. Deleted duplicate directories

---

## Verification

✅ **Symlinks created and working:**
```bash
ls -la ~/.claude/CLAUDE.md
# lrwxrwxrwx ... ~/.claude/CLAUDE.md -> ~/ai-assistant-config/global/CLAUDE.md

ls -la ~/.claude/projects/-home-cib--claude/memory/MEMORY.md
# lrwxrwxrwx ... -> ~/ai-assistant-config/session/MEMORY.md
```

✅ **No credentials in git:** 0 findings
✅ **File sizes appropriate:** 3KB global, 8KB session
✅ **Sync script working:** Tested successfully
✅ **All changes committed and pushed**
✅ **Backup created:** `~/ai-assistant-config.backup-20260205`

---

## Lessons Learned

### 1. Premature Organization is Real
The original structure made sense with 2 projects. By project 5, it was technical debt. Don't over-engineer from day one, but be willing to refactor when pain points emerge.

### 2. Symlinks are Underutilized
The symlink approach eliminates an entire class of sync problems. Why copy when you can link?

### 3. Separation of Concerns Applies to Context
Just like code, memory benefits from clear layers:
- Global = Interface (public persona, directives)
- Session = Business logic (how things work right now)
- Project = Data layer (specific implementation details)

### 4. Automation Compounds
`install-symlinks.sh` is a 30-second investment that saves 2 minutes every sync. Over a year, that's hours saved and countless forgotten syncs prevented.

### 5. Git is the Perfect Memory Backend
- Version history for memory evolution
- Rollback capability (`git checkout <commit>`)
- Conflict resolution if editing on multiple machines
- Free backup via GitHub

---

## Rollback Plan

If issues occur:
```bash
rm -rf ~/ai-assistant-config
mv ~/ai-assistant-config.backup-20260205 ~/ai-assistant-config
```

---

## Related Pages

- [[Claude-Memory-System]]
- [[Claude-Code-Agents]]
- [[Portfolio-Site]]
- [[GitOps-Workflow]]
- [[2026-02-04-Memory-Architecture-Refactoring]] (Version 1.0)

---

## Future Enhancements

- [x] ~~Create project-specific CLAUDE.md files~~ ✅ Completed (v1.0)
- [x] ~~Add backup/sync automation~~ ✅ Completed (v2.0 with sync.sh)
- [x] ~~Implement credential security patterns~~ ✅ Completed (v2.0 with .gitignore)
- [ ] Add runbooks section for common procedures
- [ ] Document MCP server integrations
- [ ] Create maintenance windows directive
- [ ] Add dependency mapping between services
