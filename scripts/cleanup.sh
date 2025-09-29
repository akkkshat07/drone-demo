#!/bin/bash

echo "=== Drone CI Cleanup Script ==="
echo

read -p "This will stop and remove Drone containers and volumes. Continue? (y/N): " confirm

if [[ $confirm != [yY] ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo "Stopping containers..."
docker stop drone runner 2>/dev/null || echo "Containers already stopped"

echo "Removing containers..."
docker rm drone runner 2>/dev/null || echo "Containers already removed"

echo "Removing volumes..."
docker volume ls -q | grep drone | xargs docker volume rm 2>/dev/null || echo "No Drone volumes found"

echo "Removing images (optional)..."
read -p "Remove Drone Docker images as well? (y/N): " remove_images

if [[ $remove_images == [yY] ]]; then
    docker rmi drone/drone:2 drone/drone-runner-docker:1 2>/dev/null || echo "Images already removed"
fi

echo "Removing docker-compose resources..."
docker-compose down -v 2>/dev/null || echo "No docker-compose resources found"

echo
echo "=== Cleanup Summary ==="
echo "Remaining containers:"
docker ps -a | grep -E "(drone|runner)" || echo "No Drone containers found"

echo
echo "Remaining volumes:"
docker volume ls | grep drone || echo "No Drone volumes found"

echo
echo "Cleanup complete!"
echo "You can now restart with: ./scripts/setup.sh"