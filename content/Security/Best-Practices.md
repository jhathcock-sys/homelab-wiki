# Security Best Practices

[[_Index|← Back to Index]]

---

## Docker Security

### Container Isolation

- **Never use `privileged: true`** - Use specific capabilities instead
- **Read-only Docker socket** - Always add `:ro` to `/var/run/docker.sock` mounts
- **No new privileges** - Add `security_opt: no-new-privileges:true` to containers
- **Resource limits** - Set memory/CPU limits to prevent DoS

### Secrets Management

- **Never hardcode credentials** - Use `.env` files (gitignored)
- **No default fallbacks** - Fail explicitly if secrets not configured
- **File permissions** - Set `.env` files to mode 600 (owner read/write only)

### Image Management

- **Pin versions** - Use specific tags instead of `:latest`
- **Regular updates** - Keep images updated for security patches
- **Minimal images** - Prefer Alpine or distroless base images

---

## Network Security

### Firewall Rules (UFW)

```bash
# Default deny incoming
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow 22/tcp

# Allow specific service ports from local network only
sudo ufw allow from 192.168.1.XXX/24 to any port 3000 comment "Dockhand"
sudo ufw allow from 192.168.1.XXX/24 to any port 4000 comment "Homepage"
```

### Network Segmentation

**Future:** Implement VLANs with [[Future-Plans|OPNsense]]
- Management VLAN (192.168.10.0/24)
- Server VLAN (192.168.20.0/24)
- IoT VLAN (192.168.30.0/24)
- Guest VLAN (192.168.40.0/24)

---

## Access Control

### SSH Hardening

```bash
# Use key-based authentication only
PermitRootLogin prohibit-password
PasswordAuthentication no
PubkeyAuthentication yes

# Use Ed25519 keys
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### Service Accounts

- **Principle of Least Privilege** - Services run as non-root when possible
- **Unique credentials** - Each service has its own credentials
- **Password complexity** - Use strong, randomly generated passwords

---

## Monitoring & Logging

### What to Monitor

- **Failed login attempts** - Auth logs via [[Loki]]
- **Resource usage** - [[Prometheus]] alerts for high CPU/memory/disk
- **Container restarts** - May indicate crashes or attacks
- **Network traffic** - Unusual patterns via [[Future-Plans|Suricata IDS]]

### SIEM Integration

- **[[Wazuh-SIEM]]** - Agents on all critical hosts
- **Log retention** - 30 days minimum for incident investigation
- **Alert tuning** - Balance sensitivity vs false positives

---

## Backup & Recovery

### What to Backup

- **Docker volumes** - Application data
- **Compose files** - Infrastructure as Code (already in [[GitOps-Workflow|Git]])
- **Configuration files** - `/opt/<stack>/` directories
- **Environment files** - `.env` files (encrypted backup only)

### Backup Strategy

- **3-2-1 Rule** - 3 copies, 2 different media, 1 offsite
- **Test restores** - Verify backups work before you need them
- **[[NAS-Synology|NAS storage]]** - Centralized backup location

---

## Compliance Considerations

### Security+ Domains

- **1.0 Threats, Attacks, Vulnerabilities** - SIEM monitoring
- **2.0 Architecture & Design** - Network segmentation, least privilege
- **3.0 Implementation** - Hardened configurations
- **4.0 Operations & Incident Response** - Logging, alerting
- **5.0 Governance, Risk, Compliance** - Documentation, policies

---

## OWASP Top 10 (Container Edition)

1. **Insecure Images** - Pin versions, scan for vulnerabilities
2. **Secrets in Images** - Use environment variables, not baked-in secrets
3. **Privileged Containers** - Use capabilities instead
4. **Exposed Docker Socket** - Read-only mounts, consider alternatives
5. **Resource Exhaustion** - Set limits on all containers
6. **Network Exposure** - Isolate containers, use firewalls
7. **Outdated Components** - Regular updates and patching
8. **Insufficient Logging** - Centralized logging (Loki)
9. **Insecure Defaults** - Harden configurations
10. **Supply Chain Attacks** - Verify image sources

---

## Related Pages

- [[Security-Hardening]]
- [[Wazuh-SIEM]]
- [[_Monitoring-Stack]]
- [[GitOps-Workflow]]
