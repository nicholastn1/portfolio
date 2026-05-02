# frozen_string_literal: true

class Components::Sections::AboutSection < Components::Base
  def initialize(personal_info:)
    @personal_info = personal_info
  end

  def view_template
    section(
      id: "about",
      class: "relative py-20 md:py-24",
      data: { controller: "scroll-animation" }
    ) do
      div(class: "max-w-[1200px] mx-auto px-6 md:px-10") do
        render_header
        div(class: "grid grid-cols-12 gap-x-6 gap-y-10") do
          render_portrait
          render_body
        end
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
        div(class: "section-id mb-2") { plain "§01" }
        h2(
          class: "font-display text-ink display-wide leading-none",
          style: "font-size: clamp(2.25rem, 4.8vw, 3.5rem); font-weight: 600;"
        ) { plain _("Profile") }
      end
      span(class: "mono-id text-ink-mute") { plain _("About / bio") }
    end
  end

  def render_portrait
    div(class: "col-span-12 md:col-span-4", data: { scroll_animation_target: "element" }) do
      figure(class: "md:sticky md:top-28") do
        div(class: "border border-rule bg-paper") do
          if @personal_info.respond_to?(:profile_image) && @personal_info.profile_image.attached?
            img(
              src: rails_blob_url(@personal_info.profile_image),
              alt: "#{@personal_info.name} — #{_('portrait')}",
              class: "sketch-on-paper block w-full aspect-[4/5] object-cover",
              loading: "lazy"
            )
          else
            div(class: "w-full aspect-[4/5] bg-paper flex items-center justify-center") do
              span(
                class: "font-display text-signal/50 text-[5rem] font-bold",
                style: "font-variation-settings: 'wdth' 90, 'opsz' 96;"
              ) { plain initials }
            end
          end
        end

        figcaption(class: "mt-3 flex items-center justify-between gap-3 mono-id text-ink-mute") do
          span { plain "Fig. 01 / Portrait" }
          span(class: "text-rule") { plain "·" }
          span { plain Time.current.year.to_s }
        end
      end
    end
  end

  def render_body
    div(class: "col-span-12 md:col-span-8 lg:col-span-7 lg:col-start-6", data: { scroll_animation_target: "element" }) do
      paragraphs = bio_paragraphs

      if paragraphs.empty?
        p(class: "font-display text-ink-mute") { plain _("Bio forthcoming.") }
        return
      end

      # First paragraph — slightly larger, no drop cap
      p(
        class: "font-display text-ink text-[1.15rem] md:text-[1.25rem] leading-[1.5] mb-5 max-w-[60ch]",
        style: "font-variation-settings: 'wdth' 100, 'opsz' 32; font-weight: 400;"
      ) do
        plain paragraphs.first
      end

      # Remaining paragraphs — body
      paragraphs.drop(1).each do |paragraph|
        p(
          class: "text-ink-soft text-[1rem] leading-[1.65] mb-4 max-w-[60ch]",
          style: "font-variation-settings: 'wdth' 100, 'opsz' 14;"
        ) do
          plain paragraph
        end
      end
    end
  end

  def bio_paragraphs
    if @personal_info.respond_to?(:bio)
      Array(@personal_info.bio).reject(&:blank?)
    else
      []
    end
  end

  def initials
    @personal_info.name.to_s.split.map { |word| word[0] }.join.upcase.first(2)
  end
end
