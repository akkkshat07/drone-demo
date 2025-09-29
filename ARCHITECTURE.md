# Drone CI Architecture

## System Overview

The Drone CI system consists of three main components working together to provide continuous integration and deployment capabilities:

### Core Components

1. **Drone Server**
   - **Purpose**: Central control plane and web interface
   - **Port**: 8080 (HTTP)
   - **Responsibilities**:
     - User authentication via GitHub OAuth
     - Repository management and webhook handling
     - Pipeline scheduling and coordination
     - Build history and artifact storage
     - REST API for external integrations

2. **Drone Runner**
   - **Purpose**: Pipeline execution engine
   - **Connection**: Communicates with Drone Server via RPC
   - **Responsibilities**:
     - Pulls and executes pipeline steps
     - Manages Docker containers for build isolation
     - Reports build status back to server
     - Handles concurrent pipeline execution

3. **GitHub Integration**
   - **Purpose**: Source code management and trigger system
   - **Authentication**: OAuth App with Client ID/Secret
   - **Responsibilities**:
     - Source code hosting
     - Webhook delivery for push/PR events
     - User authentication provider
     - Repository access control

## Data Flow

```
GitHub Repository → Webhook → Drone Server → Drone Runner → Docker Containers
                                    ↑              ↓
                             Web UI Access    Build Results
```

## Architecture Diagram Suggestions

For your project report, consider creating diagrams showing:

### High-Level Architecture
- GitHub cloud (with repository icon)
- Local development environment box containing:
  - Drone Server container (port 8080)
  - Drone Runner container (with Docker socket)
- Arrows showing data flow:
  - Webhook from GitHub to Drone Server
  - RPC communication between Server and Runner
  - Docker container spawning from Runner

### Component Interaction Diagram
- User authentication flow (GitHub OAuth)
- Pipeline trigger sequence (Push → Webhook → Build)
- Build execution flow (Server → Runner → Containers)

### Network Architecture
- Port mappings (8080:80 for server)
- Docker socket mounting (/var/run/docker.sock)
- Internal container networking
- External GitHub API access

## Security Considerations

### Authentication & Authorization
- GitHub OAuth integration for user authentication
- Repository-level access control
- Admin user configuration
- RPC secret for server-runner communication

### Network Security
- Local deployment (no external exposure)
- Docker socket access (privileged operation)
- Environment variable management for secrets

### Data Storage
- Persistent volume for build history
- Container isolation for build environments
- No sensitive data in container images

## Scalability

### Horizontal Scaling
- Multiple runners can connect to single server
- Each runner can handle multiple concurrent builds
- Runner capacity configuration (DRONE_RUNNER_CAPACITY)

### Vertical Scaling
- Server resources for web UI and API
- Runner resources for build execution
- Docker resource limits per build

## Monitoring & Debugging

### Log Locations
- Drone Server: `docker logs drone`
- Drone Runner: `docker logs runner`
- Individual builds: Available through web UI

### Health Checks
- Server HTTP endpoint: http://localhost:8080
- Container status: `docker ps`
- Resource usage: `docker stats`

## Development Workflow

1. **Code Development**: Local development with Git
2. **Code Commit**: Push to GitHub repository
3. **Pipeline Trigger**: GitHub webhook notifies Drone
4. **Build Execution**: Runner executes pipeline steps
5. **Result Reporting**: Status updates to GitHub and UI
6. **Notification**: Build results visible in Drone UI

This architecture provides a complete CI/CD pipeline suitable for local development and testing while maintaining the same patterns used in production environments.