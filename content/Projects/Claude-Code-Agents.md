# Claude Code Custom Agents

**Created**: 2026-02-04
**Location**: `~/.claude/agents/`
**Backup**: `~/ai-assistant-config/agents/`
**Agent Count**: 4 specialized agents

---

## Overview

Custom sub-agent system for automated homelab infrastructure validation and security auditing. These agents provide specialized, parallel analysis capabilities integrated with Claude Code's Task tool.

---

## Agent Architecture

### How Sub-Agents Work

Claude Code's Task tool can spawn specialized agents with different capabilities:

| Type | Use Case | Tools Available |
|------|----------|-----------------|
| `general-purpose` | Multi-step tasks, flexible workflows | All tools |
| `Bash` | Command execution, git ops | Bash only |
| `Explore` | Fast codebase search | Read-only tools |
| `Plan` | Architecture design | Read-only tools |

### Execution Patterns

**Parallel Execution** - Launch multiple agents in a single message:
```
"Review nginx stack with security-reviewer AND infra-validator in parallel"
→ Both agents run simultaneously, results combined
```

**Sequential Execution** - When outputs depend on each other:
```
"First validate compose file, then generate deployment commands"
→ Second agent waits for first to complete
```

**Background Execution** - Long-running tasks:
```
run_in_background: true
→ Agent runs asynchronously, check results later
```

---

## Custom Agents

### 1. Security Reviewer

**File**: `~/.claude/agents/security-reviewer.md`
**Model**: Sonnet
**Purpose**: Audit Docker Compose stacks for security vulnerabilities

#### Checks Performed

- ✓ Privileged mode usage (`privileged: true`)
- ✓ Docker socket mounts (must be `:ro`)
- ✓ Hardcoded secrets / default passwords
- ✓ Image tag pinning (no `:latest` in production)
- ✓ Security options (`no-new-privileges:true`)
- ✓ Resource limits (DoS prevention)
- ✓ Network exposure analysis
- ✓ UFW firewall rule generation

#### Example Usage

```bash
# Single stack audit
"Use security-reviewer to check proxmox/monitoring/"

# Multiple stacks in parallel
"Use security-reviewer to audit proxmox/dockhand, proxmox/monitoring, and proxmox/homepage in parallel"
```

#### Output Format

- **Critical Issues** (fix immediately) - Privileged mode, docker socket write access
- **High Priority** (before production) - Default passwords, missing security options
- **Medium Priority** (next maintenance) - Image pinning, network exposure
- **Low Priority** (informational) - Volume mounts, user specification

#### Security+ Integration

Provides educational context for Security+ certification topics:
- Attack frameworks (privilege escalation)
- Configuration management
- Network security (defense in depth)
- CIA triad (availability)
- Supply chain security

#### First Audit Results

**Stack**: proxmox/monitoring/
**Date**: 2026-02-04
**Result**: MEDIUM risk - see [[Monitoring-Stack-Security-Audit]]

**Key Findings**:
- ✅ Previous hardening properly applied
- ❌ Missing `.env` file (critical)
- ⚠️ All services using `:latest` tags
- ⚠️ 7 services missing security options
- ⚠️ 8 ports need UFW firewall rules

---

### 2. Infrastructure Validator

**File**: `~/.claude/agents/infra-validator.md`
**Model**: Sonnet
**Purpose**: Pre-deployment validation - detect conflicts before containers start

#### Checks Performed

- ✓ Port conflicts (vs current allocations)
- ✓ IP address conflicts (192.168.1.XXX/24)
- ✓ Volume path existence
- ✓ Docker Compose syntax validation
- ✓ Resource allocation (memory/CPU limits)
- ✓ Network configuration issues
- ✓ Dependency validation

#### Known Allocations

**ProxMoxBox (192.168.1.XXX)**:
- 3000 (Dockhand), 3001 (Uptime Kuma), 3030 (Grafana)
- 3100 (Homebox), 3101 (Loki), 4000 (Homepage)
- 8081 (cAdvisor), 9090 (Prometheus), 9093 (Alertmanager), 9100 (Node Exporter)
- 25565 (Minecraft Java), 19132/udp (Minecraft Bedrock)
- 80, 443, 81 (NPM)

**Pi5 (192.168.1.XXX)**:
- 53 (Pi-hole DNS), 8080 (Pi-hole Web), 9100 (Node Exporter), 9925 (Mealie)

#### Example Usage

```bash
# Validate new stack before deployment
"Use infra-validator to check my new jellyfin stack for conflicts"

# Pre-commit validation
"Validate changes with infra-validator before committing"
```

#### Output Format

- **Critical Issues** (deployment blocked) - Port conflicts, syntax errors
- **High Priority** (review before deploy) - Missing volume paths, high memory usage
- **Medium Priority** (notices) - Network binding, image tags
- **Resource Summary** - Projected total allocation after deployment

---

### 3. Documentation Sync

**File**: `~/.claude/agents/doc-sync.md`
**Model**: Haiku (fast, cost-effective)
**Purpose**: Keep Obsidian vault synchronized with infrastructure state

#### Checks Performed

- ✓ Missing service documentation pages
- ✓ Outdated port references
- ✓ Outdated IP addresses
- ✓ Broken WikiLinks (`[[Internal Links]]`)
- ✓ Missing README files in stacks
- ✓ Stale change dates (docs vs actual code)

#### Mapping Logic

```
homelab-ops/proxmox/dockhand/ → HomeLab/Services/Dockhand.md
homelab-ops/proxmox/monitoring/ → HomeLab/Services/Grafana.md
homelab-ops/pi5/mealie/ → HomeLab/Services/Mealie.md
```

#### Example Usage

```bash
# After adding new service
"Use doc-sync to check what documentation needs updating after adding Jellyfin"

# Monthly documentation audit
"Use doc-sync to find outdated documentation and broken links"
```

#### Output Format

- **Missing Documentation** (create these pages) - Services without docs
- **Outdated References** (fix these) - Wrong ports, IPs, URLs
- **Broken Links** (repair these) - WikiLinks that don't resolve
- **Stale Documentation** (review/update) - Docs older than stack changes
- **Missing READMEs** - Stacks without deployment instructions

---

### 4. Deployment Helper

**File**: `~/.claude/agents/deploy-helper.md`
**Model**: Haiku (fast, cost-effective)
**Purpose**: Validate Docker Compose files against homelab conventions

#### Conventions Enforced

| Convention | Required Value | Why |
|------------|---------------|-----|
| Restart policy | `unless-stopped` | Survives reboots, allows manual stops |
| Security options | `no-new-privileges:true` | Prevents privilege escalation |
| Memory limits | Must define | Prevents OOM scenarios |
| Environment variables | No default fallbacks | Fail-secure design |
| Volume mounts | Local paths preferred | Easy to find for backups |
| Docker socket | Must be `:ro` if used | Prevents container escape |
| Image tags | Specific versions preferred | Reproducible deployments |
| Health checks | Recommended | Smart orchestration |
| Network binding | Review 0.0.0.0 binds | Reduce attack surface |
| Service naming | Lowercase, hyphens | Docker DNS compatibility |

#### Example Usage

```bash
# Validate before committing
"Use deploy-helper to validate proxmox/monitoring/docker-compose.yaml"

# Pre-deployment check
"Validate this compose file with deploy-helper before deployment"
```

#### Output Format

- **Required Fixes** (must address) - Missing restart policies, memory limits
- **Security Issues** (before production) - Default passwords, socket access
- **Best Practice Recommendations** (optional) - Image pinning, health checks
- **Compliant Configurations** - What's already correct
- **Suggested Fixes** - Code snippets to apply

---

## Workflow Examples

### New Service Deployment

```bash
# Step 1: Create docker-compose.yaml

# Step 2: Validate in parallel
"Review proxmox/jellyfin/ with security-reviewer, infra-validator, and deploy-helper in parallel"

# Step 3: Fix issues, then deploy
cd ~/homelab-ops/proxmox/jellyfin && docker-compose up -d

# Step 4: Update documentation
"Use doc-sync to find what documentation needs creating"
```

### Security Audit (All Stacks)

```bash
# Audit all ProxMoxBox stacks in parallel
"Use security-reviewer to audit proxmox/dockhand, proxmox/monitoring, proxmox/homepage, and proxmox/minecraft in parallel"
```

### Pre-Commit Validation

```bash
# Before git commit
"Run deploy-helper and security-reviewer on modified compose files in parallel"
```

### Documentation Maintenance

```bash
# Monthly check
"Use doc-sync to find outdated documentation and broken links"
```

---

## Agent Configuration

Each agent file uses YAML frontmatter:

```yaml
---
name: agent-name
description: When to use this agent with examples
model: sonnet | haiku | opus
subagent_type: general-purpose
---

[Agent prompt with specific instructions]
```

### Model Selection Guide

| Model | Best For | Cost/Speed |
|-------|----------|------------|
| `haiku` | Pattern matching, repetitive checks | Fast, cheap |
| `sonnet` | Analysis, security reviews, validation | Balanced |
| `opus` | Complex architecture, major migrations | Thorough, slower |

---

## Context Files

Agents reference these files for homelab state:

| File | Contains |
|------|----------|
| `~/.claude/CLAUDE.md` | Global preferences, core directives |
| `~/homelab-ops/CLAUDE.md` | Port allocations, IP topology, resource limits |
| `~/Documents/HomeLab/HomeLab/_Index.md` | Documentation structure |

---

## Backup Strategy

**Primary Location**: `~/.claude/agents/`
**Backup Location**: `~/ai-assistant-config/agents/`
**Version Control**: Git repository (github.com:jhathcock-sys/ai-assistant-config.git)

**Backup Files**:
- `security-reviewer.md` (7.2 KB)
- `infra-validator.md` (8.7 KB)
- `doc-sync.md` (8.5 KB)
- `deploy-helper.md` (9.9 KB)
- `README.md` (4.9 KB)

**Backup Schedule**: After any agent modification

---

## Core Directives Integration

Agents follow global directives from `~/.claude/CLAUDE.md`:

1. **Idempotency** - Check state before changes
2. **Security First** - Least privilege, no chmod 777, UFW rules
3. **Network Awareness** - 192.168.1.XXX/24 topology, check IPs
4. **Documentation** - Educational comments in all output
5. **Docker Compose Only** - Never suggest docker run commands

---

## Future Enhancements

### Planned Agents

- **Backup Validator** - Verify backup jobs, test restore procedures
- **Certificate Manager** - Track SSL certificate expiration
- **Log Analyzer** - Parse Loki logs for patterns, anomalies
- **Performance Profiler** - Identify resource bottlenecks

### Feature Ideas

- Agent chaining (output of one feeds into another)
- Scheduled agent runs (cron-based audits)
- Dashboard integration (display agent results in Homepage)
- Slack/Discord notifications for critical findings

---

## Troubleshooting

### Agent Not Found

```bash
# Verify agent files exist
ls ~/.claude/agents/

# Check agent file format (YAML frontmatter required)
head -n 10 ~/.claude/agents/security-reviewer.md
```

### Permission Denied

Agents running in background may encounter permission issues:
- Check `~/.claude/settings.internal.json` for SSH/SCP permissions
- Verify file paths are accessible to agent execution context

### Agent Timeout

Long-running agents may timeout:
- Use `run_in_background: true` for extended operations
- Monitor progress with `tail -f /tmp/claude-*/*.output`
- Increase timeout parameter if needed

---

## Related Documentation

- [[Claude-Memory-System]] - Global memory configuration
- [[Security-Hardening]] - Manual security review process
- [[GitOps-Workflow]] - Infrastructure as Code workflow
- [[Monitoring-Stack-Security-Audit]] - First security review results

---

**Maintainer**: James Hathcock
**Created**: 2026-02-04
**Last Updated**: 2026-02-04

---

*"Automation without documentation is just magic. Make it reproducible."*
