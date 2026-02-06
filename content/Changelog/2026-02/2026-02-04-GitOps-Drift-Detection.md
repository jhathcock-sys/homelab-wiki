# GitOps Drift Detection - February 4, 2026

## Summary

Created automated drift detection script to validate infrastructure matches the GitOps repository.

---

## Problem Statement

**Challenge:** Manual drift detection between deployed containers and repository
- Infrastructure could drift from Git repository over time
- No automated way to catch containers deployed without compose files
- Missing compose files for deployed services could go unnoticed
- Manual audits were time-consuming and error-prone

**Impact:**
- GitOps benefits reduced when repository doesn't match reality
- Harder to rebuild infrastructure from repository
- Documentation becomes inaccurate

---

## Solution

### Created `scripts/drift-detection.sh`

**Location:** `/home/cib/homelab-ops/scripts/drift-detection.sh`

**Features:**
- Compares running containers against repository compose files
- Checks both ProxMoxBox and Pi5 servers
- Excludes `proxmox/pi5-stacks/` (Hawser remote management directory)
- Color-coded output for easy reading
- Exit code reflects number of issues (0 = clean, CI/CD friendly)

**Checks Performed:**
1. **Running containers not in repo** - Containers deployed without compose files
2. **Repo containers not running** - Compose files for non-existent containers

---

## Implementation

### Script Architecture

```bash
# Core functions:
get_running_containers()     # SSH to servers, get docker ps output
get_repo_containers()         # Parse compose files for container names
find_stack_for_container()   # Map container to its stack directory
```

### Key Design Decisions

**Container Name Extraction:**
- Parse `container_name:` fields from compose files
- Match against actual running container names from `docker ps`
- Avoids service name vs container name confusion

**Path Exclusion:**
- Exclude `proxmox/pi5-stacks/` when checking ProxMoxBox
- Prevents false positives for Hawser-managed remote stacks
- Pi5 stacks are checked separately against `pi5/` directory

**Error Handling:**
- `set -e` for fail-fast behavior
- Exit code = number of drift issues found
- Suitable for CI/CD pipeline integration

---

## Results

### Initial Run - Found Issues

**First execution revealed:**
1. ✗ `nginx-proxy-manager` - Compose file in repo but not running
   - **Cause:** NPM runs as LXC container (192.168.1.XXX), not Docker
   - **Action:** Removed from repository (not applicable to Docker stack)

### After Cleanup - Clean Infrastructure

```
✓ No drift detected!
  Infrastructure matches repository.

ProxMoxBox: 14 containers ✓
Pi5: 7 containers ✓
Total: 21 containers validated
```

---

## Repository Cleanup

### Removed: `proxmox/nginx-proxy-manager/`

**Reason:**
- Nginx Proxy Manager runs as **LXC container** on Proxmox host
- Not managed via Docker Compose
- Compose file was outdated reference, never deployed
- Keeping it caused false drift detection

**Alternative Management:**
- NPM managed directly via Proxmox LXC
- Available at 192.168.1.XXX
- Configuration separate from Docker infrastructure

---

## Additional Work

### Synced Pi5 Stacks to Hawser Directory

**Added to `proxmox/pi5-stacks/` for Dockhand remote management:**
- `mealie/` - Recipe and meal planning manager
- `node-exporter/` - System metrics for Prometheus
- `obsidian-livesync/` - CouchDB vault synchronization

**Deployed to ProxMoxBox:**
- Copied stacks to `/opt/pi5-stacks/` on ProxMoxBox
- Dockhand can now see and manage all 6 Pi5 stacks remotely via Hawser

**All Pi5 Stacks Available:**
1. infra (pihole, tailscale)
2. mealie
3. nebula-sync
4. node-exporter
5. obsidian-livesync
6. promtail

---

## Usage

### Run Drift Detection

```bash
cd ~/homelab-ops
./scripts/drift-detection.sh
```

### Example Output

```
========================================
  GitOps Drift Detection
========================================

→ Checking ProxMoxBox (192.168.1.XXX)...

[ProxMoxBox] Containers running but not in repo:
  ✓ All running containers are in repository

[ProxMoxBox] Containers in repo but not running:
  ✓ All repository containers are running

→ Checking Pi5 (192.168.1.XXX)...

[Pi5] Containers running but not in repo:
  ✓ All running containers are in repository

[Pi5] Containers in repo but not running:
  ✓ All repository containers are running

========================================
✓ No drift detected!
  Infrastructure matches repository.
========================================
```

---

## Benefits

### Automated Validation
- Run anytime to verify infrastructure state
- Catch drift immediately instead of during incidents
- Validate new deployments match repository

### GitOps Confidence
- Repository is single source of truth
- Can rebuild infrastructure from repo with confidence
- Documentation stays accurate

### CI/CD Ready
- Exit code indicates pass/fail status
- Can integrate into automated pipelines
- Scheduled cron jobs for periodic checks

### Operational Insight
- Quick infrastructure inventory
- Identifies orphaned containers
- Finds missing compose files

---

## Future Enhancements

### Potential Improvements

**Configuration Drift:**
- Compare running container config vs compose file (env vars, volumes, ports)
- Detect memory limit changes
- Flag restart policy differences

**Automated Remediation:**
- Option to auto-deploy missing containers
- Option to remove orphaned containers
- Generate Pull Requests for missing compose files

**Reporting:**
- HTML/JSON output format
- Email notifications on drift detection
- Slack/Discord integration for alerts

**Extended Checks:**
- Validate network configurations
- Check volume mounts exist
- Verify image tags match

---

## Lessons Learned

### Design Insights

**Container Names vs Service Names:**
- Initially parsed service names, caused mismatches
- Switched to parsing `container_name:` fields
- Must match what `docker ps` actually returns

**Path Exclusions Matter:**
- pi5-stacks directory caused false positives
- Needed exclusion logic to prevent duplicate checks
- Important to understand Hawser's remote management pattern

**Exit Codes for Automation:**
- Return count of issues as exit code
- Enables CI/CD integration
- Zero exit = infrastructure clean

### Operational Learnings

**LXC vs Docker Separation:**
- Keep LXC container configs separate from Docker repo
- Different management patterns require different tools
- Mixing them creates confusion and false positives

**Regular Validation:**
- Drift happens gradually over time
- Regular runs catch issues before they compound
- Better to catch drift during maintenance than incidents

---

## Related Documentation

- [[GitOps-Workflow]] - Infrastructure as Code workflow
- [[Dockhand]] - Docker management with Hawser remote agent
- [[Current-TODO]] - Updated to mark task complete

---

## Commits

**homelab-ops:**
- `ba4061e` - Add GitOps drift detection and cleanup nginx-proxy-manager
- `cdc75f4` - Add missing Pi5 stacks to proxmox/pi5-stacks for Hawser management

**homelab-docs:**
- `324d727` - Mark GitOps drift detection as completed

---

**Date:** 2026-02-04
**Status:** ✅ Complete
**Infrastructure:** ProxMoxBox + Pi5 (21 containers validated clean)
