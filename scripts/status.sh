#!/bin/bash

COMPOSE_DIR="$HOME/gitlab-docker"
BACKUP_DIR="$HOME/gitlab-docker/data/backups"

echo "Gitlab status"

echo " Containers"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "gitlab|NAMES"

echo ""
echo "Gitlab version"
docker exec gitlab grep '^gitlab-ce ' /opt/gitlab/version-manifest.txt 2>/dev/null | awk '{print $2}' || echo "Unable to get version"

echo ""
echo "Gitlab health"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/users/sign_in)
if [ "$STATUS" == "200" ]; then
	echo "OK: Gitlab is available (HTTP $STATUS)"
else
	echo "WARNING: Gitlab returned HTTP $STATUS"
fi

echo ""
echo "Resource usage"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep -E "gitlab|NAMES"

echo ""
echo "Disk usage"
df -h "$HOME" | tail -1 | awk '{print "Used: " $3 " / " $2 " (" $5 " used)"}'

echo ""
echo "Gitlab docker images"
docker images | grep gitlab

echo ""
echo "Backups"
if ls "$BACKUP_DIR"/*_gitlab_backup.tar 2>/dev/null | head -1 > /dev/null; then
	echo "Available backups:"
	ls -lh "$BACKUP_DIR"/*_gitlab_backup.tar | awk '{print $5, $9}'
	echo ""
	LATEST=$(ls -t "$BACKUP_DIR"/*_gitlab_backup.tar | head -1)
else
	echo "No backups found in $BACKUP_DIR"
fi



