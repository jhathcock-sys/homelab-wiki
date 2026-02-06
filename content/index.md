# Hathcock Homelab Wiki

---

## Overview

Welcome to the Hathcock Infrastructure homelab documentation. This wiki covers a self-hosted enterprise-grade homelab built for learning, experimentation, and professional development.

**Tech Stack:** Docker containers, GitOps workflows, monitoring with Prometheus/Grafana, security with Wazuh SIEM, and infrastructure-as-code practices.

---

## Quick Navigation

### 🏗️ Infrastructure
- [[Network-Topology]] - IP assignments and network layout (192.168.1.XXX/24)
- [[GitOps-Workflow]] - Repository structure and deployment practices
- [[Workstation-Setup]] - Laptop configuration and tooling

### 🔧 Services
- [[Homepage-Dashboard]] - Unified dashboard for all services
- [[Dockhand]] - Docker container management interface
- [[_Monitoring-Stack]] - Prometheus, Grafana, Loki, Alertmanager
- [[Wazuh-SIEM]] - Security monitoring and event management
- [[Pi-hole]] - DNS-based ad blocking
- [[NAS-Synology]] - Network storage (DS220j)
- [[Obsidian-LiveSync]] - Note synchronization (CouchDB)
- [[Minecraft-Server]] - Game server deployment
- [[Homebox]] - Home inventory management

### 🔒 Security
- [[Wazuh-SIEM]] - SIEM deployment with agent management
- [[Security-Hardening]] - Best practices and configurations
- [[Best-Practices]] - Security guidelines and standards
- [[Monitoring-Stack-Security-Audit]] - Security review of monitoring infrastructure

### 📦 Projects
- [[Podcast-Studio]] - Video podcast recording platform (LiveKit)
- [[Portfolio-Site]] - Personal portfolio website (Hugo)
- [[Homelab-Wiki]] - This wiki (Quartz)
- [[Claude-Memory-System]] - AI assistant memory architecture
- [[Claude-Code-Agents]] - Custom agent documentation

### 📚 Reference
- [[Docker-Commands]] - Common Docker operations
- [[Troubleshooting]] - Common issues and solutions
- [[Environment-Files]] - Environment variable management
- [[GitHub-Repositories]] - Repository inventory

### 🗺️ Planning
- [[Future-Plans]] - Upcoming projects and goals
- [[_Changelog-Index]] - Recent changes and deployments

---

## Infrastructure At-a-Glance

**Primary Hosts:**
- **ProxMoxBox** (Dell R430) - Main Docker host with 14 containers
- **Pi5** (Raspberry Pi 5) - Secondary services with 7 containers
- **Synology NAS** (DS220j) - Network storage
- **Wazuh VM** (Debian 12) - Security monitoring with 4 monitored agents

**Key Technologies:**
- **Containers:** Docker Compose, Portainer
- **Monitoring:** Prometheus, Grafana, Loki, Alertmanager (Discord notifications)
- **Security:** Wazuh SIEM, Pi-hole, Nginx Proxy Manager
- **Networking:** Static IPs, Tailscale VPN mesh, UFW firewalls
- **GitOps:** Version-controlled infrastructure, drift detection

---

## Recent Updates

See [[_Changelog-Index]] for detailed changelog entries.

**Latest Highlights:**
- **2026-02-05:** Fixed Wazuh static IP configuration issue
- **2026-02-04:** Integrated Synology NAS with monitoring
- **2026-02-04:** Implemented GitOps drift detection script
- **2026-02-03:** Deployed podcast studio platform
- **2026-02-02:** Wazuh SIEM deployment with agent coverage

---

## About This Homelab

This homelab serves multiple purposes:
- **Learning:** Hands-on experience with enterprise technologies
- **Certification Prep:** Security+ and Azure AZ-104 study environment
- **Portfolio:** Demonstrating infrastructure and automation skills
- **Experimentation:** Testing new technologies and architectures

**Documentation Philosophy:** Comprehensive, searchable, and regularly updated documentation using Obsidian for private notes and this Quartz-powered wiki for public reference.

---

*Built with [Quartz v4](https://quartz.jzhao.xyz/) | Updated: 2026-02-05*
