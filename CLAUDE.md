# portfolio

> Personal portfolio and blog for Nicholas Nogueira — a Rails 8 app with Phlex components, bilingual content (PT/EN), admin panel, and Tailwind CSS dark theme.

## Decision Compliance

**IMPORTANT:** Before implementing any change, check `.context/decisions/` for related ADRs.

If a requested change conflicts with an existing decision:
1. **Stop and inform the user** which ADR(s) would be affected
2. **Ask explicitly** if they want to:
   - Proceed and update the decision
   - Modify the approach to comply with existing decision
   - Cancel the change
3. **If updating a decision**, create a new version:
   - Change status to `Superseded by ADR-XXX`
   - Create new ADR with updated decision
   - Reference the previous ADR

## Stack

- Ruby 3.4.2 / Rails 8.1.3
- Phlex (component framework, replaces partials for public pages)
- SQLite3 with WAL mode (development & production)
- Tailwind CSS via tailwindcss-rails
- Hotwire (Turbo + Stimulus) via importmap-rails
- Pagy for pagination, Ransack for admin search
- gettext (ruby-gettext + gettext_i18n_rails) for i18n — `.po`/`.pot` workflow
- bcrypt for admin authentication (session-based)
- Active Storage for image uploads (profile, project images, post covers)
- Action Text (Trix) for blog post rich text

## Commands

**Docker available** — use `docker compose exec app` for containerized execution, or run locally:

```bash
# Development (starts Rails + Tailwind watcher via foreman)
bin/dev
# Or via Docker:
docker compose up

# Tests
bin/rails test
# Docker: docker compose exec app bin/rails test

# Linting
bin/rubocop
# Docker: docker compose exec app bin/rubocop

# Security audit
bin/brakeman
bin/bundler-audit

# Database
bin/rails db:prepare
bin/rails db:seed

# i18n — extract translatable strings
bin/rails gettext:find

# Tailwind (standalone build)
bin/rails tailwindcss:build
```

## Critical Rules

1. **Always ask before assuming** — When there is ambiguity, multiple valid approaches, or decisions to be made, use the AskUserQuestion tool to clarify before proceeding. Never assume user intent.
2. **Bilingual content uses `_pt`/`_en` column suffixes** — Models with translatable fields store both languages as separate columns (e.g., `role_pt`, `role_en`). The `Localizable` concern provides a `localized_field` macro that resolves to the correct column based on `I18n.locale`. Never add single-language columns for translatable content.
3. **Phlex components for public UI, ERB for admin** — Public-facing pages use Phlex components in `app/components/`. Admin views use standard ERB templates in `app/views/admin/`. Do not mix these patterns.
4. **Portuguese is the default locale** — `I18n.default_locale = :pt`. URLs without a locale prefix serve Portuguese content. English routes are scoped under `/:locale` with `locale: /en/`.
5. **SQLite in production** — This app uses SQLite everywhere, including production via Docker volume. Do not add PostgreSQL/MySQL dependencies.

## Architecture

### Component-Based Public UI

Public pages render Phlex components (`Components::Sections::*`, `Components::Layout::*`, `Components::Ui::*`). Each section receives its data via constructor injection from `PagesController#home`. Components inherit from `Components::Base < Phlex::HTML`.

### Admin Panel

Namespaced under `Admin::` with session-based auth (`Admin::BaseController` → `authenticate_admin!`). Standard Rails CRUD controllers with ERB views. Uses Pagy for pagination and Ransack for filtering.

### Bilingual Content via Localizable Concern

The `Localizable` concern (`app/models/concerns/localizable.rb`) defines a `localized_field` class method that generates accessor methods resolving `_pt`/`_en` column suffixes based on `I18n.locale`.

## Efficiency Rules

- **Read before changing** — Always read a file before editing it. Never modify code based on assumptions about its content.
- **Follow existing patterns** — Before implementing something new, look at how similar things are done in the codebase. Match the existing style, conventions, and patterns.
- **Scope reads to the task** — Only read files directly relevant to the change. Do not explore broadly before acting on focused tasks.
- **Load context progressively** — Start with the minimum files needed. Only expand to related files when the current context is insufficient to complete the task.
- **Code only** — When implementing changes, output code. Skip explanations, preamble, and commentary unless the user asks for them.
- **Skip summaries** — After making changes, do not summarize what you did unless asked. Show `git diff` instead.
- **Run targeted tests** — After a change, run only tests related to the modified files. Only run the full suite when asked or before committing.
- **Never read generated files** — Do not read lock files, build output, vendored dependencies, or source maps. These are listed in `.claudeignore`.

## Compact Instructions

When compacting, preserve:
- Test results and error output
- File paths and code changes made
- Key decisions and their rationale

Remove:
- Exploratory file reads that did not lead to changes
- Verbose command output that has been summarized
- Discussion of rejected approaches

---

## Additional Context

- Domain and architecture → `.context/CONTEXT.md`
- Architectural decisions → `.context/decisions/`
- Task-specific skills → `.claude/skills/`
- Bug reproduction guide → `.claude/skills/bug-reproduction/SKILL.md`
- Batch operations guide → `.claude/skills/batch-operations/SKILL.md`
- Git platform detection → `.claude/skills/git-platform/SKILL.md`
