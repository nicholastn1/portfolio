module Components
  module Layout
    class Footer < Components::Base
      def initialize(personal_info:)
        @personal_info = personal_info
      end

      def view_template
        footer(class: "relative pt-16 pb-10 mt-20 border-t-2 border-ink") do
          div(class: "max-w-[1200px] mx-auto px-6 md:px-10") do
            render_header
            div(class: "grid grid-cols-12 gap-x-6 gap-y-10 mb-12") do
              render_left_block
              render_right_block
            end
            render_bottom_strip
          end
        end
      end

      private

      def render_header
        div(class: "flex items-end justify-between gap-4 pb-5 mb-10 border-b border-rule flex-wrap") do
          div do
            div(class: "section-id mb-2") { plain "§00" }
            h2(
              class: "font-display text-ink display-wide leading-none",
              style: "font-size: clamp(2rem, 4.5vw, 3rem); font-weight: 600;"
            ) { plain _("Get in touch") }
          end
          span(class: "mono-id text-ink-mute") { plain _("End of file") }
        end
      end

      def render_left_block
        div(class: "col-span-12 md:col-span-7") do
          if @personal_info.respond_to?(:footer_text) && @personal_info.footer_text.present?
            p(
              class: "font-display text-ink text-[1.15rem] md:text-[1.25rem] leading-[1.5] max-w-[52ch] mb-6",
              style: "font-variation-settings: 'wdth' 100, 'opsz' 32; font-weight: 400;"
            ) do
              plain @personal_info.footer_text
            end
          end

          # CTA bar
          div(class: "flex flex-wrap items-center gap-3 mt-6") do
            if @personal_info.email.present?
              a(
                href: "mailto:#{@personal_info.email}",
                class: "inline-flex items-center gap-2 px-4 py-2.5 bg-ink text-paper " \
                       "mono-id hover:bg-signal transition-colors"
              ) do
                plain _("Write me")
                span { plain "→" }
              end
            end
            whatsapp = @personal_info.social_links.find { |l| l.platform.to_s.downcase == "whatsapp" } if @personal_info.social_links.respond_to?(:find)
            if whatsapp
              a(
                href: whatsapp.url,
                target: "_blank",
                rel: "noopener noreferrer",
                class: "inline-flex items-center gap-2 px-4 py-2.5 border border-rule text-ink " \
                       "mono-id hover:border-ink hover:text-signal transition-colors"
              ) do
                plain "WhatsApp"
              end
            end
          end
        end
      end

      def render_right_block
        div(class: "col-span-12 md:col-span-5 lg:col-start-9 lg:col-span-4") do
          dl(class: "mb-8") do
            if @personal_info.email.present?
              spec_row(_("Email"), @personal_info.email, href: "mailto:#{@personal_info.email}")
            end
            if @personal_info.location.present?
              spec_row(_("Place"), @personal_info.location)
            end
            spec_row(_("Status"), _("Available"), highlight: true)
          end

          # Social row — exclude email (in spec rows above), whatsapp (CTA on left), instagram (personal)
          social = @personal_info.social_links.respond_to?(:reject) ?
                   @personal_info.social_links.reject { |l| %w[email whatsapp instagram].include?(l.platform.to_s.downcase) } :
                   []
          if social.present?
            div(class: "flex items-center gap-x-4 gap-y-2 flex-wrap") do
              social.each do |link|
                a(
                  href: link.url,
                  target: "_blank",
                  rel: "noopener noreferrer",
                  class: "mono-id text-ink-mute hover:text-signal transition-colors " \
                         "[&:not(:first-child)]:before:content-['/'] [&:not(:first-child)]:before:mr-4 " \
                         "[&:not(:first-child)]:before:text-rule [&:not(:first-child)]:before:font-normal",
                  aria_label: link.label
                ) { plain link.platform.to_s.downcase }
              end
            end
          end
        end
      end

      def spec_row(label, value, href: nil, highlight: false)
        div(class: "spec-row") do
          dt { plain label }
          dd do
            if highlight
              span(class: "inline-flex items-center gap-2") do
                span(class: "status-dot")
                plain value
              end
            elsif href
              a(href: href, class: "signal-link") { plain value }
            else
              plain value
            end
          end
        end
      end

      def render_bottom_strip
        div(class: "pt-6 border-t border-rule grid grid-cols-12 gap-x-4 gap-y-2 mono-id text-ink-mute") do
          div(class: "col-span-12 md:col-span-4") do
            plain "© #{Time.current.year} Nicholas Nogueira"
          end
          div(class: "col-span-6 md:col-span-4 md:text-center") do
            plain "Built with Ruby · Rails · Phlex"
          end
          div(class: "col-span-6 md:col-span-4 md:text-right flex items-center md:justify-end gap-2") do
            span(class: "status-dot")
            plain "v#{Time.current.strftime('%Y.%m')}"
          end
        end
      end
    end
  end
end
