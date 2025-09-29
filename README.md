# Drone CI Local Setup Guide

This guide provides complete step-by-step instructions to set up a local Drone CI/CD pipeline connected to GitHub.

## Prerequisites Installation

### Install Docker

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
```

#### macOS
```bash
# Using Homebrew
brew install --cask docker
# Or download Docker Desktop from https://www.docker.com/products/docker-desktop
```

### Install Git

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install -y git
```

#### macOS
```bash
# Using Homebrew
brew install git
# Or use Xcode command line tools
xcode-select --install
```

### Verify Installations
```bash
docker --version
docker-compose --version
git --version
```

## Step 1: Create GitHub OAuth App

1. Go to GitHub → Settings → Developer settings → OAuth Apps
2. Click "New OAuth App"
3. Fill in the following details:
   - **Application name**: `Drone CI Local`
   - **Homepage URL**: `http://localhost:8080`
   - **Authorization callback URL**: `http://localhost:8080/login`
4. Click "Register application"
5. Copy the **Client ID** and **Client Secret** (you'll need these later)

## Step 2: Generate RPC Secret

Generate a random secret for Drone RPC communication:

```bash
openssl rand -hex 16
```

Save this value - you'll use it as `DRONE_RPC_SECRET`.

## Step 3: Configure Environment Variables

Create a `.env` file in your project directory:

```bash
touch .env
```

Add the following content to `.env` (replace with your actual values):

```
DRONE_GITHUB_CLIENT_ID=your_github_client_id_here
DRONE_GITHUB_CLIENT_SECRET=your_github_client_secret_here
DRONE_RPC_SECRET=your_generated_rpc_secret_here
DRONE_SERVER_HOST=localhost:8080
DRONE_SERVER_PROTO=http
```

## Step 4: Start Drone Server

Run the Drone server container:

```bash
docker run \
  --volume=/var/lib/drone:/data \
  --env-file=.env \
  --env=DRONE_AGENTS_ENABLED=true \
  --env=DRONE_GITHUB_SERVER=https://github.com \
  --env=DRONE_TLS_AUTOCERT=false \
  --env=DRONE_USER_CREATE=username:your_github_username,admin:true \
  --publish=8080:80 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone:2
```

Replace `your_github_username` with your actual GitHub username.

## Step 5: Start Drone Runner

Run the Drone runner container:

```bash
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
```

## Step 6: Verify Containers Are Running

Check that both containers are running:

```bash
docker ps
```

You should see both `drone` and `runner` containers in the output.

Check container logs:

```bash
# Check Drone server logs
docker logs drone

# Check Drone runner logs
docker logs runner
```

## Step 7: Access Drone UI

1. Open your web browser
2. Navigate to `http://localhost:8080`
3. Click "Continue" to authorize with GitHub
4. You should see the Drone dashboard

## Step 8: Create Sample Repository

### Initialize Git Repository

```bash
mkdir drone-sample-app
cd drone-sample-app
git init
```

### Create Sample Application Files

Create `app.py`:

```python
def hello_world():
    return "Hello from Drone CI!"

def add_numbers(a, b):
    return a + b

if __name__ == "__main__":
    print(hello_world())
    print(f"2 + 3 = {add_numbers(2, 3)}")
```

Create `test_app.py`:

```python
from app import hello_world, add_numbers

def test_hello_world():
    assert hello_world() == "Hello from Drone CI!"

def test_add_numbers():
    assert add_numbers(2, 3) == 5
    assert add_numbers(-1, 1) == 0

if __name__ == "__main__":
    test_hello_world()
    test_add_numbers()
    print("All tests passed!")
```

Create `requirements.txt`:

```
pytest==7.4.0
```

## Step 9: Create Drone Pipeline Configuration

Create `.drone.yml` in the repository root:

```yaml
kind: pipeline
type: docker
name: default

steps:
- name: hello
  image: alpine:latest
  commands:
  - echo "Hello from Drone CI"
  - echo "Running tests..."
  - echo "Tests completed successfully"

- name: test
  image: python:3.9-alpine
  commands:
  - pip install -r requirements.txt
  - python -m pytest test_app.py -v
  - echo "Python tests completed"

- name: deploy
  image: alpine:latest
  commands:
  - echo "Deploying application..."
  - echo "Deployment completed successfully"
  when:
    branch:
    - main
```

## Step 10: Commit and Push to GitHub

### Add and Commit Files

```bash
git add .
git commit -m "Initial commit with Drone CI pipeline"
```

### Create GitHub Repository

1. Go to GitHub and create a new repository called `drone-sample-app`
2. Don't initialize with README, .gitignore, or license

### Push to GitHub

```bash
git branch -M main
git remote add origin https://github.com/your_username/drone-sample-app.git
git push -u origin main
```

Replace `your_username` with your actual GitHub username.

## Step 11: Activate Repository in Drone

1. Go to `http://localhost:8080`
2. You should see your `drone-sample-app` repository listed
3. Click the "Activate" button next to your repository
4. In the repository settings, make sure "Trusted" is enabled

## Step 12: Trigger Pipeline

### Method 1: Push a New Commit

Make a small change and push:

```bash
echo "# Drone CI Sample App" > README.md
git add README.md
git commit -m "Add README"
git push origin main
```

### Method 2: Manually Trigger

1. Go to your repository page in Drone UI
2. Click "New Build"
3. Select the branch and click "Create"

## Step 13: Monitor Pipeline Execution

1. In the Drone UI, click on your repository
2. You should see the pipeline execution
3. Click on the build to see detailed logs
4. Watch each step execute:
   - `hello` step: Prints greeting messages
   - `test` step: Runs Python tests
   - `deploy` step: Simulates deployment

## Step 14: Take Screenshots (Optional)

Take screenshots of:
1. Drone dashboard showing repositories
2. Pipeline execution page
3. Individual step logs
4. Successful build completion

## Step 15: Clean Up (Optional)

When you're done testing, you can clean up the containers and volumes:

```bash
# Stop and remove containers
docker stop drone runner
docker rm drone runner

# Remove volumes (this will delete Drone data)
docker volume rm $(docker volume ls -q | grep drone)

# Remove images (optional)
docker rmi drone/drone:2 drone/drone-runner-docker:1
```

## Troubleshooting

### Common Issues

1. **Containers won't start**: Check your `.env` file for correct values
2. **GitHub authorization fails**: Verify OAuth app settings and callback URL
3. **Runner can't connect**: Ensure both containers are on the same network
4. **Pipeline doesn't trigger**: Check repository activation and webhook settings

### Useful Commands

```bash
# View container logs
docker logs drone
docker logs runner

# Restart containers
docker restart drone runner

# Check container status
docker ps -a

# View Drone data
docker volume inspect drone_data
```

## Architecture Overview

The Drone CI setup consists of three main components:

1. **Drone Server**: Web UI and API (runs on port 8080)
2. **Drone Runner**: Executes pipelines using Docker containers
3. **GitHub Integration**: Webhook-based triggers and OAuth authentication

**Suggested Architecture Diagram Components:**
- GitHub Repository (with webhook)
- Drone Server Container (port 8080)
- Drone Runner Container (Docker socket)
- Pipeline Execution Flow
- Local Development Environment

This completes your local Drone CI setup! You now have a fully functional CI/CD pipeline that automatically runs when you push code to your GitHub repository.