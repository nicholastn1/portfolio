# frozen_string_literal: true

class Components::Sections::ProjectsSection < Components::Base
  include Phlex::Rails::Helpers::ImageTag

  def initialize(projects:)
    @projects = projects
  end

  def view_template
    section(
      id: "projects",
      class: "relative py-20 md:py-24",
      data: { controller: "scroll-animation" }
    ) do
      div(class: "max-w-[1200px] mx-auto px-6 md:px-10") do
        render_header
        render_grid
      end
    end
  end

  private

  def render_header
    div(
      class: "flex items-end justify-between gap-4 pb-5 mb-12 border-b border-ink flex-wrap",
      data: { scroll_animation_target: "element" }
    ) do
      div do
        div(class: "section-id mb-2") { plain "§05" }
        h2(
          class: "font-display text-ink display-wide leading-none",
          style: "font-size: clamp(2.25rem, 4.8vw, 3.5rem); font-weight: 600;"
        ) { plain _("Selected work") }
      end
      span(class: "mono-id text-ink-mute") do
        plain "#{@projects.length.to_s.rjust(2, '0')} / #{_('projects')}"
      end
    end
  end

  def render_grid
    div(class: "grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-12 md:gap-y-16") do
      @projects.each_with_index do |project, i|
        render_card(project, i)
      end
    end
  end

  def render_card(project, index)
    article(
      class: "flex flex-col group",
      data: { scroll_animation_target: "element" }
    ) do
      render_thumbnail(project, index)
      render_caption(project, index)
    end
  end

  def render_thumbnail(project, index)
    div(class: "relative mb-5 border border-rule bg-paper-deep overflow-hidden") do
      div(class: "aspect-[4/3] flex items-center justify-center") do
        if project.respond_to?(:image) && project.image.attached?
          image_tag(
            project.image,
            alt: project.name,
            loading: "lazy",
            class: "w-full h-full object-cover transition-transform duration-700 group-hover:scale-[1.02]"
          )
        else
          span(
            class: "font-display text-signal/30",
            style: "font-size: 6rem; font-variation-settings: 'wdth' 90, 'opsz' 96; font-weight: 700;"
          ) do
            plain "P-#{(index + 1).to_s.rjust(2, '0')}"
          end
        end
      end

      # Top-left ID tag
      div(class: "absolute top-3 left-3 bg-paper border border-ink px-2 py-0.5 mono-id text-ink") do
        plain "P-#{(index + 1).to_s.rjust(2, '0')}"
      end

      # Top-right status if ongoing
      if project.ended_at.blank? && project.started_at.present?
        div(class: "absolute top-3 right-3 bg-signal text-paper px-2 py-0.5 mono-id flex items-center gap-1.5") do
          span(class: "w-1.5 h-1.5 rounded-full bg-paper")
          plain _("active")
        end
      end
    end
  end

  def render_caption(project, _index)
    # Title row
    div(class: "flex flex-wrap items-baseline justify-between gap-2 mb-2") do
      h3(
        class: "font-display text-ink text-[1.35rem] md:text-[1.5rem] leading-tight",
        style: "font-variation-settings: 'wdth' 100, 'opsz' 32; font-weight: 600;"
      ) do
        if project.url.present? || project.github_url.present?
          a(
            href: project.url.presence || project.github_url,
            target: "_blank",
            rel: "noopener noreferrer",
            class: "signal-link"
          ) { plain project.name }
        else
          plain project.name
        end
      end
      span(class: "mono-data text-ink-mute") { plain format_period(project) }
    end

    # Description
    p(
      class: "text-ink-soft text-[0.95rem] leading-[1.6] mb-4"
    ) { plain project.description.to_s }

    render_technologies(project.technologies)
    render_links(project)
  end

  def render_technologies(technologies)
    return unless technologies.present?

    div(class: "flex flex-wrap gap-1.5 mb-4") do
      technologies.each do |tech|
        span(class: "chip") { plain tech }
      end
    end
  end

  def render_links(project)
    return unless project.github_url.present? || project.url.present?

    div(class: "flex flex-wrap items-center gap-x-5 pt-3 border-t border-rule") do
      if project.url.present?
        a(
          href: project.url,
          target: "_blank",
          rel: "noopener noreferrer",
          class: "mono-id text-ink hover:text-signal transition-colors inline-flex items-center gap-1.5"
        ) do
          plain _("Live")
          span { plain "↗" }
        end
      end
      if project.github_url.present?
        a(
          href: project.github_url,
          target: "_blank",
          rel: "noopener noreferrer",
          class: "mono-id text-ink-mute hover:text-signal transition-colors"
        ) { plain "Source / GitHub" }
      end
    end
  end

  def format_period(project)
    return "" if project.started_at.blank?
    start_str = project.started_at.year.to_s
    end_str = project.ended_at&.year&.to_s
    if end_str.nil?
      "#{start_str}→"
    elsif end_str == start_str
      start_str
    else
      "#{start_str}–#{end_str}"
    end
  end
end
