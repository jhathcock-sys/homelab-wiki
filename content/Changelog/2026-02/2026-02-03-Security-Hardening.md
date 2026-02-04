# Security Hardening (2026-02-03)

[[_Changelog-Index|← Back to Changelog]]

---

## Overview

Security audit identified critical vulnerabilities in Docker configurations. Applied hardening to reduce container escape and privilege escalation risks.

---

## Changes Applied

### 1. cAdvisor - Removed Privileged Mode

**Issue:** `privileged: true` grants full host access
- Disables all container isolation
- Full access to host devices and kernel capabilities
- Major security risk

**Fix:** Replaced with specific capability
```yaml
# Before
privileged: true

# After
cap_add:
  - SYS_PTRACE
security_opt:
  - no-new-privileges:true
```

**Why:** `SYS_PTRACE` provides only the capability needed for process metrics, not full root access.

---

### 2. Grafana - Removed Default Password Fallback

**Issue:** Default password fallback `:-admin` creates security hole
- If `.env` misconfigured, falls back to weak default
- Predictable credentials in production

**Fix:** Removed fallback
```yaml
# Before
- GF_SECURITY_ADMIN_PASSWORD=[REDACTED]

# After
- GF_SECURITY_ADMIN_PASSWORD=[REDACTED]
```

**Why:** Fail explicitly if not configured, forcing secure setup.

---

### 3. Docker Socket - Read-Only Mounts

**Issue:** Docker socket without read-only flag
- Full Docker API access = root equivalent on host
- Can spawn privileged containers, read all secrets

**Fix:** Added `:ro` flag
```yaml
# Before
- /var/run/docker.sock:/var/run/docker.sock

# After
- /var/run/docker.sock:/var/run/docker.sock:ro
```

**Applied to:**
- [[Dockhand]]
- Uptime Kuma

**Why:** Limits to read-only operations, prevents container spawning.

---

## Security Principles Demonstrated

### Least Privilege
- Use specific capabilities (`SYS_PTRACE`) instead of full privileges
- Read-only mounts where write access not needed

### Defense in Depth
- Multiple layers: socket restrictions + no default passwords
- Each mitigation reduces attack surface

### Fail Secure
- Remove default fallbacks
- Force explicit secure configuration

---

## Portfolio Documentation

Created comprehensive writeup with:
- Full methodology
- Before/after comparisons
- Security+ domain tie-ins
- Risk assessments

**Published:** https://jhathcock-sys.github.io/me/projects/security-review/
**Commit:** `6a26be2`

---

## GitOps Commit

**Commit:** `d403912` - Security hardening: Fix critical container vulnerabilities

**Files Modified:**
- `/opt/monitoring/docker-compose.yaml` (cAdvisor, Grafana)
- `/opt/uptimekuma/docker-compose.yaml` (docker.sock)
- `/opt/dockhand/docker-compose.yml` (docker.sock)

---

## Remaining Recommendations (Future)

| Priority | Item | Status |
|----------|------|--------|
| HIGH | Pin container images to specific versions | Backlog |
| MEDIUM | Add memory/CPU limits | ✅ **COMPLETED 2026-02-04** |
| MEDIUM | Add health checks to critical services | Backlog |
| LOW | Add `no-new-privileges` to all containers | Partial |
| LOW | Create isolated Docker networks | Backlog |

---

## Security+ Tie-ins

These changes map to Security+ domains:

### 1.0 Threats, Attacks, Vulnerabilities
- Container escape attacks
- Privilege escalation vectors

### 2.0 Architecture & Design
- Least privilege principle
- Defense in depth

### 3.0 Implementation
- Hardened configurations
- Secure defaults

### 4.0 Operations & Incident Response
- Attack surface reduction
- Security monitoring readiness

---

## Related Pages

- [[Security-Hardening]]
- [[Best-Practices]]
- [[_Monitoring-Stack]]
- [[Dockhand]]
- [[Grafana]]
- [[Portfolio-Site]]
