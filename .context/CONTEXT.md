# Domain Context

## Overview

Personal portfolio and blog website for Nicholas Nogueira, a Software Engineer based in Fortaleza, Brazil. The site showcases professional experience, education, certifications, projects, skills, and languages — all manageable via an admin panel. Content is bilingual (Portuguese as default, English as secondary). The target audience is recruiters, hiring managers, and potential collaborators.

## Domain

### Core Entities

| Entity | Responsibility |
|--------|----------------|
| `PersonalInfo` | Singleton holding the owner's name, title, location, bio (PT/EN), contact info. Has attached profile image and associated social links. |
| `Experience` | Work history entries with company, role, achievements, technologies, and date range. Bilingual via `Localizable`. |
| `Education` | Academic records with institution, degree, course, activities. Bilingual. |
| `Certification` | Professional certifications with provider, date, and optional URL. Bilingual names. |
| `Volunteering` | Volunteer work entries with organization, role, and date range. Bilingual. |
| `Project` | Portfolio projects with description, technologies, GitHub/live URLs, and attached image. Bilingual. |
| `Skill` | Technical skills with category, proficiency level, and featured flag. |
| `Language` | Spoken languages with proficiency level. Bilingual names/levels. |
| `Post` | Blog posts with rich text body (Action Text), cover image, tags, category, slug-based routing. Bilingual title/description. |
| `SocialLink` | Links to external profiles (GitHub, LinkedIn, WhatsApp, etc.). Belongs to `PersonalInfo`. |
| `User` | Admin users with bcrypt password authentication. Authors of blog posts. |

### Modules/Packages

```
app/
├── components/           # Phlex components for public UI
│   ├── base.rb           # Base component (inherits Phlex::HTML)
│   ├── sections/         # Page sections (Hero, About, Experience, Education, Skills, Projects)
│   ├── layout/           # Header, Footer
│   ├── ui/               # Reusable UI (Badge, ThemeToggle, LanguageSwitcher)
│   └── blog/             # Blog-specific components (PostCard)
├── controllers/
│   ├── pages_controller.rb        # Public homepage
│   ├── posts_controller.rb        # Public blog
│   └── admin/                     # Admin namespace (CRUD for all entities)
├── models/
│   ├── concerns/localizable.rb    # Bilingual field resolution
│   └── [entity].rb                # Domain models
├── views/
│   ├── pages/home.html.erb        # Composes Phlex sections
│   ├── posts/                     # Blog index/show (ERB)
│   ├── admin/                     # Admin CRUD views (ERB)
│   └── layouts/                   # Application + Admin layouts
├── javascript/controllers/        # Stimulus controllers
└── assets/                        # Tailwind CSS, static assets
```

## Architecture

### System Overview

This is a Rails 8.1 monolith serving both a public portfolio website and an admin panel. It follows a component-based architecture for the public UI (Phlex) while using standard Rails MVC with ERB for the admin panel. Data is stored in SQLite with WAL mode enabled for concurrent read performance. The app is designed to be deployed as a single Docker container with a persistent volume for the SQLite database and uploaded files.

### Directory Structure

```
portfolio/
├── app/                    # Application code (MVC + components)
│   ├── components/         # Phlex components for public-facing pages
│   ├── controllers/        # Rails controllers (public + admin namespace)
│   ├── models/             # ActiveRecord models with Localizable concern
│   ├── views/              # ERB templates (admin + layouts + blog)
│   ├── javascript/         # Stimulus controllers (theme, scroll, tilt, language, mobile menu)
│   ├── helpers/            # View helpers (admin navigation)
│   └── assets/             # Tailwind CSS source + static assets
├── config/                 # Rails configuration, routes, initializers
├── db/                     # Schema, migrations, seeds (comprehensive seed data)
├── locale/                 # gettext .po/.pot translation files (pt_BR, en)
├── bin/                    # Rails binstubs + dev/ci/docker-entrypoint scripts
├── public/                 # Static files served directly
├── test/                   # Minitest test suite (standard Rails structure)
├── .docker/                # Development Dockerfile
├── .kamal/                 # Kamal deployment hooks and secrets
└── .context/               # AI context documentation
```

### Key Dependencies

| Category | Dependency | Purpose |
|----------|-----------|---------|
| Framework | Rails 8.1.3 | Full-stack web framework |
| Components | Phlex (phlex-rails) | HTML component framework replacing partials for public UI |
| UI Kit | ruby_ui | Pre-built Tailwind UI components for Phlex |
| CSS | tailwindcss-rails | Utility-first CSS framework |
| JavaScript | Hotwire (Turbo + Stimulus) | SPA-like navigation + modest JS controllers |
| Asset Pipeline | importmap-rails | ES module imports without bundler |
| Database | sqlite3 | Embedded relational database |
| Auth | bcrypt | Password hashing for admin users |
| Pagination | pagy | Lightweight pagination |
| Search | ransack | Admin search/filtering |
| I18n | gettext, gettext_i18n_rails | Translation via .po/.pot files |
| Rich Text | Action Text (Trix) | WYSIWYG editor for blog posts |
| File Upload | Active Storage | Image attachments (profile, projects, posts) |
| Background Jobs | Solid Queue | Database-backed job queue |
| Caching | Solid Cache | Database-backed cache store |
| Web Server | Puma + Thruster | App server with HTTP caching/compression |
| Deployment | Kamal + Docker | Container-based deployment |
| Testing | Minitest + Capybara + Selenium | Unit, integration, and system tests |
| Linting | RuboCop (rails-omakase) | Ruby style enforcement |
| Security | Brakeman, bundler-audit | Static analysis + dependency auditing |

### Data Flow

```
Public Pages:
  Browser → Turbo Drive → Rails Router → PagesController#home
    → loads all entities from SQLite → passes to Phlex components
    → components render HTML → Turbo streams response to browser

Blog:
  Browser → PostsController → Post.published.recent (scoped query)
    → ERB templates render post list/detail with Action Text body

Admin Panel:
  Browser → Admin::SessionsController (login with bcrypt)
    → session[:admin_user_id] stored in cookie
    → Admin::BaseController#authenticate_admin! (before_action)
    → CRUD controllers → ERB forms with Pagy pagination
    → redirect with flash notice on success

Locale Resolution:
  Request → ApplicationController#set_locale
    → params[:locale] || cookies[:locale] || Accept-Language header || "pt"
    → I18n.locale set → Localizable concern resolves _pt/_en columns
```

## Conventions

### Naming Patterns

- **Ruby**: snake_case for variables/methods, PascalCase for classes/modules (standard Rails)
- **Database columns**: snake_case with `_pt`/`_en` suffixes for bilingual fields (e.g., `role_pt`, `role_en`)
- **JSON columns**: Used for arrays (achievements, activities, technologies, tags, bio)
- **Phlex components**: Namespaced under `Components::` (e.g., `Components::Sections::HeroSection`)
- **Stimulus controllers**: kebab-case filenames (e.g., `scroll_animation_controller.js` → `scroll-animation`)
- **CSS**: Tailwind utility classes with custom color tokens (`bg-dark`, `accent-green`, `text-muted`, `gradient-primary`)

### Error Handling

- Standard Rails pattern: `if @record.save` / `else render :new, status: :unprocessable_entity`
- No custom error classes — relies on ActiveRecord validations and Rails flash messages
- Admin authentication redirects to login page with alert message

### Testing Style

- **Framework**: Minitest (Rails default)
- **Structure**: `test/` directory with standard Rails subdirectories (models, controllers, integration, helpers, mailers)
- **Parallelization**: `parallelize(workers: :number_of_processors)` enabled
- **Fixtures**: Uses Rails fixtures (`fixtures :all`)
- **System tests**: Capybara + Selenium configured for browser testing
- Note: Test files are mostly scaffolded stubs — test coverage is minimal

### Import Organization

- **Ruby**: `require` statements are minimal (Rails autoloading handles most)
- **JavaScript**: ES module imports via importmap — Hotwire first, then Stimulus controllers, then Action Text
- **Phlex components**: No explicit imports needed (autoloaded via `Components` namespace in `config/initializers/phlex.rb`)

### State Management

- **Server-side sessions**: Admin auth via `session[:admin_user_id]`
- **Cookies**: Locale preference stored in a 1-year cookie
- **Stimulus**: Lightweight client-side state in individual controllers (theme, scroll, mobile menu)
- No client-side state management library (no Redux, Vuex, etc.)

### API Response Format

- N/A — This is a server-rendered app with no JSON API. All responses are HTML via Turbo.

## Main Flows

### Authentication (Admin)

```
1. User visits /admin/login
2. Admin::SessionsController#new renders login form
3. POST /admin/login → SessionsController#create
4. Find User by email, authenticate with bcrypt (has_secure_password)
5. On success: session[:admin_user_id] = user.id → redirect to admin root
6. On failure: flash alert → re-render login form
7. DELETE /admin/logout → destroy session → redirect to login
```

### Homepage Rendering

```
1. GET / → PagesController#home
2. Loads PersonalInfo.instance, Experience.all, Education.all, etc.
3. Renders home.html.erb which composes Phlex components:
   - Layout::Header → Sections::Hero → Sections::About
   - Sections::Experience → Sections::Education
   - Sections::Skills → Sections::Projects → Layout::Footer
4. Each component receives data via constructor injection
5. Localizable concern resolves _pt/_en fields based on I18n.locale
```

### Locale Switching

```
1. User clicks language switcher (Stimulus language_controller)
2. Request includes locale param (e.g., /en)
3. ApplicationController#set_locale resolves locale from:
   params[:locale] → cookies[:locale] → Accept-Language → "pt"
4. Sets I18n.locale and stores in cookie (1 year expiry)
5. English routes scoped under /:locale, Portuguese at root
```

## External Integrations

| System | Type | Description |
|--------|------|-------------|
| Google Fonts | CDN | JetBrains Mono font loaded via Google Fonts |
| WhatsApp API | External link | Contact button links to WhatsApp web API |
| Active Storage | Local disk | File uploads stored on local disk (Docker volume in production) |

## Glossary

| Term | Definition |
|------|------------|
| **Localizable** | ActiveRecord concern that adds bilingual field resolution (`_pt`/`_en` suffix pattern) |
| **PersonalInfo.instance** | Singleton pattern — `first_or_initialize` returns the single personal info record |
| **Featured skill** | A skill with `featured: true` — highlighted in the public skills section |
| **Proficiency** | Skill level classification: `proficient`, `intermediate`, or `beginner` |
| **Solid Queue/Cache/Cable** | Rails 8 database-backed adapters for background jobs, caching, and Action Cable (all using SQLite) |
| **WAL mode** | SQLite Write-Ahead Logging — enables concurrent readers with a single writer |
