# Quick Start Guide

Follow these steps to get Drone CI running locally in under 10 minutes:

## Prerequisites
- Docker installed and running
- Git installed
- GitHub account

## Step 1: Setup GitHub OAuth App
1. Go to GitHub Settings → Developer settings → OAuth Apps
2. Create new OAuth App:
   - **Application name**: `Drone CI Local`
   - **Homepage URL**: `http://localhost:8080`
   - **Authorization callback URL**: `http://localhost:8080/login`
3. Save Client ID and Client Secret

## Step 2: Configure Environment
```bash
# Copy environment template
cp .env.example .env

# Edit .env file with your values:
# DRONE_GITHUB_CLIENT_ID=your_client_id
# DRONE_GITHUB_CLIENT_SECRET=your_client_secret
# DRONE_RPC_SECRET=generate_32_char_random_string
# GITHUB_USERNAME=your_github_username
```

## Step 3: Generate RPC Secret
```bash
# Linux/Mac
openssl rand -hex 16

# Or use the helper script
./scripts/generate-secret.sh
```

## Step 4: Start Drone CI
```bash
# Using docker-compose (recommended)
docker-compose up -d

# Or use the setup script
./scripts/setup.sh        # Linux/Mac
./scripts/setup.bat       # Windows
```

## Step 5: Access Drone UI
1. Open http://localhost:8080
2. Authorize with GitHub
3. Activate your repository

## Step 6: Test Pipeline
1. Create a repository with `.drone.yml`
2. Push code to GitHub
3. Watch pipeline execute in Drone UI

## Verification Commands
```bash
# Check containers are running
docker ps

# View logs
docker logs drone
docker logs runner

# Check status
./scripts/status.sh
```

## Sample Repository Structure
```
your-repo/
├── .drone.yml          # Pipeline configuration
├── app.py             # Sample application
├── test_app.py        # Unit tests
├── requirements.txt   # Dependencies
└── README.md          # Documentation
```

## Need Help?
- Check `README.md` for detailed instructions
- Review `ARCHITECTURE.md` for system overview
- Use `./scripts/status.sh` to debug issues
- Run `./scripts/cleanup.sh` to reset everything