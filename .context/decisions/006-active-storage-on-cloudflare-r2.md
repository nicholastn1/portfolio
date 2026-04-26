# ADR-006: Active Storage on Cloudflare R2

**Status:** Accepted
**Date:** 2026-04-26
**Version:** 1.0

## Context

ADR-002 ("SQLite in Production") describes the Rails app storing all data in a single Docker volume at `/rails/storage/`, including the SQLite databases AND any Active Storage uploads (project images, blog post covers, Trix-embedded images).

This created a real backup gap discovered during the production deploy at `nicholastn.dev`:

- The Coolify-managed automatic backup only dumps the **Coolify control-plane Postgres** to Cloudflare R2 daily.
- The portfolio's SQLite databases and Active Storage uploads only get protected by the **weekly Proxmox vzdump** of the entire VM.
- A failure between vzdump runs would lose up to 7 days of newly uploaded images/posts even though the SQLite snapshot may be more current.
- A volume corruption (vs. full disk failure) would not be caught by vzdump until the next snapshot — silent data loss for up to a week.

We already maintain an R2 bucket (`coolify-backups`) for Coolify backups. Reusing the same infrastructure for Active Storage uploads adds zero new external dependencies.

## Decision

Configure Active Storage in production to use **Cloudflare R2 (S3-compatible)** as its storage service. SQLite databases continue to live in the Docker volume per ADR-002 — only file uploads (Active Storage attachments) move off-host.

Configuration:

- `config/storage.yml` adds an `r2` service entry that reads its credentials from environment variables (`R2_ENDPOINT`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_BUCKET`).
- `config/environments/production.rb` resolves the service at boot:
  ```ruby
  config.active_storage.service = ENV["R2_BUCKET"].present? ? :r2 : :local
  ```
  This feature-flag means a missing/misconfigured env var does not crash the app — it falls back to local disk, preserving an easy rollback.
- The R2 bucket is shared with Coolify backups; uploads use the implicit prefix that Active Storage assigns (no manual prefixing needed since attachment paths are already namespaced by signed blob keys).
- Uploads remain **private**: the app generates short-lived signed URLs through Rails (`rails_blob_url`) instead of exposing R2 directly. No CDN / custom domain needed initially. If performance or bandwidth becomes a concern, a Cloudflare custom domain can front the bucket later without code changes — only an Active Storage `public: true` toggle plus a host whitelist.

## Consequences

- **Positive:** Active Storage uploads survive volume corruption and host failure independently of vzdump cadence.
- **Positive:** Uploads survive a Coolify reinstall — only the SQLite DB needs to be restored from the Coolify backup; image references in the DB still resolve to R2 URLs.
- **Positive:** Storage scales independently of the VM's 900 GB disk.
- **Positive:** Feature-flag means rollback is `unset R2_BUCKET` + redeploy.
- **Negative:** Each uploaded image is one extra round-trip to R2 (mitigated by Rails' signed-URL caching and the user's tolerance — portfolio is low-traffic).
- **Negative:** Bucket is shared with Coolify backups — accidental bulk-delete operations need to be path-aware. Mitigated by R2's per-prefix delete pattern.

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-26 | Initial decision |
