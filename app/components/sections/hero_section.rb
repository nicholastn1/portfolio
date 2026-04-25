# frozen_string_literal: true

class Components::Sections::HeroSection < Components::Base
  def initialize(personal_info:)
    @personal_info = personal_info
  end

  def view_template
    section(
      id: "hero",
      class: "relative min-h-screen flex items-center justify-center bg-bg-dark overflow-hidden",
      data: { controller: "scroll-animation" }
    ) do
      # Animated grid background with dot pattern
      div(class: "absolute inset-0 opacity-20") do
        div(
          class: "absolute inset-0",
          style: "background-image: radial-gradient(circle, rgba(255,255,255,0.15) 1px, transparent 1px); background-size: 30px 30px;"
        )
      end

      # Main content
      div(class: "relative z-10 text-center px-4 sm:px-6 lg:px-8 max-w-4xl mx-auto") do
        render_name
        render_title
        render_social_links
        render_cta_buttons
      end
    end
  end

  private

  def render_name
    h1(class: "text-4xl sm:text-5xl md:text-6xl lg:text-7xl font-bold mb-4 tracking-tight") do
      span(class: "text-gradient-primary") { @personal_info.name }
    end
  end

  def render_title
    p(class: "text-lg sm:text-xl md:text-2xl text-text-muted mb-2") do
      plain @personal_info.title
    end

    if @personal_info.respond_to?(:location) && @personal_info.location.present?
      p(class: "text-sm sm:text-base text-text-muted mb-8") do
        span(class: "inline-flex items-center gap-1") do
          plain @personal_info.location
        end
      end
    end
  end

  def render_social_links
    return unless @personal_info.respond_to?(:social_links) && @personal_info.social_links.present?

    div(class: "flex flex-wrap justify-center gap-3 mb-10") do
      @personal_info.social_links.each do |link|
        a(
          href: link.url,
          target: "_blank",
          rel: "noopener noreferrer",
          class: "inline-flex items-center px-4 py-2 rounded-full text-sm font-medium " \
                 "bg-white/10 text-white hover:bg-accent-green hover:text-bg-dark " \
                 "transition-colors duration-200"
        ) do
          plain link.platform
        end
      end
    end
  end

  def render_cta_buttons
    div(class: "flex flex-col sm:flex-row items-center justify-center gap-4") do
      # "Ver Projetos" button
      a(
        href: "#projects",
        class: "inline-flex items-center px-8 py-3 rounded-lg text-base font-semibold " \
               "bg-gradient-primary text-bg-dark hover:opacity-90 transition-opacity duration-200"
      ) do
        plain _("View Projects")
      end

      # "Entrar em Contato" button (WhatsApp)
      a(
        href: whatsapp_url,
        target: "_blank",
        rel: "noopener noreferrer",
        class: "inline-flex items-center px-8 py-3 rounded-lg text-base font-semibold " \
               "border border-accent-green text-accent-green hover:bg-accent-green hover:text-bg-dark " \
               "transition-colors duration-200"
      ) do
        plain _("Get in Touch")
      end
    end
  end

  def whatsapp_url
    if @personal_info.respond_to?(:social_links)
      whatsapp_link = @personal_info.social_links.find { |l| l.platform.downcase == "whatsapp" }
      return whatsapp_link.url if whatsapp_link
    end

    "https://wa.me/"
  end
end
