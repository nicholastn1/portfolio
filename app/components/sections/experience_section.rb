# frozen_string_literal: true

module Components
  module Sections
    class ExperienceSection < Components::Base
      MONTH_ABBREVS_PT = %w[Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez].freeze
      MONTH_ABBREVS_EN = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

      def initialize(experiences:)
        @experiences = experiences
      end

      def view_template
        section(
          id: "experience",
          class: "relative py-20 md:py-24",
          data: { controller: "scroll-animation" }
        ) do
          div(class: "max-w-[1200px] mx-auto px-6 md:px-10") do
            render_header
            render_entries
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
            div(class: "section-id mb-2") { plain "§02" }
            h2(
              class: "font-display text-ink display-wide leading-none",
              style: "font-size: clamp(2.25rem, 4.8vw, 3.5rem); font-weight: 600;"
            ) { plain _("Experience") }
          end
          span(class: "mono-id text-ink-mute") do
            plain "#{@experiences.length.to_s.rjust(2, '0')} / #{_('positions')}"
          end
        end
      end

      def render_entries
        div(class: "divide-y divide-rule") do
          @experiences.each_with_index do |experience, i|
            render_entry(experience, i)
          end
        end
      end

      def render_entry(experience, index)
        article(
          class: "grid grid-cols-12 gap-x-6 gap-y-3 py-8 md:py-10 group",
          data: { scroll_animation_target: "element" }
        ) do
          render_index_strip(experience, index)
          render_main(experience)
        end
      end

      # Left column: index number + date range, mono
      def render_index_strip(experience, index)
        div(class: "col-span-12 md:col-span-3") do
          div(class: "flex items-baseline gap-3 mb-1") do
            span(class: "section-id text-[0.95rem]") do
              plain "##{(index + 1).to_s.rjust(2, '0')}"
            end
            span(class: "mono-id text-ink-mute") { plain experience.ended_at.present? ? _("past") : _("current") }
          end
          div(class: "mono-data text-ink-mute") do
            plain format_period(experience.started_at, experience.ended_at)
          end
        end
      end

      def render_main(experience)
        div(class: "col-span-12 md:col-span-9") do
          # Header row: company + role
          div(class: "flex flex-wrap items-baseline gap-x-4 gap-y-1 mb-1") do
            h3(
              class: "font-display text-ink leading-tight",
              style: "font-size: clamp(1.3rem, 2.2vw, 1.7rem); font-variation-settings: 'wdth' 100, 'opsz' 32; font-weight: 600;"
            ) do
              if experience.company_url.present?
                a(
                  href: experience.company_url,
                  target: "_blank",
                  rel: "noopener noreferrer",
                  class: "signal-link"
                ) { plain experience.company }
              else
                plain experience.company
              end
            end
          end

          p(
            class: "mono-data text-signal mb-5 uppercase",
            style: "letter-spacing: 0.04em;"
          ) { plain experience.role.to_s }

          if experience.description.present?
            p(
              class: "text-ink-soft text-[1rem] leading-[1.65] mb-4 max-w-[60ch]"
            ) { plain experience.description }
          end

          render_achievements(experience.achievements)
          render_technologies(experience.technologies)
        end
      end

      def render_achievements(achievements)
        return unless achievements.present?

        ul(class: "max-w-[60ch] mb-5 space-y-2") do
          achievements.each do |achievement|
            li(class: "flex items-baseline gap-3 text-ink-soft") do
              span(class: "text-signal mono-id mt-0.5 shrink-0") { plain "→" }
              span(class: "text-[0.95rem] leading-[1.55]") { plain achievement }
            end
          end
        end
      end

      def render_technologies(technologies)
        return unless technologies.present?

        div(class: "flex flex-wrap items-center gap-1.5 max-w-[60ch]") do
          technologies.each do |tech|
            span(class: "chip") { plain tech }
          end
        end
      end

      def format_period(started_at, ended_at)
        start_str = format_date(started_at)
        end_str = ended_at.present? ? format_date(ended_at) : _("Present")
        "#{start_str} → #{end_str}"
      end

      def format_date(date)
        month_abbrevs = I18n.locale == :en ? MONTH_ABBREVS_EN : MONTH_ABBREVS_PT
        "#{month_abbrevs[date.month - 1]} #{date.year}"
      end
    end
  end
end
