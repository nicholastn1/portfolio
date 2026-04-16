# Architectural Decision Records (ADRs)

Record of significant technical decisions in this project.

## Index

| ADR | Title | Status |
|-----|-------|--------|
| [001](001-phlex-components-for-public-ui.md) | Phlex Components for Public UI | Accepted |
| [002](002-sqlite-in-production.md) | SQLite in Production | Accepted |
| [003](003-bilingual-content-with-column-suffixes.md) | Bilingual Content with Column Suffixes | Accepted |
| [004](004-session-based-admin-auth.md) | Session-Based Admin Authentication | Accepted |
| [005](005-docker-deployment-with-coolify.md) | Docker Deployment with Coolify | Accepted |

## Template

To create a new ADR, use the template below and save as `NNN-title-slug.md`:

```markdown
# ADR-NNN: Title

**Status:** Proposed | Accepted | Deprecated | Superseded
**Date:** YYYY-MM-DD
**Version:** 1.0

## Context

[Why was this decision needed?]

## Decision

[What was decided?]

## Consequences

- **Positive:** ...
- **Negative:** ...

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | YYYY-MM-DD | Initial decision |
```

## Conventions

- **Numbering:** Sequential, 3 digits with leading zeros (001, 002, ...)
- **Filename:** `NNN-title-in-slug.md`
- **Status:**
  - `Proposed` - Under discussion
  - `Accepted` - Approved and in use
  - `Deprecated` - Still works but not recommended
  - `Superseded` - Replaced by another ADR (link it)

## Adding Decisions

In Claude Code, use the interactive command:
```
/add-decision
```

This will ask clarifying questions and populate the ADR with context.
