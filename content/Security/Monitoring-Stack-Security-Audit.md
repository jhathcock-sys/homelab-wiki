# Monitoring Stack Security Audit

**Date**: 2026-02-04
**Stack**: proxmox/monitoring/
**Auditor**: security-reviewer agent (Claude Sonnet 4.5)
**Baseline**: Commit d403912 security hardening

---

## Executive Summary

**Overall Risk**: ⚠️ MEDIUM
**Compliance Status**: Partially hardened - needs additional improvements
**Services Audited**: 9 containers (Prometheus, Grafana, Loki, Alertmanager, etc.)

### Key Findings

- ✅ Previous security hardening (commit d403912) properly applied
- ❌ Missing `.env` file required for deployment
- ⚠️ All services using `:latest` tags (supply chain risk)
- ⚠️ 7 services missing `security_opt: no-new-privileges:true`
- ⚠️ 8 ports exposed to 0.0.0.0 without firewall rules

---

## What's Already Secured ✓

The February 3rd security hardening was successfully validated:

| Control | Status | Details |
|---------|--------|---------|
| Privileged mode | ✅ None | No containers use `privileged: true` |
| Capabilities | ✅ Minimal | cAdvisor uses only `SYS_PTRACE` |
| Default passwords | ✅ Removed | Grafana requires explicit `GRAFANA_PASSWORD` |
| Docker socket | ✅ None | Monitoring services don't mount docker.sock |
| Secrets management | ✅ Proper | All secrets via `.env` (gitignored) |
| Resource limits | ✅ Applied | All 8 services have memory/CPU limits |
| Restart policy | ✅ Configured | All use `restart: unless-stopped` |

---

## Critical Issues ❌

### 1. Missing .env File

**Risk**: Stack will fail to start
**Impact**: CRITICAL - deployment blocked

**Required Variables**:
```bash
GRAFANA_PASSWORD=<secure-password>
DISCORD_WEBHOOK=<webhook-url>
```

**Remediation**:
```bash
cd /home/cib/homelab-ops/proxmox/monitoring
cp .env.example .env

# Generate secure password
SECURE_PASSWORD=$(openssl rand -base64 32 | head -c 32)
echo "Generated password: [REDACTED]

# Edit .env and set:
# - GRAFANA_PASSWORD to generated value
# - DISCORD_WEBHOOK to your Discord webhook URL
nano .env
```

**Security Note**: The stack correctly refuses to use default password fallbacks. This fail-secure design prevents accidental deployment with weak credentials.

---

## High Priority Recommendations ⚠️

### 2. Image Tag Pinning

**Risk**: Supply chain attacks, breaking changes, unpredictable updates
**Severity**: MEDIUM
**Services Affected**: All 9 containers

**Current State**: All services use `:latest` tag

**Recommended Versions**:
```yaml
# Check current running versions first:
# docker images | grep -E "(prometheus|grafana|loki)"

services:
  prometheus:
    image: prom/prometheus:v2.49.1  # Change from :latest

  alertmanager:
    image: prom/alertmanager:v0.26.0

  alertmanager-discord:
    image: benjojo/alertmanager-discord:latest  # No versioning - acceptable

  loki:
    image: grafana/loki:2.9.4

  promtail:
    image: grafana/promtail:2.9.4

  grafana:
    image: grafana/grafana:10.2.3

  node-exporter:
    image: prom/node-exporter:v1.7.0

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.49.1

  snmp-exporter:
    image: prom/snmp-exporter:v0.26.0
```

**Security+ Context**: Version pinning prevents supply chain attacks (like SolarWinds breach). Controls when updates are introduced and enables easy rollback.

---

### 3. Security Options Missing

**Risk**: Privilege escalation via setuid/setgid binaries
**Severity**: MEDIUM
**Services Affected**: 7 containers (all except cAdvisor)

**Required Fix** - Add to each service:
```yaml
prometheus:
  image: prom/prometheus:v2.49.1
  security_opt:
    - no-new-privileges:true
  # ... rest of config
```

**Services Needing Update**:
- prometheus
- alertmanager
- alertmanager-discord
- loki
- promtail
- grafana
- node-exporter
- snmp-exporter

**Note**: cAdvisor already has this configured (line 165-166 of docker-compose.yaml)

**Security+ Context**: This flag prevents processes from gaining additional privileges through setuid/setgid executables. Blocks common container escape vectors by preventing privilege escalation inside the container.

---

### 4. Network Exposure - UFW Firewall Rules Required

**Risk**: Services accessible from any network interface
**Severity**: MEDIUM
**Services Affected**: 8 ports bound to 0.0.0.0

#### Current Exposure

| Service | Port | Purpose | Risk Level |
|---------|------|---------|------------|
| Prometheus | 9090 | Metrics database | Medium |
| Alertmanager | 9093 | Alert management | Medium |
| Loki | 3101 | Log aggregation | Medium |
| Promtail | 1514 | Syslog receiver | Medium |
| Grafana | 3030 | Dashboard UI | Medium |
| Node Exporter | 9100 | System metrics | Medium |
| cAdvisor | 8081 | Container metrics | Medium |
| SNMP Exporter | 9116 | SNMP translation | Low |

#### UFW Firewall Script

**Location**: `/home/cib/homelab-ops/proxmox/monitoring/ufw-rules.sh`

```bash
#!/bin/bash
# UFW Firewall Rules for Monitoring Stack
# Purpose: Restrict monitoring services to LAN-only access

set -euo pipefail

echo "🔒 Configuring UFW rules for Monitoring Stack..."

# Allow from LAN (192.168.1.XXX/24) only
sudo ufw allow from 192.168.1.XXX/24 to any port 9090 proto tcp comment 'Prometheus - LAN only'
sudo ufw allow from 192.168.1.XXX/24 to any port 9093 proto tcp comment 'Alertmanager - LAN only'
sudo ufw allow from 192.168.1.XXX/24 to any port 3101 proto tcp comment 'Loki - LAN only'
sudo ufw allow from 192.168.1.XXX/24 to any port 1514 proto tcp comment 'Promtail Syslog - LAN only'
sudo ufw allow from 192.168.1.XXX/24 to any port 3030 proto tcp comment 'Grafana - LAN only'
sudo ufw allow from 192.168.1.XXX/24 to any port 9100 proto tcp comment 'Node Exporter - LAN only'
sudo ufw allow from 192.168.1.XXX/24 to any port 8081 proto tcp comment 'cAdvisor - LAN only'
sudo ufw allow from 192.168.1.XXX/24 to any port 9116 proto tcp comment 'SNMP Exporter - LAN only'

# Explicit deny from all other sources (defense in depth)
sudo ufw deny 9090/tcp comment 'Block Prometheus from internet'
sudo ufw deny 9093/tcp comment 'Block Alertmanager from internet'
sudo ufw deny 3101/tcp comment 'Block Loki from internet'
sudo ufw deny 1514/tcp comment 'Block Promtail from internet'
sudo ufw deny 3030/tcp comment 'Block Grafana from internet'
sudo ufw deny 9100/tcp comment 'Block Node Exporter from internet'
sudo ufw deny 8081/tcp comment 'Block cAdvisor from internet'
sudo ufw deny 9116/tcp comment 'Block SNMP Exporter from internet'

echo "✓ UFW rules applied"
echo ""
echo "Verify with:"
echo "  sudo ufw status numbered"
echo ""
echo "Note: UFW rules are evaluated top-to-bottom."
echo "LAN allow rules take precedence over deny rules below them."
```

**Deployment**:
```bash
chmod +x /home/cib/homelab-ops/proxmox/monitoring/ufw-rules.sh
sudo ./ufw-rules.sh
sudo ufw status numbered  # Verify rules applied
```

**Security+ Context**: Defense in depth requires multiple security layers. Even on a trusted LAN, firewall rules provide:
- Network segmentation (explicit allow/deny policies)
- Audit trail (UFW logs connection attempts)
- WAN protection (blocks if port forwarding accidentally enabled)
- Defense against compromised LAN devices (limits lateral movement)

---

## Low Priority Observations ℹ️

### 5. Extensive Host Filesystem Mounts (Acceptable)

**Services**: node-exporter, cAdvisor, promtail
**Mounts**: `/proc`, `/sys`, `/var/log`, `/var/lib/docker`, `/` (rootfs)
**Status**: ✓ **Acceptable** - Required for monitoring functionality

**Security Context**: All mounts are read-only (`:ro` flag). This is industry-standard configuration for Prometheus exporters. Monitoring tools require host system access for metrics collection.

**No action required** ✓

---

### 6. No Container User Specification (Acceptable)

**Status**: ⚠️ Informational
**Risk Level**: Low

Official Prometheus images already run as non-root:
- `prom/prometheus` → UID 65534 (nobody)
- `grafana/grafana` → UID 472 (grafana)
- `prom/node-exporter` → UID 65534 (nobody)

**No action required** ✓

---

### 7. No Read-Only Root Filesystem (Acceptable)

**Status**: ⚠️ Informational
**Risk Level**: Low

These services require write access:
- Prometheus: TSDB writes
- Grafana: SQLite database, session storage
- Loki: Log index and chunks
- Alertmanager: Notification state

**No action required** ✓

---

## Risk Assessment by Service

| Service | Image Pin | Security Opt | Resources | Network | Overall |
|---------|-----------|--------------|-----------|---------|---------|
| Prometheus | ⚠️ :latest | ⚠️ Missing | ✅ 768M | ⚠️ 9090 | **Medium** |
| Alertmanager | ⚠️ :latest | ⚠️ Missing | ✅ 128M | ⚠️ 9093 | **Medium** |
| Discord Bridge | ⚠️ :latest | ⚠️ Missing | ✅ 64M | ✅ Internal | **Medium** |
| Loki | ⚠️ :latest | ⚠️ Missing | ✅ 512M | ⚠️ 3101 | **Medium** |
| Promtail | ⚠️ :latest | ⚠️ Missing | ✅ 128M | ⚠️ 1514 | **Medium** |
| Grafana | ⚠️ :latest | ⚠️ Missing | ✅ 512M | ⚠️ 3030 | **Medium** |
| Node Exporter | ⚠️ :latest | ⚠️ Missing | ✅ 64M | ⚠️ 9100 | **Medium** |
| cAdvisor | ⚠️ :latest | ✅ **Done** | ✅ 512M | ⚠️ 8081 | **Low** |
| SNMP Exporter | ⚠️ :latest | ⚠️ Missing | ✅ 128M | ⚠️ 9116 | **Low** |

---

## Action Plan

### Priority 1 (Before Next Deployment)
- [ ] Create `.env` file with secure credentials
- [ ] Apply UFW firewall rules
- [ ] Test stack deployment

### Priority 2 (Next Maintenance Window)
- [ ] Pin all container images to specific versions
- [ ] Add `security_opt: no-new-privileges:true` to 7 services
- [ ] Redeploy and verify

### Priority 3 (Future Enhancements)
- [ ] Consider SHA256 digest pinning for critical services
- [ ] Implement health checks for critical services
- [ ] Evaluate isolated Docker networks for service tiers

---

## Security+ Exam Topics Covered

This audit demonstrates understanding of:

### 1. Attack Frameworks (Privilege Escalation)
- Removed `privileged: true` mode
- Using `no-new-privileges:true` to prevent setuid exploitation
- Least-privilege principle with capabilities

### 2. Configuration Management
- Image version pinning for reproducible deployments
- Secrets management via environment variables
- Fail-secure design (no default passwords)

### 3. Network Security (Defense in Depth)
- Multiple security layers (UFW + container isolation)
- Network segmentation via firewall rules
- Attack surface reduction (limit exposed ports)

### 4. CIA Triad - Availability
- Resource limits prevent DoS attacks
- Memory/CPU controls ensure service availability

### 5. Supply Chain Security
- Container image provenance (official registries)
- Version pinning prevents malicious updates
- Digest pinning (future enhancement)

---

## Real-World Attack Scenario

**If an attacker compromises your Grafana instance** (e.g., through a plugin vulnerability), these controls limit their options:

- ❌ Can't escape to host (no privileged mode)
- ❌ Can't gain root inside container (no-new-privileges)
- ❌ Can't exhaust server memory (resource limits)
- ❌ Lateral movement limited by UFW rules

**This is defense in depth in action.**

---

## References

- [[Security-Hardening]] - Previous hardening work (commit d403912)
- [[_Monitoring-Stack]] - Stack overview
- [[Best-Practices]] - Security best practices
- [[Grafana]] - Grafana service documentation
- [[Prometheus]] - Prometheus service documentation

---

**Next Review**: After implementing Priority 2 recommendations
**Related Work**: [[Security-Hardening]] · [[Wazuh-SIEM]]

---

*Audit completed: 2026-02-04*
*Auditor: security-reviewer agent (Claude Sonnet 4.5)*
