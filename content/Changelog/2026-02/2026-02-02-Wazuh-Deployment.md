# Wazuh SIEM Deployment (2026-02-02)

[[_Changelog-Index|← Back to Changelog]]

---

## Overview

Deployed Security Information and Event Management (SIEM) system on dedicated VM for centralized security monitoring across the homelab. Part of Security+ certification preparation.

---

## Initial Deployment

### VM Specs
- **IP:** [[Network-Topology|192.168.1.XXX]]
- **Hostname:** Wazuh
- **OS:** Initially Ubuntu 24.04, later rebuilt with Debian 12
- **RAM:** 8GB
- **CPU:** 4 cores
- **Disk:** ~90GB

### Components Installed
- **wazuh-manager** - Core SIEM engine
- **wazuh-indexer** - OpenSearch-based storage
- **wazuh-dashboard** - Kibana-based web interface
- **filebeat** - Alert shipping

---

## Rebuild with Debian 12

**Issue:** Ubuntu 24.04 not officially supported by Wazuh
**Solution:** Rebuilt VM with Debian 12 (bookworm)

### Installation Steps
```bash
# Official installer
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh
bash wazuh-install.sh -a

# Upgrade to v4.14.2
# Re-register agents
```

**Result:** Dashboard fully operational, all agents connected

---

## Agent Deployments

### Initial Agents (2026-02-02)
1. **SRV-DOCKER01** (ProxMoxBox - 192.168.1.XXX)
2. **pi-infra** (Pi5 - 192.168.1.XXX)

### Expanded Coverage (2026-02-02 later)
3. **SRV-DNS01** (Pi-hole LXC - 192.168.1.XXX)
4. **SRV-NPM01** (NPM LXC - 192.168.1.XXX)

### Current Agent Status

| ID | Name | Host | IP | Status |
|----|------|------|-----|--------|
| 000 | Wazuh (server) | localhost | - | Active/Local |
| 001 | SRV-DOCKER01 | ProxMoxBox | 192.168.1.XXX | Active |
| 002 | pi-infra | Pi5 | 192.168.1.XXX | Active |
| 003 | SRV-DNS01 | Pi-hole LXC | 192.168.1.XXX | Active |
| 004 | SRV-NPM01 | NPM LXC | 192.168.1.XXX | Active |

**Note:** [[NAS-Synology]] agent skipped due to ARM64 incompatibility (documented in [[2026-02-04-NAS-Integration]])

---

## Monitoring Integration

### Prometheus Integration
Added node-exporter to Wazuh VM for [[_Monitoring-Stack|monitoring stack]] integration.

**Scrape Target:**
```yaml
- job_name: 'wazuh'
  static_configs:
    - targets: ['192.168.1.XXX:9100']
      labels:
        instance: 'wazuh-vm'
```

### Expanded Monitoring
Also added node-exporter to:
- Pi-hole LXC (192.168.1.XXX:9100)
- NPM LXC (192.168.1.XXX:9100)

**Total Prometheus Scrape Targets:** 7
- Prometheus self
- ProxMoxBox
- Pi5
- cAdvisor
- Pi-hole LXC
- NPM LXC
- Wazuh VM

---

## Dashboard Configuration

### Access
**URL:** https://192.168.1.XXX

### Credentials
- **Username:** `admin`
- **password: [REDACTED] `ddZtfWVFD+7IV64.6DJzKRBPa6wYvSbA`

### API Credentials
- **Admin:** `wazuh` / `15jMA*JM6vcrzAdLLL825GRFrDLBiTJ1`
- **Dashboard:** `wazuh-wui` / `P?E*n9bWeY?9uaDCVy81vlDSlHabBR.o`

---

## Agent Installation Process

### Standard Installation
```bash
# Add Wazuh repo
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor -o /usr/share/keyrings/wazuh.gpg
echo 'deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main' > /etc/apt/sources.list.d/wazuh.list
apt update

# Install agent
WAZUH_MANAGER='192.168.1.XXX' apt install -y wazuh-agent

# Start agent
systemctl daemon-reload && systemctl enable wazuh-agent && systemctl start wazuh-agent
```

### Verification
```bash
# On Wazuh server
ssh root@192.168.1.XXX
/var/ossec/bin/agent_control -l
```

---

## Alerting Setup

### Prometheus + Alertmanager
Added [[Alertmanager]] with Discord notifications.

**Alert Categories:**
- System alerts (disk, CPU, memory, host down)
- Container alerts (high CPU, restarts, down)
- Target monitoring (Prometheus scrape failures)

**Notification Timing:**
- `group_wait: 30s` - Initial notification delay
- `group_interval: 5m` - Grouped alert interval
- `repeat_interval: 4h` - Unresolved alert repeat (1h for critical)

---

## Grafana Dashboards

### Created Dashboards
1. **Homelab Overview** (UID: homelab-overview)
   - Single pane of glass
   - Both hosts, containers, alerts, logs

2. **Docker Containers** (UID: docker-containers)
   - Detailed container metrics
   - Status table
   - Network/disk I/O

3. **Loki Logs** (UID: loki-logs)
   - Log exploration and search

### Imported Dashboards
- **Node Exporter Full** (ID: 1860) - System metrics
- **cAdvisor** (ID: 14282) - Container metrics

---

## Future Enhancements

- [ ] Integrate Suricata alerts from [[Future-Plans|OPNsense]] (after deployment)
- [ ] Create custom Wazuh detection rules
- [ ] Set up email/Discord alerting from Wazuh
- [ ] Enable SSL/TLS (optional for homelab)

---

## Security+ Learning

### Domains Covered
- **1.0 Threats, Attacks, Vulnerabilities** - SIEM log analysis
- **2.0 Architecture & Design** - Defense in depth, monitoring
- **3.0 Implementation** - Agent deployment, configuration
- **4.0 Operations & Incident Response** - Log aggregation, alerting

### Skills Demonstrated
- SIEM deployment and configuration
- Agent management across multiple platforms
- Integration with monitoring stack
- Security event correlation

---

## Related Pages

- [[Wazuh-SIEM]]
- [[_Monitoring-Stack]]
- [[Prometheus]]
- [[Alertmanager]]
- [[Grafana]]
- [[Network-Topology]]
- [[Best-Practices]]
