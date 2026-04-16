# ADR-001: Phlex Components for Public UI

**Status:** Accepted
**Date:** 2026-04-15
**Version:** 1.0

## Context

The portfolio's public pages need a component-based UI architecture. Rails partials work but lack strong encapsulation, explicit interfaces, and Ruby-native composition. The project needed a way to build reusable, testable UI components with clear data contracts.

## Decision

Use Phlex as the component framework for all public-facing pages. Admin views remain in ERB since they follow standard CRUD patterns where partials are sufficient.

- All public UI components live under `app/components/` namespaced as `Components::*`
- Components inherit from `Components::Base < Phlex::HTML`
- Data is passed via constructor injection (no global state or implicit assigns)
- `ruby_ui` provides pre-built Tailwind-compatible Phlex components
- Phlex Kit is used for auto-registration (`Components.extend Phlex::Kit`)

## Consequences

- **Positive:** Strong encapsulation, explicit data contracts, Ruby-native HTML generation, easy to test in isolation
- **Positive:** No ERB parsing overhead for public pages, components are plain Ruby objects
- **Negative:** Two rendering paradigms in the same app (Phlex for public, ERB for admin)
- **Negative:** Developers need to learn Phlex DSL in addition to standard Rails views

## History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-15 | Initial decision |
