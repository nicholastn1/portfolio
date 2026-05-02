# frozen_string_literal: true

module Components
  module Sections
    class EducationSection < Components::Base
      MONTH_ABBREVS_PT = %w[Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez].freeze
      MONTH_ABBREVS_EN = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

      PROFICIENCY_GLYPH = {
        "native"       => "●●●●●",
        "fluent"       => "●●●●○",
        "advanced"     => "●●●●○",
        "intermediate" => "●●●○○",
        "basic"        => "●●○○○"
      }.freeze

      def initialize(educations:, certifications:, volunteerings:, languages:)
        @educations = educations
        @certifications = certifications
        @volunteerings = volunteerings
        @languages = languages
      end

      def view_template
        section(
          id: "education",
          class: "relative py-20 md:py-24 bg-paper-deep/40",
          data: { controller: "scroll-animation" }
        ) do
          div(class: "max-w-[1200px] mx-auto px-6 md:px-10") do
            render_header
            render_block("ACADEMIC",      _("Academic"))      { render_education_list }
            render_block("CERTS",         _("Certifications")) { render_certifications_list } if @certifications.present?
            render_block("VOLUNTEERING",  _("Volunteering"))   { render_volunteering_list }   if @volunteerings.present?
            render_block("LANGUAGES",     _("Languages"))      { render_languages_list }      if @languages.present?
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
            div(class: "section-id mb-2") { plain "§03" }
            h2(
              class: "font-display text-ink display-wide leading-none",
              style: "font-size: clamp(2.25rem, 4.8vw, 3.5rem); font-weight: 600;"
            ) { plain _("Education") }
          end
          span(class: "mono-id text-ink-mute") { plain _("Formation / record") }
        end
      end

      def render_block(id, title, &block)
        div(class: "mb-12 grid grid-cols-12 gap-x-6", data: { scroll_animation_target: "element" }) do
          div(class: "col-span-12 md:col-span-3 mb-3 md:mb-0") do
            div(class: "section-id mb-1") { plain id }
            h3(
              class: "font-display text-ink text-[1.15rem] leading-tight",
              style: "font-variation-settings: 'wdth' 100, 'opsz' 14; font-weight: 600;"
            ) { plain title }
          end
          div(class: "col-span-12 md:col-span-9", &block)
        end
      end

      # --- Academic ---
      def render_education_list
        div(class: "divide-y divide-rule") do
          @educations.each { |edu| render_education_item(edu) }
        end
      end

      def render_education_item(education)
        div(class: "py-5 first:pt-0 last:pb-0") do
          div(class: "flex flex-col md:flex-row md:items-baseline md:justify-between gap-1 mb-1") do
            div do
              h4(
                class: "font-display text-ink text-[1.1rem] md:text-[1.25rem] leading-tight",
                style: "font-variation-settings: 'wdth' 100, 'opsz' 32; font-weight: 600;"
              ) { plain education.institution }
              p(class: "mono-data text-signal mt-1", style: "letter-spacing: 0.04em;") do
                plain "#{education.degree.to_s.upcase} · #{education.course}"
              end
            end
            span(class: "mono-data text-ink-mute whitespace-nowrap shrink-0") do
              plain format_period(education.started_at, education.ended_at)
            end
          end

          activities = education.activities
          if activities.present?
            ul(class: "mt-3 space-y-1.5 max-w-[60ch]") do
              activities.each do |activity|
                li(class: "flex items-baseline gap-2 text-ink-soft") do
                  span(class: "text-signal mono-id") { plain "→" }
                  span(class: "text-[0.95rem] leading-[1.55]") { plain activity }
                end
              end
            end
          end
        end
      end

      # --- Certifications: dense table-like grid ---
      def render_certifications_list
        div(class: "border-t border-rule") do
          @certifications.each_with_index do |cert, _i|
            tag = cert.url.present? ? :a : :div
            attrs = {
              class: "grid grid-cols-12 gap-x-4 py-3 border-b border-rule items-baseline group hover:bg-signal-soft transition-colors"
            }
            if cert.url.present?
              attrs[:href] = cert.url
              attrs[:target] = "_blank"
              attrs[:rel] = "noopener noreferrer"
            end

            send(tag, **attrs) do
              div(class: "col-span-12 sm:col-span-6") do
                span(
                  class: "font-display text-ink text-[1rem] group-hover:text-signal transition-colors",
                  style: "font-weight: 500;"
                ) { plain cert.name }
              end
              div(class: "col-span-6 sm:col-span-3 mono-data text-ink-mute") { plain cert.provider }
              div(class: "col-span-6 sm:col-span-3 mono-data text-ink-mute md:text-right") { plain format_date(cert.certified_at) }
            end
          end
        end
      end

      # --- Volunteering ---
      def render_volunteering_list
        div(class: "divide-y divide-rule") do
          @volunteerings.each do |vol|
            div(class: "flex flex-col sm:flex-row sm:items-baseline sm:justify-between gap-1 py-4 first:pt-0") do
              div do
                p(
                  class: "font-display text-ink text-[1.05rem]",
                  style: "font-weight: 500;"
                ) { plain vol.role }
                p(class: "mono-data text-ink-mute mt-0.5") { plain vol.organization }
              end
              span(class: "mono-data text-ink-mute shrink-0") do
                plain format_period(vol.started_at, vol.ended_at)
              end
            end
          end
        end
      end

      # --- Languages — flat row table ---
      def render_languages_list
        div(class: "border-t border-rule") do
          @languages.each do |lang|
            div(class: "grid grid-cols-12 gap-x-4 items-baseline py-3 border-b border-rule") do
              div(class: "col-span-6 sm:col-span-4") do
                span(
                  class: "font-display text-ink text-[1.05rem]",
                  style: "font-weight: 500;"
                ) { plain lang.name }
              end
              div(class: "col-span-6 sm:col-span-4 mono-data text-ink-mute") { plain lang.level }
              div(class: "col-span-12 sm:col-span-4 flex items-center gap-3 sm:justify-end") do
                span(class: "text-signal font-mono text-sm tracking-widest") do
                  plain PROFICIENCY_GLYPH.fetch(lang.proficiency, "●○○○○")
                end
                span(class: "mono-id text-ink-mute") { plain lang.proficiency }
              end
            end
          end
        end
      end

      # --- Helpers ---
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
