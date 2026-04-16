# ADR-005: Docker Deployment with Coolify

**Status:** Accepted
**Date:** 2026-04-15
**Version:** 1.0

## Context

The portfolio needs to be deployed to a self-hosted server (Nicholas's home lab running Proxmox + Coolify). Kamal is included in the Rails 8 default but Coolify provides a simpler deployment workflow with built-in Docker Compose support, SSL, and monitoring.

## Decision

Deploy via `docker-compose.production.yml` on Coolify. The production setup:
- Single Docker container running Puma behind Thruster (HTTP caching/compression)
- Persistent Docker volume for `/rails/storage` (SQLite databases + Active Storage files)
- `bin/docker-entrypoint` handles `db:prepare` and auto-seeding on first deploy
- `RAILS_MASTER_KEY` passed as environment variable
- Health check via `/up` endpoint

Kamal config (`config/deploy.yml`) is kept for reference but Coolify is the primary deployment target.

## Consequences

- **Positive:** Simple single-container deployment, Coolify handles SSL/reverse proxy
- **Positive:** Auto-seed on first deploy means zero manual setup
- **Positive:** Leverages existing home lab infrastructure
- **Negative:** Single point of failure (one server, one container)
- **Negative:** SQLite volume must be backed up externally

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-15 | Initial decision |
