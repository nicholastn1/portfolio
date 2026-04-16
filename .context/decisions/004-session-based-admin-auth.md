# ADR-004: Session-Based Admin Authentication

**Status:** Accepted
**Date:** 2026-04-15
**Version:** 1.0

## Context

The admin panel needs authentication. Options considered:
1. Devise — full-featured but heavy for a single-user admin
2. Rails 8 Authentication generator — lighter but still more than needed
3. Custom bcrypt + session — minimal, sufficient for single-admin use case

## Decision

Use `has_secure_password` (bcrypt) with manual session management. A single `User` model stores credentials. `Admin::BaseController` runs `authenticate_admin!` as a `before_action` that checks `session[:admin_user_id]`.

No password reset, no email confirmation, no OAuth — the admin user is seeded via `db:seed` with a default password.

## Consequences

- **Positive:** Minimal code (~20 lines of auth logic), no gem dependencies beyond bcrypt
- **Positive:** Easy to understand and debug
- **Negative:** No password reset flow (must be done via Rails console)
- **Negative:** No multi-user role management (single admin only)
- **Negative:** Session stored in cookies — vulnerable to session fixation if not properly configured

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-15 | Initial decision |
