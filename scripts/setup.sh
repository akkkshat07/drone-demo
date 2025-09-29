#!/bin/bash

echo "=== Drone CI Setup Script ==="
echo

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Creating .env file from example..."
    cp .env.example .env
    echo "Please edit .env file with your GitHub OAuth credentials and RPC secret"
    echo "Then run this script again"
    exit 1
fi

echo "Starting Drone CI components..."

# Using docker-compose
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    # Fallback to individual docker commands
    echo "Starting Drone Server..."
    docker run \
      --volume=/var/lib/drone:/data \
      --env-file=.env \
      --env=DRONE_AGENTS_ENABLED=true \
      --env=DRONE_GITHUB_SERVER=https://github.com \
      --env=DRONE_TLS_AUTOCERT=false \
      --env=DRONE_USER_CREATE=username:$(grep GITHUB_USERNAME .env | cut -d'=' -f2),admin:true \
      --publish=8080:80 \
      --restart=always \
      --detach=true \
      --name=drone \
      drone/drone:2

    echo "Starting Drone Runner..."
    docker run \
      --volume=/var/run/docker.sock:/var/run/docker.sock \
      --env-file=.env \
      --env=DRONE_RPC_PROTO=http \
      --env=DRONE_RPC_HOST=localhost:8080 \
      --env=DRONE_RUNNER_CAPACITY=2 \
      --env=DRONE_RUNNER_NAME=my-first-runner \
      --restart=always \
      --detach=true \
      --name=runner \
      drone/drone-runner-docker:1
fi

echo
echo "Waiting for containers to start..."
sleep 10

echo "=== Container Status ==="
docker ps | grep -E "(drone|runner)"

echo
echo "=== Drone UI ==="
echo "Open your browser and go to: http://localhost:8080"
echo

echo "Setup complete! Check the logs with:"
echo "  docker logs drone"
echo "  docker logs runner"