#!/bin/bash

echo "=== Drone CI Status Check ==="
echo

echo "=== Container Status ==="
docker ps | grep -E "(CONTAINER|drone|runner)"

echo
echo "=== Drone Server Logs (last 20 lines) ==="
docker logs --tail 20 drone 2>/dev/null || echo "Drone server not running"

echo
echo "=== Drone Runner Logs (last 20 lines) ==="
docker logs --tail 20 runner 2>/dev/null || echo "Drone runner not running"

echo
echo "=== Network Test ==="
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080 || echo "Cannot connect to Drone UI"

echo
echo "=== Docker System Info ==="
echo "Docker version: $(docker --version)"
echo "Available images:"
docker images | grep -E "(drone|REPOSITORY)"

echo
echo "=== Quick Commands ==="
echo "View all logs: docker logs drone && docker logs runner"
echo "Restart services: docker restart drone runner"
echo "Access UI: http://localhost:8080"