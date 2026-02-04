# Future Plans

[[_Index|← Back to Index]]

---

## Priority Projects

### Podcast Studio Deployment - NEW
- [ ] Deploy [[Podcast-Studio|video recording platform]] to [[Network-Topology|192.168.1.XXX]]
  - [ ] Configure environment and secrets
  - [ ] Set up UFW firewall rules
  - [ ] Deploy Docker Compose stack
  - [ ] Test 4K recording and multi-track functionality
  - [ ] Configure external access via NPM

### OPNsense + Managed Switch
**Enterprise networking foundation**

- [ ] OPNsense firewall (VM or dedicated box)
- [ ] Managed switch with port mirroring capability
- [ ] VLAN segmentation (IoT, servers, management, guest)
- [ ] Suricata IDS/IPS for intrusion detection
- [ ] ntopng for traffic analysis and visualization

### Wazuh SIEM - ✅ COMPLETED
- [x] Deployed on [[Network-Topology|192.168.1.XXX]] (Debian 12, v4.14.2)
- [x] Dashboard: https://192.168.1.XXX (fully working)
- [x] Agents on ProxMoxBox, Pi5, Pi-hole, NPM
- [ ] Integrate Suricata alerts from OPNsense (after deployment)

### NAS Build & Media Stack
**Storage and entertainment**

- [x] [[NAS-Synology|NAS Integration]] - Completed 2026-02-04 (Synology DS220j, 7.2TB)
- [ ] Media Stack deployment
  - [ ] Jellyfin/Plex - Media server
  - [ ] Overseerr - Media request management
  - [ ] Sonarr/Radarr - TV/Movie automation
  - [ ] Storage: [[NAS-Synology|NAS SMB shares]] at `/mnt/nas/homelab/media/`

---

## Career-Building Services

### Identity & Access Management
- [ ] **Authentik/Keycloak** - Single Sign-On (SSO)
  - Centralized authentication for all services
  - LDAP/OAuth integration
  - Career skill: Enterprise IAM

### Infrastructure Automation
- [ ] **Ansible/Semaphore** - Configuration management
  - Automated deployment of services
  - Playbooks for server provisioning
  - Career skill: IaC automation

### Documentation & IPAM
- [ ] **Netbox** - Network documentation (IPAM/DCIM)
  - IP address management (beyond simple [[Network-Topology|spreadsheet]])
  - Device inventory
  - Career skill: Enterprise network management

### Secrets Management
- [ ] **Vault** - Secrets management
  - Centralized credential storage
  - Replace scattered [[Environment-Files|.env files]]
  - Career skill: Security infrastructure

---

## Later Projects

### Home Automation
- [ ] **Home Assistant** - Smart home control
- [ ] **Node-RED** - Automation flows

### Container Orchestration
- [ ] **Kubernetes migration**
  - Convert Docker Compose to K8s manifests
  - Multi-node cluster on Proxmox
  - Career skill: K8s administration

---

## Related Pages

- [[Current-TODO]]
- [[Personal-Context|Goals & Learning Path]]
- [[Network-Topology]]
- [[Wazuh-SIEM]]
- [[NAS-Synology]]
- [[Podcast-Studio]]
