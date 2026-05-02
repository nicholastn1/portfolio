# frozen_string_literal: true

class Components::Sections::SkillsSection < Components::Base
  def initialize(skills:)
    @skills = skills
    @featured_skills = skills.select(&:featured)
    @grouped_skills = skills.group_by(&:category)
  end

  def view_template
    section(
      id: "skills",
      class: "relative py-20 md:py-24",
      data: { controller: "scroll-animation" }
    ) do
      div(class: "max-w-[1200px] mx-auto px-6 md:px-10") do
        render_header
        render_featured if @featured_skills.any?
        render_taxonomy
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
        div(class: "section-id mb-2") { plain "§04" }
        h2(
          class: "font-display text-ink display-wide leading-none",
          style: "font-size: clamp(2.25rem, 4.8vw, 3.5rem); font-weight: 600;"
        ) { plain _("Stack") }
      end
      span(class: "mono-id text-ink-mute") do
        plain "#{@skills.length.to_s.rjust(2, '0')} / #{_('tools')}"
      end
    end
  end

  def render_featured
    div(
      class: "grid grid-cols-12 gap-x-6 mb-12 pb-10 border-b border-rule",
      data: { scroll_animation_target: "element" }
    ) do
      div(class: "col-span-12 md:col-span-3 mb-3 md:mb-0") do
        div(class: "section-id mb-1") { plain "PRIMARY" }
        h3(
          class: "font-display text-ink text-[1.15rem]",
          style: "font-weight: 600;"
        ) { plain _("Daily drivers") }
      end

      div(class: "col-span-12 md:col-span-9") do
        div(class: "flex flex-wrap gap-2") do
          @featured_skills.each do |skill|
            span(class: "chip chip-strong text-[0.75rem] px-3 py-1.5") { plain skill.name.to_s.downcase }
          end
        end
      end
    end
  end

  def render_taxonomy
    div(
      class: "grid grid-cols-12 gap-x-6",
      data: { scroll_animation_target: "element" }
    ) do
      div(class: "col-span-12 md:col-span-3 mb-3 md:mb-0") do
        div(class: "section-id mb-1") { plain "FULL" }
        h3(
          class: "font-display text-ink text-[1.15rem]",
          style: "font-weight: 600;"
        ) { plain _("By category") }
      end

      div(class: "col-span-12 md:col-span-9 divide-y divide-rule") do
        @grouped_skills.sort_by { |cat, _| cat.to_s }.each do |category, skills|
          render_category_row(category, skills)
        end
      end
    end
  end

  def render_category_row(category, skills)
    sorted = skills.sort_by { |s| s.name.to_s.downcase }
    div(class: "py-5 first:pt-0 last:pb-0 grid grid-cols-12 gap-x-4 items-baseline") do
      div(class: "col-span-12 sm:col-span-3 mb-2 sm:mb-0") do
        div(class: "section-id mb-0.5") { plain category.to_s.upcase }
        div(class: "mono-data text-ink-mute") { plain "(#{sorted.length})" }
      end

      div(class: "col-span-12 sm:col-span-9") do
        div(class: "flex flex-wrap gap-1.5") do
          sorted.each do |skill|
            span(class: "chip") { plain skill.name.to_s.downcase }
          end
        end
      end
    end
  end
end
