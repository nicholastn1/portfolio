# frozen_string_literal: true

class Components::Sections::ProjectsSection < Components::Base
  def initialize(projects:)
    @projects = projects
  end

  def view_template
    section(
      id: "projects",
      class: "py-20 sm:py-28 bg-bg-dark",
      data: { controller: "scroll-animation" }
    ) do
      div(class: "max-w-[1200px] mx-auto px-6") do
        render_heading
        render_projects_grid
      end
    end
  end

  private

  def render_heading
    div(class: "mb-12") do
      h2(class: "text-3xl sm:text-4xl font-bold text-white") do
        plain "Projetos"
        span(class: "text-accent-green") { "." }
      end
    end
  end

  def render_projects_grid
    div(class: "grid grid-cols-1 md:grid-cols-2 gap-6") do
      @projects.each do |project|
        render_project_card(project)
      end
    end
  end

  def render_project_card(project)
    div(
      class: "rounded-xl bg-white/5 border border-white/5 p-6 " \
             "hover:border-accent-green/30 transition-colors duration-300 " \
             "flex flex-col",
      data: { controller: "tilt" }
    ) do
      render_card_header(project)
      render_card_description(project)
      render_card_period(project)
      render_card_technologies(project)
      render_card_links(project)
    end
  end

  def render_card_header(project)
    h3(class: "text-lg sm:text-xl font-semibold text-white mb-2") do
      plain project.name
    end
  end

  def render_card_description(project)
    p(class: "text-sm text-text-muted mb-4 leading-relaxed flex-grow") do
      plain project.description
    end
  end

  def render_card_period(project)
    p(class: "text-xs text-text-muted mb-4") do
      plain format_period(project)
    end
  end

  def render_card_technologies(project)
    technologies = project.technologies
    return if technologies.blank?

    div(class: "flex flex-wrap gap-2 mb-4") do
      technologies.each do |tech|
        render Components::Ui::Badge.new(text: tech, size: :xs)
      end
    end
  end

  def render_card_links(project)
    return unless project.github_url.present? || project.url.present?

    div(class: "flex items-center gap-4 pt-4 border-t border-white/5") do
      if project.github_url.present?
        a(
          href: project.github_url,
          target: "_blank",
          rel: "noopener noreferrer",
          class: "inline-flex items-center gap-1.5 text-sm text-text-muted " \
                 "hover:text-accent-green transition-colors duration-200"
        ) do
          github_icon
          span { "GitHub" }
        end
      end

      if project.url.present?
        a(
          href: project.url,
          target: "_blank",
          rel: "noopener noreferrer",
          class: "inline-flex items-center gap-1.5 text-sm text-text-muted " \
                 "hover:text-accent-green transition-colors duration-200"
        ) do
          external_link_icon
          span { "Live" }
        end
      end
    end
  end

  def format_period(project)
    start_str = project.started_at&.strftime("%b %Y")
    end_str = project.ended_at&.strftime("%b %Y") || "Atual"
    "#{start_str} - #{end_str}"
  end

  def github_icon
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      class: "w-4 h-4",
      fill: "currentColor",
      viewBox: "0 0 24 24"
    ) do |s|
      s.path(
        d: "M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416" \
           "-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 " \
           "3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524" \
           ".117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 " \
           "3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 " \
           "1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"
      )
    end
  end

  def external_link_icon
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      class: "w-4 h-4",
      fill: "none",
      viewBox: "0 0 24 24",
      stroke: "currentColor",
      stroke_width: "2"
    ) do |s|
      s.path(
        stroke_linecap: "round",
        stroke_linejoin: "round",
        d: "M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
      )
    end
  end
end
