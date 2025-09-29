@echo off
echo === Drone CI Setup Script (Windows) ===
echo.

REM Check if .env file exists
if not exist .env (
    echo Creating .env file from example...
    copy .env.example .env
    echo Please edit .env file with your GitHub OAuth credentials and RPC secret
    echo Then run this script again
    pause
    exit /b 1
)

echo Starting Drone CI components...

REM Check if docker-compose exists
docker-compose --version >nul 2>&1
if %errorlevel% == 0 (
    docker-compose up -d
) else (
    echo Starting Drone Server...
    docker run ^
      --volume=/var/lib/drone:/data ^
      --env-file=.env ^
      --env=DRONE_AGENTS_ENABLED=true ^
      --env=DRONE_GITHUB_SERVER=https://github.com ^
      --env=DRONE_TLS_AUTOCERT=false ^
      --publish=8080:80 ^
      --restart=always ^
      --detach=true ^
      --name=drone ^
      drone/drone:2

    echo Starting Drone Runner...
    docker run ^
      --volume=/var/run/docker.sock:/var/run/docker.sock ^
      --env-file=.env ^
      --env=DRONE_RPC_PROTO=http ^
      --env=DRONE_RPC_HOST=localhost:8080 ^
      --env=DRONE_RUNNER_CAPACITY=2 ^
      --env=DRONE_RUNNER_NAME=my-first-runner ^
      --restart=always ^
      --detach=true ^
      --name=runner ^
      drone/drone-runner-docker:1
)

echo.
echo Waiting for containers to start...
timeout /t 10 /nobreak >nul

echo === Container Status ===
docker ps | findstr "drone runner"

echo.
echo === Drone UI ===
echo Open your browser and go to: http://localhost:8080
echo.

echo Setup complete! Check the logs with:
echo   docker logs drone
echo   docker logs runner
pause