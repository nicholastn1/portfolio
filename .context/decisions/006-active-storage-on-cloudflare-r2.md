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

## R2 quirks worth knowing

Two issues hit during the rollout that aren't documented in the AWS S3 SDK docs because they're R2-specific:

1. **`request_checksum_calculation` must be `when_required`.** aws-sdk-s3 1.220+ defaults to `when_supported`, which adds CRC32C/CRC64NVME headers alongside SHA-256. R2 rejects with `InvalidRequest: You can only specify one non-default checksum at a time`. Fixed in `config/storage.yml`.

2. **gettext_i18n_rails leaks `:"pt-BR"` into `I18n.locale`.** Active Storage's `ContentDisposition` calls `I18n.transliterate` on the upload filename. With `enforce_available_locales` on (production default), the `:"pt-BR"` locale must be in `I18n.available_locales` or the call raises `InvalidLocale` *before* the actual S3 PUT — but *after* the "Uploaded file to key" log line, so the error looks like a successful upload that vanishes. Fixed in `config/initializers/gettext.rb`.

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-26 | Initial decision |
| 1.1 | 2026-04-26 | Document the two R2-specific quirks discovered during rollout (checksum policy + I18n locale leak) |
