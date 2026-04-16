# frozen_string_literal: true

class Components::Sections::AboutSection < Components::Base
  def initialize(personal_info:)
    @personal_info = personal_info
  end

  def view_template
    section(
      id: "about",
      class: "py-20 sm:py-28 bg-bg-dark",
      data: { controller: "scroll-animation" }
    ) do
      div(class: "max-w-6xl mx-auto px-4 sm:px-6 lg:px-8") do
        render_section_title
        render_content
      end
    end
  end

  private

  def render_section_title
    div(class: "mb-12 sm:mb-16", data: { scroll_animation_target: "element" }) do
      h2(class: "text-3xl sm:text-4xl md:text-5xl font-bold text-white") do
        plain "Sobre Mim"
        span(class: "text-accent-green") { plain "." }
      end
    end
  end

  def render_content
    div(
      class: "grid grid-cols-1 md:grid-cols-2 gap-10 md:gap-16 items-center",
      data: { scroll_animation_target: "element" }
    ) do
      render_profile_image
      render_bio
    end
  end

  def render_profile_image
    div(class: "flex justify-center md:justify-start") do
      div(class: "relative") do
        # Accent border wrapper
        div(
          class: "w-64 h-64 sm:w-72 sm:h-72 md:w-80 md:h-80 rounded-full " \
                 "border-2 border-accent-green p-1"
        ) do
          if @personal_info.respond_to?(:profile_image) && @personal_info.profile_image.attached?
            img(
              src: rails_blob_url(@personal_info.profile_image),
              alt: "#{@personal_info.name} - Profile",
              class: "w-full h-full rounded-full object-cover",
              loading: "lazy"
            )
          else
            # Placeholder when no image is attached
            div(
              class: "w-full h-full rounded-full bg-white/5 flex items-center justify-center"
            ) do
              span(class: "text-4xl text-text-muted") { plain initials }
            end
          end
        end
      end
    end
  end

  def render_bio
    div(class: "space-y-4 sm:space-y-5") do
      bio_paragraphs.each do |paragraph|
        p(class: "text-base sm:text-lg leading-relaxed text-text-muted") do
          plain paragraph
        end
      end
    end
  end

  def bio_paragraphs
    if @personal_info.respond_to?(:bio)
      Array(@personal_info.bio)
    else
      []
    end
  end

  def initials
    @personal_info.name.to_s.split.map { |word| word[0] }.join.upcase.first(2)
  end
end
