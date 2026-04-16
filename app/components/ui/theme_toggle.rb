module Components
  module Ui
    class ThemeToggle < Components::Base
      def view_template
        button(
          class: "p-2 rounded-lg text-text-muted hover:text-white hover:bg-white/5 transition-all",
          data: { controller: "theme", action: "theme#toggle" },
          aria_label: "Toggle dark mode"
        ) do
          # Sun icon (shown in dark mode)
          svg(
            xmlns: "http://www.w3.org/2000/svg",
            class: "w-5 h-5 hidden dark:block",
            fill: "none",
            viewBox: "0 0 24 24",
            stroke: "currentColor",
            stroke_width: "2"
          ) do |s|
            s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z")
          end
          # Moon icon (shown in light mode)
          svg(
            xmlns: "http://www.w3.org/2000/svg",
            class: "w-5 h-5 block dark:hidden",
            fill: "none",
            viewBox: "0 0 24 24",
            stroke: "currentColor",
            stroke_width: "2"
          ) do |s|
            s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z")
          end
        end
      end
    end
  end
end
