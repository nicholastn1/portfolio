# frozen_string_literal: true

module Components
  module Sections
    class ExperienceSection < Components::Base
      MONTH_ABBREVS = %w[Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez].freeze

      def initialize(experiences:)
        @experiences = experiences
      end

      def view_template
        section(
          id: "experience",
          class: "py-20 px-6 md:px-12 lg:px-24",
          data: { controller: "scroll-animation" }
        ) do
          div(class: "max-w-4xl mx-auto") do
            render_section_title
            render_timeline
          end
        end
      end

      private

      def render_section_title
        h2(class: "text-3xl md:text-4xl font-bold text-white mb-12") do
          plain "Experiência"
          span(class: "text-accent-green") { "." }
        end
      end

      def render_timeline
        div(class: "relative") do
          # Vertical timeline line
          div(class: "absolute left-0 md:left-4 top-0 bottom-0 w-px bg-white/10")

          div(class: "space-y-12") do
            @experiences.each do |experience|
              render_experience_card(experience)
            end
          end
        end
      end

      def render_experience_card(experience)
        div(class: "relative pl-8 md:pl-16 group") do
          # Timeline dot
          div(
            class: "absolute left-0 md:left-4 top-1.5 w-2 h-2 rounded-full bg-accent-green " \
                   "-translate-x-[3.5px] ring-4 ring-bg-dark group-hover:ring-white/5 transition-all"
          )

          div(
            class: "p-6 rounded-xl border border-white/5 bg-white/[0.02] " \
                   "hover:bg-white/5 hover:border-white/10 transition-all duration-300"
          ) do
            render_card_header(experience)
            render_card_body(experience)
            render_technologies(experience)
          end
        end
      end

      def render_card_header(experience)
        div(class: "flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1 mb-4") do
          div do
            h3(class: "text-lg font-bold text-white") do
              if experience.company_url.present?
                a(
                  href: experience.company_url,
                  target: "_blank",
                  rel: "noopener noreferrer",
                  class: "hover:text-accent-green transition-colors"
                ) { experience.company }
              else
                plain experience.company
              end
            end
            p(class: "text-accent-green font-medium") { experience.role }
          end

          span(class: "text-sm text-text-muted whitespace-nowrap") do
            plain format_period(experience.started_at, experience.ended_at)
          end
        end
      end

      def render_card_body(experience)
        if experience.description.present?
          p(class: "text-text-muted mb-4 leading-relaxed") { experience.description }
        end

        achievements = experience.achievements
        return unless achievements.present?

        ul(class: "space-y-2 mb-4") do
          achievements.each do |achievement|
            li(class: "flex items-start gap-2 text-sm text-text-muted") do
              span(class: "text-accent-green mt-1.5 shrink-0") { "▹" }
              span { achievement }
            end
          end
        end
      end

      def render_technologies(experience)
        technologies = experience.technologies
        return unless technologies.present?

        div(class: "flex flex-wrap gap-2 pt-2 border-t border-white/5") do
          technologies.each do |tech|
            render Components::Ui::Badge.new(text: tech, size: :xs)
          end
        end
      end

      def format_period(started_at, ended_at)
        start_str = format_date(started_at)
        end_str = ended_at.present? ? format_date(ended_at) : "Presente"
        "#{start_str} - #{end_str}"
      end

      def format_date(date)
        "#{MONTH_ABBREVS[date.month - 1]} #{date.year}"
      end
    end
  end
end
