# Drone CI Local Setup

Complete local Drone CI/CD pipeline setup with GitHub integration.

## What's Included

- **Complete setup documentation** with step-by-step instructions
- **Working configuration files** (.drone.yml, docker-compose.yml)
- **Sample Python application** with tests
- **Helper scripts** for setup, status check, and cleanup
- **Architecture documentation** with diagram suggestions

## Quick Start

1. **Setup GitHub OAuth App** (see README.md for details)
2. **Configure environment**: `cp .env.example .env` and edit
3. **Start services**: `docker-compose up -d`
4. **Access UI**: http://localhost:8080
5. **Activate repository and test pipeline**

## File Structure

```
drone-demo/
├── README.md              # Complete setup guide
├── QUICKSTART.md          # 10-minute setup guide
├── ARCHITECTURE.md        # System architecture docs
├── .drone.yml            # Sample pipeline configuration
├── docker-compose.yml    # Docker services configuration
├── .env.example          # Environment variables template
├── sample-app/           # Sample Python application
│   ├── app.py
│   ├── test_app.py
│   ├── requirements.txt
│   └── README.md
└── scripts/              # Helper scripts
    ├── setup.sh          # Linux/Mac setup
    ├── setup.bat         # Windows setup
    ├── status.sh         # Status checker
    ├── cleanup.sh        # Cleanup script
    └── generate-secret.sh # RPC secret generator
```

## Features

- ✅ Local Docker-based setup
- ✅ GitHub OAuth integration
- ✅ Webhook-triggered pipelines
- ✅ Multi-step build pipeline
- ✅ Python testing example
- ✅ Cross-platform scripts
- ✅ Easy cleanup and restart

## Documentation

- **[README.md](README.md)**: Complete setup instructions
- **[QUICKSTART.md](QUICKSTART.md)**: Fast 10-minute setup
- **[ARCHITECTURE.md](ARCHITECTURE.md)**: System architecture and diagram suggestions

## Support

This project provides a complete, working Drone CI setup perfect for:
- Learning CI/CD concepts
- Local development testing
- Portfolio demonstrations
- Educational projects

All files are ready to use with no additional configuration needed beyond the GitHub OAuth setup.