module Components
  module Ui
    class LanguageSwitcher < Components::Base
      def view_template
        div(class: "flex items-center gap-1 text-xs", data: { controller: "language" }) do
          button(
            class: "px-2 py-1 rounded transition-all #{I18n.locale.to_s.start_with?('pt') ? 'text-white bg-white/10' : 'text-text-muted hover:text-white'}",
            data: { action: "language#switch", locale: "pt" }
          ) { "PT" }

          span(class: "text-white/20") { "|" }

          button(
            class: "px-2 py-1 rounded transition-all #{I18n.locale == :en ? 'text-white bg-white/10' : 'text-text-muted hover:text-white'}",
            data: { action: "language#switch", locale: "en" }
          ) { "EN" }
        end
      end
    end
  end
end
