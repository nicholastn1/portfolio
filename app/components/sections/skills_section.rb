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
      class: "py-20 sm:py-28 bg-bg-dark",
      data: { controller: "scroll-animation" }
    ) do
      div(class: "max-w-[1200px] mx-auto px-6") do
        render_heading
        render_featured_skills if @featured_skills.any?
        render_skills_by_category
      end
    end
  end

  private

  def render_heading
    div(class: "mb-12") do
      h2(class: "text-3xl sm:text-4xl font-bold text-white") do
        plain "Skills"
        span(class: "text-accent-green") { "." }
      end
    end
  end

  def render_featured_skills
    div(class: "mb-14") do
      div(class: "flex items-center gap-2 mb-5") do
        span(class: "text-accent-green text-sm") { star_icon }
        h3(class: "text-lg font-semibold text-white") { "Destaques" }
      end

      div(class: "flex flex-wrap gap-3") do
        @featured_skills.each do |skill|
          div(class: "relative group") do
            render Components::Ui::Badge.new(
              text: skill.name,
              category: skill.category,
              size: :sm
            )
          end
        end
      end
    end
  end

  def render_skills_by_category
    div(class: "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8") do
      @grouped_skills.each do |category, skills|
        render_category_group(category, skills)
      end
    end
  end

  def render_category_group(category, skills)
    div(
      class: "rounded-xl bg-white/5 border border-white/5 p-5 " \
             "hover:border-accent-green/30 transition-colors duration-300"
    ) do
      h3(class: "text-sm font-semibold text-text-muted uppercase tracking-wider mb-4") do
        plain category.capitalize
      end

      div(class: "flex flex-wrap gap-2") do
        skills.each do |skill|
          render Components::Ui::Badge.new(
            text: skill.name,
            category: skill.category,
            size: :xs
          )
        end
      end
    end
  end

  def star_icon
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      class: "w-4 h-4",
      fill: "currentColor",
      viewBox: "0 0 20 20"
    ) do |s|
      s.path(
        d: "M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 " \
           "1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 " \
           "1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 " \
           "1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
      )
    end
  end
end
