# Portfolio — Nicholas Nogueira

Personal portfolio and blog. Rails 8 + Phlex components + Tailwind + SQLite.

Live at **https://nicholastn.dev** (deployed via Coolify on a self-hosted Proxmox VM behind Cloudflare Tunnel).

## Stack
- Ruby 3.4.2 / Rails 8.1.3
- Phlex for public components, ERB for admin
- Tailwind CSS via tailwindcss-rails
- Hotwire (Turbo + Stimulus) via importmap-rails
- Pagy for pagination, Ransack for admin search
- gettext for i18n (PT/EN)
- bcrypt for admin auth (session-based)
- Active Storage + Action Text (Trix)
- Solid Cache / Queue / Cable

## Local development
```bash
bin/setup
bin/dev          # starts Rails + Tailwind watcher via foreman
bin/rails test   # full test suite
bin/rubocop      # lint
```

Or via Docker:
```bash
docker compose up
```

## Deploy

Pushes to `main` trigger an automatic deploy via Coolify webhook.

Production environment requires:
- `RAILS_MASTER_KEY` (from `config/master.key`)
- `ADMIN_EMAIL`, `ADMIN_PASSWORD` (consumed by `db/seeds.rb` on first deploy)

## Architecture decisions

See [`.context/decisions/`](./.context/decisions/) for ADRs covering Phlex,
SQLite in production, bilingual content modeling, session-based auth, and
Coolify deployment.
