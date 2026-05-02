module Components
  module Ui
    class Badge < Components::Base
      def initialize(text:, category: nil, size: :sm)
        @text = text
        @category = category
        @size = size
      end

      def view_template
        size_class = @size == :xs ? "text-[0.65rem] px-1.5 py-0.5" : "text-[0.7rem] px-2 py-0.5"

        span(
          class: "inline-flex items-center font-mono uppercase tracking-[0.06em] " \
                 "border border-rule text-ink-soft bg-transparent #{size_class}"
        ) do
          plain @text
        end
      end
    end
  end
end
