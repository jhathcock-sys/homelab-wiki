# Troubleshooting

[[_Index|← Back to Index]]

---

## Dockhand Issues

### Containers visible but not manageable in Dockhand
- Ensure `/opt` (or wherever compose files live) is mounted into Dockhand container
- Use the **Import** feature, not just viewing containers

### Hawser stacks not working
- Compose files must be on Dockhand server, not remote host
- Volume paths resolve on remote host - use absolute paths if needed
- Ensure Hawser agent is running on remote host

---

## Healthcheck Issues

### Healthcheck failing
- Check if healthcheck port matches actual service port
- Override with custom healthcheck in compose file

**Example:** [[Homebox#Health Fix]]

---

## Widget Issues

### Pi-hole widget not showing stats
- Ensure `version: 6` is set for Pi-hole v6
- Use the web password directly in the `key` field
- Environment variables may not work - use direct values in services.yaml

**Reference:** [[Homepage-Dashboard#Pi-hole v6 Widget Configuration]]

---

## Docker Issues

### Container won't start
```bash
# Check logs for errors
docker logs <container> --tail 50

# Check health status
docker inspect <container> --format '{{json .State.Health}}'

# Verify compose file syntax
docker compose config
```

### Permission denied errors
```bash
# Check volume mount permissions
ls -la /path/to/volume

# Fix ownership if needed (be careful!)
sudo chown -R 1000:1000 /path/to/volume
```

### Out of disk space
```bash
# Check disk usage
docker system df

# Clean up unused resources
docker system prune -a
```

---

## Network Issues

### Service unreachable
```bash
# Check if container is running
docker ps | grep <container>

# Check port mappings
docker port <container>

# Test connectivity
curl http://192.168.1.XXX:<port>
```

### DNS resolution issues
```bash
# Check Pi-hole status
ssh root@192.168.1.XXX
pihole status

# Check network DNS settings
cat /etc/resolv.conf
```

---

## Monitoring Issues

### Prometheus target down
```bash
# Check if exporter is running
docker ps | grep exporter

# Test endpoint manually
curl http://192.168.1.XXX:9100/metrics
```

### Grafana can't connect to datasource
```bash
# Check if Prometheus is reachable from Grafana container
docker exec -it grafana curl http://prometheus:9090/-/healthy
```

### Loki logs not appearing
```bash
# Check Promtail logs
docker logs promtail --tail 50

# Verify Promtail can reach Loki
docker exec -it promtail wget -O- http://loki:3100/ready
```

---

## Related Pages

- [[Docker-Commands]]
- [[Dockhand]]
- [[Homepage-Dashboard]]
- [[_Monitoring-Stack]]
