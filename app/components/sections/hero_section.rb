# frozen_string_literal: true

class Components::Sections::HeroSection < Components::Base
  def initialize(personal_info:)
    @personal_info = personal_info
  end

  def view_template
    section(
      id: "hero",
      class: "relative pt-12 md:pt-20 pb-20 md:pb-28 overflow-hidden",
      data: { controller: "scroll-animation" }
    ) do
      div(class: "max-w-[1200px] mx-auto px-6 md:px-10 grid grid-cols-12 gap-x-6 reveal-stagger") do
        render_status_strip
        render_name_block
        render_role_line
        render_spec_grid
        render_actions
      end
      render_corner_tag
    end
  end

  private

  # Top bar: build-tag style identifier
  def render_status_strip
    div(class: "col-span-12 flex items-center mb-10 md:mb-14 pb-3 border-b border-rule flex-wrap gap-3") do
      div(class: "flex items-center gap-3 mono-data text-ink-mute") do
        span(class: "section-id") { plain "#{_('Profile').upcase} / #{Time.current.year}" }
        span(class: "text-rule") { plain "·" }
        span { plain "v#{Time.current.strftime('%Y.%m')}" }
      end
    end
  end

  # The name — single line, very large, condensed display variant
  def render_name_block
    first, last = split_name
    div(class: "col-span-12 mb-4") do
      h1(
        class: "font-display text-ink display-tight leading-[0.9]",
        style: "font-size: clamp(3rem, 9.5vw, 8rem); font-weight: 700;"
      ) do
        plain first
        plain " "
        plain last
      end
    end
  end

  # Role line — concise, builder-coded
  def render_role_line
    div(class: "col-span-12 md:col-span-9 mb-12 md:mb-14") do
      p(
        class: "font-display text-ink-soft leading-[1.35]",
        style: "font-size: clamp(1.15rem, 2vw, 1.5rem); font-variation-settings: 'wdth' 100, 'opsz' 32; font-weight: 400;"
      ) do
        plain @personal_info.title.to_s
        span(class: "text-signal mx-2") { plain "·" }
        em(class: "text-ink-mute") do
          plain tagline_text
        end
      end
    end
  end

  def tagline_text
    custom = @personal_info.tagline if @personal_info.respond_to?(:tagline)
    return custom if custom.present?
    _("focused on system architecture, performance, and AI-augmented software development.")
  end

  # Spec sheet grid — 4 key/value pairs
  def render_spec_grid
    div(class: "col-span-12 md:col-span-9") do
      dl(class: "grid grid-cols-1 sm:grid-cols-2 gap-x-10") do
        spec(_("Based in"),  location_text)
        spec(_("Stack"),     primary_stack)
        spec(_("Languages"), spoken_languages)
        spec(_("Updated"),   Time.current.strftime("%Y-%m-%d"))
      end
    end
  end

  def spec(label, value)
    return if value.blank?
    div(class: "spec-row") do
      dt { plain label }
      dd { plain value }
    end
  end

  # Action row: primary CTA + secondary social row
  def render_actions
    div(class: "col-span-12 mt-10 md:mt-14 pt-6 border-t border-rule flex flex-col md:flex-row md:items-center md:justify-between gap-6") do
      div(class: "flex items-center gap-4 flex-wrap") do
        a(
          href: "#projects",
          class: "inline-flex items-center gap-2 px-4 py-2.5 bg-ink text-paper " \
                 "mono-id hover:bg-signal transition-colors duration-200"
        ) do
          plain _("View selected work")
          span { plain "→" }
        end
        a(
          href: "#about",
          class: "inline-flex items-center gap-2 px-4 py-2.5 border border-rule text-ink " \
                 "mono-id hover:border-ink hover:text-signal transition-colors duration-200"
        ) do
          plain _("Read profile")
        end
      end
      render_social_inline
    end
  end

  def render_social_inline
    return unless @personal_info.respond_to?(:social_links) && @personal_info.social_links.present?

    excluded = %w[whatsapp instagram]
    visible = @personal_info.social_links.reject { |l| excluded.include?(l.platform.to_s.downcase) }
    return if visible.empty?

    div(class: "flex items-center gap-x-4 gap-y-1 flex-wrap") do
      visible.each do |link|
        a(
          href: link.url,
          target: "_blank",
          rel: "noopener noreferrer",
          class: "mono-id text-ink-mute hover:text-signal transition-colors " \
                 "[&:not(:first-child)]:before:content-['/'] [&:not(:first-child)]:before:mr-4 " \
                 "[&:not(:first-child)]:before:text-rule [&:not(:first-child)]:before:font-normal"
        ) { plain link.platform.to_s.downcase }
      end
    end
  end

  # Subtle build-tag in the corner: small, not floral
  def render_corner_tag
    div(class: "absolute right-6 md:right-10 bottom-4 hidden lg:flex items-center gap-1 mono-id text-ink-mute pointer-events-none select-none") do
      span(class: "w-3 h-px bg-rule")
      plain "BUILD / NN-PROFILE"
      span(class: "w-3 h-px bg-rule")
    end
  end

  # Helpers
  def split_name
    parts = @personal_info.name.to_s.split(" ", 2)
    [ parts.first.to_s, parts.last.to_s ]
  end

  def location_text
    if @personal_info.respond_to?(:location) && @personal_info.location.present?
      @personal_info.location.to_s
    else
      _("Brazil")
    end
  end

  # Pull a few key technologies — first 4 featured skills, fallback to a curated list
  def primary_stack
    if defined?(Skill) && Skill.respond_to?(:where)
      featured = Skill.where(featured: true).order(:position).limit(4).pluck(:name)
      return featured.join(" · ") if featured.any?
    end
    "Ruby · Rails · Postgres · Docker"
  end

  # Spoken languages — pulled from Language model, excluding "basic" proficiency
  def spoken_languages
    if defined?(Language) && Language.respond_to?(:where)
      langs = Language.where.not(proficiency: "basic").order(:position).pluck(:name_pt, :name_en)
      if langs.any?
        names = langs.map { |pt, en| (I18n.locale == :en ? en : pt).presence || pt || en }
        return names.compact.join(" · ")
      end
    end
    "Português · English"
  end
end
