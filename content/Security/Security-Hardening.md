# Security Hardening

[[_Index|← Back to Index]]

---

## Overview

Security audit identified critical vulnerabilities in Docker configurations. The following hardening was applied to reduce container escape and privilege escalation risks.

**Date:** 2026-02-03

---

## Changes Applied

| Service | Issue | Fix |
|---------|-------|-----|
| **cAdvisor** | `privileged: true` grants full host access | Replaced with `cap_add: SYS_PTRACE` + `security_opt: no-new-privileges:true` |
| **[[Grafana]]** | Default password fallback `:-admin` | Removed fallback - requires explicit `GRAFANA_PASSWORD` in `.env` |
| **Uptime Kuma** | Docker socket without read-only | Added `:ro` flag to `/var/run/docker.sock` mount |
| **[[Dockhand]]** | Docker socket without read-only | Added `:ro` flag to `/var/run/docker.sock` mount |

---

## Why These Matter

### Docker Socket Exposure (`/var/run/docker.sock`)
- Full Docker API access = root equivalent on host
- Can spawn privileged containers, read all secrets
- **Mitigation:** `:ro` flag limits to read-only operations

### Privileged Mode (`privileged: true`)
- Disables all container isolation
- Full access to host devices, kernel capabilities
- **Mitigation:** Use specific capabilities instead (SYS_PTRACE for process metrics)

### Default Credentials
- Fallback passwords create security holes if `.env` is misconfigured
- **Mitigation:** Remove fallbacks, fail explicitly if not configured

---

## Additional Security Improvements (2026-02-04)

| Service | Issue | Fix |
|---------|-------|-----|
| **cAdvisor** | `/dev/kmsg` device mount | Removed (not essential, causes startup errors) |
| **[[Minecraft-Server]]** | Over-allocated JVM heap (6G) | Reduced to 4G for better resource sharing |

---

## Remaining Recommendations (Future)

| Priority | Item |
|----------|------|
| HIGH | Pin container images to specific versions (currently using `:latest`) |
| MEDIUM | Add memory/CPU limits to all services - ✅ **COMPLETED 2026-02-04** |
| MEDIUM | Add health checks to critical services |
| LOW | Add `security_opt: no-new-privileges:true` to all containers |
| LOW | Create isolated Docker networks for service tiers |

---

## Commit References

- **Security hardening:** `d403912` - Fix critical container vulnerabilities (2026-02-03)
- **Container resources:** `e266a08`, `e301826` - Memory limits across all services (2026-02-04)

---

## Security+ Tie-ins

These changes demonstrate:
- **Least Privilege** (SYS_PTRACE instead of privileged mode)
- **Defense in Depth** (read-only mounts + no default passwords)
- **Attack Surface Reduction** (removed unnecessary device mounts)
- **Resource Controls** (memory limits prevent DoS via resource exhaustion)

---

## Related Pages

- [[Best-Practices]]
- [[_Monitoring-Stack|Monitoring Stack]]
- [[Changelog/2026-02/2026-02-04-Container-Resources|Container Resource Management]]
