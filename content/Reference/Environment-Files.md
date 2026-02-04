# Environment Files

[[_Index|← Back to Index]]

---

## Overview

Environment files (`.env`) store sensitive configuration like passwords and API keys. They should never be committed to Git.

**Security:** Always set file permissions to 600 (owner read/write only):
```bash
chmod 600 /opt/<stack>/.env
```

---

## ProxMoxBox Environment Files

### `/opt/homelab-tools/.env`
```bash
SECRET_ENCRYPTION_KEY=<your-key-here>
```

### `/opt/monitoring/.env`
```bash
GRAFANA_PASSWORD=<your-password>
DISCORD_WEBHOOK=<your-webhook-url>
```

---

## Pi5 Environment Files

### `/opt/pi5-stacks/infra/.env.example`
```bash
PIHOLE_PASSWORD=your_password_here
TS_AUTHKEY=tskey-auth-xxxxx
```

### `/opt/pi5-stacks/nebula-sync/.env.example`
```bash
NEBULA_PRIMARY=http://192.168.1.XXX|your_password
NEBULA_REPLICAS=http://192.168.1.XXX:8080|your_password
```

---

## NAS Credentials

### `/root/.smbcredentials` (Proxmox host and Pi5)
```bash
username=HomeLab
password=<your-password>
```

**Security:** Must be mode 600:
```bash
chmod 600 /root/.smbcredentials
```

---

## Best Practices

1. **Never commit `.env` files to Git** - Add to `.gitignore`
2. **Use `.env.example` templates** - Document required variables without values
3. **Set restrictive permissions** - `chmod 600` for all env files
4. **Backup securely** - Encrypted backup only (not in plain Git repos)
5. **Rotate credentials** - Change passwords periodically

---

## Related Pages

- [[Security-Hardening]]
- [[Best-Practices]]
- [[GitOps-Workflow]]
