# frozen_string_literal: true

module Components
  module Sections
    class EducationSection < Components::Base
      MONTH_ABBREVS_PT = %w[Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez].freeze
      MONTH_ABBREVS_EN = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

      PROFICIENCY_COLORS = {
        "native" => "bg-accent-green/10 text-accent-green border-accent-green/20",
        "fluent" => "bg-blue-500/10 text-blue-400 border-blue-500/20",
        "advanced" => "bg-purple-500/10 text-purple-400 border-purple-500/20",
        "intermediate" => "bg-yellow-500/10 text-yellow-400 border-yellow-500/20",
        "basic" => "bg-orange-500/10 text-orange-400 border-orange-500/20"
      }.freeze

      DEFAULT_PROFICIENCY_COLOR = "bg-white/5 text-text-muted border-white/10"

      def initialize(educations:, certifications:, volunteerings:, languages:)
        @educations = educations
        @certifications = certifications
        @volunteerings = volunteerings
        @languages = languages
      end

      def view_template
        section(
          id: "education",
          class: "py-20 px-6 md:px-12 lg:px-24",
          data: { controller: "scroll-animation" }
        ) do
          div(class: "max-w-4xl mx-auto") do
            render_section_title
            render_education_subsection
            render_certifications_subsection
            render_volunteering_subsection
            render_languages_subsection
          end
        end
      end

      private

      def render_section_title
        h2(class: "text-3xl md:text-4xl font-bold text-white mb-12") do
          plain _("Education")
          span(class: "text-accent-green") { "." }
        end
      end

      # --- Education ---

      def render_education_subsection
        return unless @educations.present?

        div(class: "mb-16") do
          h3(class: "text-xl font-semibold text-white mb-6 flex items-center gap-2") do
            span(class: "text-accent-green") { "⎯" }
            plain _("Academic")
          end

          div(class: "space-y-8") do
            @educations.each { |edu| render_education_card(edu) }
          end
        end
      end

      def render_education_card(education)
        div(
          class: "p-6 rounded-xl border border-white/5 bg-white/[0.02] " \
                 "hover:bg-white/5 hover:border-white/10 transition-all duration-300"
        ) do
          div(class: "flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1 mb-3") do
            div do
              h4(class: "text-lg font-bold text-white") { education.institution }
              p(class: "text-accent-green font-medium") { education.degree }
              p(class: "text-sm text-text-muted") { education.course }
            end

            span(class: "text-sm text-text-muted whitespace-nowrap") do
              plain format_period(education.started_at, education.ended_at)
            end
          end

          activities = education.activities
          return unless activities.present?

          ul(class: "space-y-1.5 mt-4 pt-4 border-t border-white/5") do
            activities.each do |activity|
              li(class: "flex items-start gap-2 text-sm text-text-muted") do
                span(class: "text-accent-green mt-1 shrink-0") { "▹" }
                span { activity }
              end
            end
          end
        end
      end

      # --- Certifications ---

      def render_certifications_subsection
        return unless @certifications.present?

        div(class: "mb-16") do
          h3(class: "text-xl font-semibold text-white mb-6 flex items-center gap-2") do
            span(class: "text-accent-green") { "⎯" }
            plain _("Certifications")
          end

          div(class: "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4") do
            @certifications.each { |cert| render_certification_card(cert) }
          end
        end
      end

      def render_certification_card(certification)
        tag = certification.url.present? ? :a : :div
        attrs = {
          class: "p-4 rounded-xl border border-white/5 bg-white/[0.02] " \
                 "hover:bg-white/5 hover:border-white/10 transition-all duration-300 block"
        }

        if certification.url.present?
          attrs[:href] = certification.url
          attrs[:target] = "_blank"
          attrs[:rel] = "noopener noreferrer"
        end

        send(tag, **attrs) do
          p(class: "font-semibold text-white text-sm mb-1") { certification.name }
          p(class: "text-xs text-text-muted mb-2") { certification.provider }
          p(class: "text-xs text-accent-green") { format_date(certification.certified_at) }
        end
      end

      # --- Volunteering ---

      def render_volunteering_subsection
        return unless @volunteerings.present?

        div(class: "mb-16") do
          h3(class: "text-xl font-semibold text-white mb-6 flex items-center gap-2") do
            span(class: "text-accent-green") { "⎯" }
            plain _("Volunteering")
          end

          div(class: "space-y-4") do
            @volunteerings.each { |vol| render_volunteering_item(vol) }
          end
        end
      end

      def render_volunteering_item(volunteering)
        div(
          class: "flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1 " \
                 "p-4 rounded-xl border border-white/5 bg-white/[0.02] " \
                 "hover:bg-white/5 hover:border-white/10 transition-all duration-300"
        ) do
          div do
            p(class: "font-semibold text-white") { volunteering.role }
            p(class: "text-sm text-text-muted") { volunteering.organization }
          end

          span(class: "text-sm text-text-muted whitespace-nowrap") do
            plain format_period(volunteering.started_at, volunteering.ended_at)
          end
        end
      end

      # --- Languages ---

      def render_languages_subsection
        return unless @languages.present?

        div do
          h3(class: "text-xl font-semibold text-white mb-6 flex items-center gap-2") do
            span(class: "text-accent-green") { "⎯" }
            plain _("Languages")
          end

          div(class: "flex flex-wrap gap-3") do
            @languages.each { |lang| render_language_badge(lang) }
          end
        end
      end

      def render_language_badge(language)
        color_class = PROFICIENCY_COLORS.fetch(language.proficiency, DEFAULT_PROFICIENCY_COLOR)

        span(
          class: "inline-flex items-center gap-2 px-4 py-2 rounded-full border font-medium text-sm #{color_class}"
        ) do
          span(class: "font-semibold") { language.name }
          span(class: "opacity-60") { "·" }
          span(class: "text-xs opacity-80") { language.level }
        end
      end

      # --- Helpers ---

      def format_period(started_at, ended_at)
        start_str = format_date(started_at)
        end_str = ended_at.present? ? format_date(ended_at) : _("Present")
        "#{start_str} - #{end_str}"
      end

      def format_date(date)
        month_abbrevs = I18n.locale == :en ? MONTH_ABBREVS_EN : MONTH_ABBREVS_PT
        "#{month_abbrevs[date.month - 1]} #{date.year}"
      end
    end
  end
end
