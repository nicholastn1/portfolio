module Components
  module Layout
    class Header < Components::Base
      include Phlex::Rails::Helpers::ImageTag

      def initialize(personal_info:)
        @personal_info = personal_info
      end

      def view_template
        header(
          class: "sticky top-0 z-50 backdrop-blur-md bg-paper/85 border-b border-rule",
          data: { controller: "mobile-menu" },
          style: "-webkit-backdrop-filter: blur(12px);"
        ) do
          div(class: "max-w-[1200px] mx-auto px-6 md:px-10") do
            div(class: "flex items-center justify-between gap-6 py-4") do
              render_brand
              render_desktop_nav
              render_mobile_button
            end
          end
          render_mobile_menu
        end
      end

      private

      # Brand: NN logo mark (SVG) + name + status indicator
      def render_brand
        a(href: "/", class: "group flex items-center gap-3 leading-none") do
          image_tag(
            "logo-mark.svg",
            alt: "NN — Nicholas Nogueira",
            class: "block w-9 h-9 shrink-0",
            width: 36,
            height: 36
          )

          div(class: "flex flex-col gap-1") do
            span(
              class: "font-display text-ink text-[0.95rem] font-semibold leading-none group-hover:text-signal transition-colors duration-200",
              style: "font-variation-settings: 'wdth' 100, 'opsz' 14;"
            ) { plain "Nicholas Nogueira" }
            span(class: "mono-id text-ink-mute leading-none flex items-center gap-1.5") do
              span(class: "status-dot")
              plain _("available")
            end
          end
        end
      end

      def render_desktop_nav
        nav(class: "hidden md:flex items-center gap-7") do
          desktop_links
          div(class: "flex items-center gap-3 pl-4 ml-2 border-l border-rule") do
            render Components::Ui::LanguageSwitcher.new
            render Components::Ui::ThemeToggle.new
          end
        end
      end

      def desktop_links
        nav_items.each_with_index do |(href, label), i|
          a(
            href: href,
            class: "mono-id text-ink-mute hover:text-ink transition-colors duration-200 " \
                   "inline-flex items-baseline gap-1.5 group/link"
          ) do
            span(class: "text-signal/70 group-hover/link:text-signal transition-colors") do
              plain "§#{(i + 1).to_s.rjust(2, '0')}"
            end
            span { plain label }
          end
        end
      end

      def render_mobile_button
        button(
          class: "md:hidden mono-id text-ink hover:text-signal transition-colors p-2 -mr-2",
          data: { action: "mobile-menu#toggle", mobile_menu_target: "button" },
          aria_label: "Menu"
        ) do
          plain "Menu"
        end
      end

      def render_mobile_menu
        div(
          class: "md:hidden hidden border-t border-rule bg-paper",
          data: { mobile_menu_target: "menu" }
        ) do
          nav(class: "flex flex-col px-6 py-4 divide-y divide-rule") do
            nav_items.each_with_index do |(href, label), i|
              a(
                href: href,
                class: "py-3 flex items-center justify-between hover:text-signal transition-colors group/link"
              ) do
                div(class: "flex items-baseline gap-3") do
                  span(class: "mono-id text-signal/70") { plain "§#{(i + 1).to_s.rjust(2, '0')}" }
                  span(class: "font-display text-ink text-[0.95rem]") { plain label }
                end
                span(class: "mono-id text-ink-mute group-hover/link:text-signal") { plain "→" }
              end
            end
            div(class: "flex items-center gap-4 pt-4 mt-2 border-t border-rule") do
              render Components::Ui::LanguageSwitcher.new
              render Components::Ui::ThemeToggle.new
            end
          end
        end
      end

      def nav_items
        [
          [ "#about",      _("Profile") ],
          [ "#experience", _("Experience") ],
          [ "#education",  _("Education") ],
          [ "#skills",     _("Stack") ],
          [ "#projects",   _("Work") ],
          [ "/blog",       _("Blog") ]
        ]
      end
    end
  end
end
