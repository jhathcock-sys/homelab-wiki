# Wazuh SIEM

[[_Index|← Back to Index]]

**IP:** [[Network-Topology|192.168.1.XXX]] | **VM:** Debian 12 (bookworm)

---

## Overview

Security Information and Event Management (SIEM) deployed on dedicated VM for centralized security monitoring across the homelab. Helps with Security+ certification studies.

---

## Access URLs

| Service | URL | Status |
|---------|-----|--------|
| **Dashboard** | https://192.168.1.XXX | Working |
| **Wazuh API** | http://192.168.1.XXX:55000 | Working |
| **Indexer API** | http://192.168.1.XXX:9200 | Working |
| **Agent Registration** | 192.168.1.XXX:1515 | Working |
| **Agent Communication** | 192.168.1.XXX:1514 | Working |

---

## Dashboard Credentials

- **Username:** `admin`
- **password: [REDACTED] `ddZtfWVFD+7IV64.6DJzKRBPa6wYvSbA`

---

## API Credentials

- **Admin:** `wazuh` / `15jMA*JM6vcrzAdLLL825GRFrDLBiTJ1`
- **Dashboard:** `wazuh-wui` / `P?E*n9bWeY?9uaDCVy81vlDSlHabBR.o`

---

## VM Specs

- **IP:** 192.168.1.XXX
- **Hostname:** Wazuh
- **OS:** Debian 12 (bookworm)
- **Version:** Wazuh v4.14.2
- **RAM:** 8GB
- **CPU:** 4 cores
- **Disk:** ~90GB

---

## Components Installed

- **wazuh-manager** - Core SIEM engine, processes security events
- **wazuh-indexer** - OpenSearch-based data storage
- **wazuh-dashboard** - Kibana-based web interface
- **filebeat** - Ships alerts from manager to indexer

---

## Agents Deployed

| ID | Name | Host | IP | Status |
|----|------|------|-----|--------|
| 000 | Wazuh (server) | localhost | - | Active/Local |
| 001 | SRV-DOCKER01 | ProxMoxBox | 192.168.1.XXX | Active |
| 002 | pi-infra | Pi5 | 192.168.1.XXX | Active |
| 003 | SRV-DNS01 | Pi-hole LXC | 192.168.1.XXX | Active |
| 004 | SRV-NPM01 | NPM LXC | 192.168.1.XXX | Active |

**Note:** [[NAS-Synology]] (192.168.1.XXX) - Wazuh agent skipped due to ARM64 incompatibility.

---

## Installation Notes

Rebuilt with Debian 12 (bookworm) - officially supported by Wazuh.

1. Ran official installer:
   ```bash
   curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh
   bash wazuh-install.sh -a
   ```
2. Upgraded to v4.14.2 to match agent versions
3. Re-registered agents on ProxMoxBox and Pi5
4. All components fully operational

---

## Agent Installation (for future hosts)

```bash
# Add Wazuh repo
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor -o /usr/share/keyrings/wazuh.gpg
echo 'deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main' > /etc/apt/sources.list.d/wazuh.list
apt update

# Install agent with manager IP
WAZUH_MANAGER='192.168.1.XXX' apt install -y wazuh-agent

# Start agent
systemctl daemon-reload && systemctl enable wazuh-agent && systemctl start wazuh-agent
```

---

## Management Commands

```bash
# SSH to Wazuh server
ssh root@192.168.1.XXX

# List all agents
/var/ossec/bin/agent_control -l

# Get agent info
/var/ossec/bin/agent_control -i <agent_id>

# Restart Wazuh manager
systemctl restart wazuh-manager
```

---

## Troubleshooting

### Static IP Issues (Fixed 2026-02-05)

**Issue:** VM randomly changed from static IP 192.168.1.XXX to DHCP-assigned 192.168.1.XXX, breaking agent connectivity.

**Root Cause:** `dhclient` process running in background, overriding static IP configuration in `/etc/network/interfaces`.

**Solution Implemented:**
1. Killed rogue dhclient process: `kill <pid>`
2. Disabled cloud-init network config:
   ```bash
   echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
   ```
3. Created systemd service to prevent dhclient at boot:
   ```bash
   # /etc/systemd/system/ensure-static-ip.service
   [Unit]
   Description=Ensure Static IP and Kill DHCP Client
   After=network-pre.target
   Before=network.target

   [Service]
   Type=oneshot
   ExecStart=/bin/bash -c 'killall dhclient 2>/dev/null || true'
   RemainAfterExit=yes

   [Install]
   WantedBy=multi-user.target
   ```
4. Enabled service: `systemctl enable ensure-static-ip.service`

**Preventive Measures:**
- Static IP configuration in `/etc/network/interfaces` remains unchanged
- Added DHCP reservation on router: MAC `XX:XX:XX:XX:XX:XX` → IP `192.168.1.XXX`
- Monitor IP stability: `ssh root@192.168.1.XXX "ip addr show ens18 | grep 'inet '"`

**Verification:**
```bash
# Check no DHCP client running
ps aux | grep dhclient | grep -v grep

# Verify static IP
ip addr show ens18 | grep "inet "

# Check agent connectivity
/var/ossec/bin/agent_control -l
```

---

## Future Enhancements

- [x] ~~Rebuild with Debian 12~~ - Completed 2026-02-02
- [ ] Integrate Suricata alerts from OPNsense (after deployment)
- [ ] Create custom detection rules
- [ ] Set up email/Discord alerting
- [ ] Enable SSL/TLS security (optional for homelab)

---

## Related Pages

- [[Network-Topology]]
- [[Security-Hardening]]
- [[NAS-Synology|NAS ARM64 Incompatibility]]
- [[Future-Plans|OPNsense + Suricata Integration]]
