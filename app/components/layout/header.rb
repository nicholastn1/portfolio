module Components
  module Layout
    class Header < Components::Base
      def initialize(personal_info:)
        @personal_info = personal_info
      end

      def view_template
        header(
          class: "fixed top-0 left-0 right-0 z-50 bg-bg-dark/80 backdrop-blur-md border-b border-white/5",
          data: { controller: "mobile-menu" }
        ) do
          div(class: "max-w-[1200px] mx-auto px-6 py-4 flex items-center justify-between") do
            # Logo
            a(href: "/", class: "text-lg font-bold text-white hover:text-accent-green transition-colors") do
              plain "nicholas"
              span(class: "text-accent-green") { "." }
            end

            # Desktop nav
            nav(class: "hidden md:flex items-center gap-6") do
              nav_links
              div(class: "flex items-center gap-3 ml-4") do
                render Components::Ui::ThemeToggle.new
              end
            end

            # Mobile menu button
            button(
              class: "md:hidden text-white p-2",
              data: { action: "mobile-menu#toggle", mobile_menu_target: "button" },
              aria_label: "Menu"
            ) do
              svg(xmlns: "http://www.w3.org/2000/svg", class: "w-6 h-6", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor", stroke_width: "2") do |s|
                s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M4 6h16M4 12h16M4 18h16")
              end
            end
          end

          # Mobile menu
          div(
            class: "md:hidden hidden bg-bg-dark/95 backdrop-blur-md border-t border-white/5",
            data: { mobile_menu_target: "menu" }
          ) do
            nav(class: "flex flex-col gap-4 p-6") do
              nav_links(mobile: true)
              div(class: "flex items-center gap-3 pt-4 border-t border-white/10") do
                render Components::Ui::ThemeToggle.new
              end
            end
          end
        end
      end

      private

      def nav_links(mobile: false)
        link_class = mobile ? "text-text-muted hover:text-white transition-colors text-sm" : "text-text-muted hover:text-white transition-colors text-sm"

        [
          ["#about", "Sobre"],
          ["#experience", "Experiência"],
          ["#education", "Formação"],
          ["#skills", "Skills"],
          ["#projects", "Projetos"],
          ["/blog", "Blog"]
        ].each do |href, label|
          a(href: href, class: link_class) { label }
        end
      end
    end
  end
end
