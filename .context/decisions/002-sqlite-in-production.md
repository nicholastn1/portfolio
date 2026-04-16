# ADR-002: SQLite in Production

**Status:** Accepted
**Date:** 2026-04-15
**Version:** 1.0

## Context

The portfolio is a low-traffic personal site with a single admin user. Using PostgreSQL or MySQL would add operational complexity (separate database server, connection pooling, backups) without meaningful benefit for this workload. Rails 8 ships with first-class SQLite support including Solid Queue, Solid Cache, and Solid Cable.

## Decision

Use SQLite for all environments (development, test, production) with WAL mode enabled for concurrent read performance. Production databases are stored in a Docker volume at `/rails/storage/`.

Configuration includes:
- WAL journal mode with normal synchronous
- 128MB mmap for read performance
- Separate SQLite databases for cache, queue, and cable in production
- Auto-seed on first deploy via `bin/docker-entrypoint`

## Consequences

- **Positive:** Zero external dependencies, trivial backups (copy a file), fast reads, simple deployment
- **Positive:** Rails 8 Solid adapters work natively with SQLite
- **Negative:** Single-writer limitation (acceptable for single-admin portfolio)
- **Negative:** Cannot horizontally scale the web tier (only one server can write)
- **Negative:** Must ensure Docker volume persistence — losing the volume loses all data

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-15 | Initial decision |
