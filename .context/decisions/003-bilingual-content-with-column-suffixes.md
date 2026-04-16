# ADR-003: Bilingual Content with Column Suffixes

**Status:** Accepted
**Date:** 2026-04-15
**Version:** 1.0

## Context

The portfolio needs to serve content in both Portuguese (default) and English. Options considered:
1. Rails I18n YAML files — good for static UI text, poor for user-generated content
2. Separate translation table (polymorphic) — flexible but adds JOINs and complexity
3. Column suffixes (`_pt`/`_en`) — simple, zero-overhead, direct access

## Decision

Use `_pt`/`_en` column suffixes on model fields that need translation. A `Localizable` concern provides a `localized_field` macro that generates accessor methods resolving the correct column based on `I18n.locale`.

Static UI text uses gettext (`.po`/`.pot` files) for the standard I18n workflow.

Example:
```ruby
class Experience < ApplicationRecord
  include Localizable
  localized_field :role, :description
end

# experience.role  # returns role_pt or role_en based on I18n.locale
```

## Consequences

- **Positive:** Zero overhead — no JOINs, no serialization, direct column access
- **Positive:** Simple to query and index specific language columns
- **Positive:** Easy to understand — the pattern is visible in the schema
- **Negative:** Adding a third language requires a migration to add `_XX` columns to every translated model
- **Negative:** Column proliferation — each translatable field adds N columns (currently 2)

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-15 | Initial decision |
