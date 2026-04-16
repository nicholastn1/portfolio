module Components
  module Ui
    class Badge < Components::Base
      CATEGORY_COLORS = {
        "backend" => "bg-blue-500/10 text-blue-400 border-blue-500/20",
        "frontend" => "bg-purple-500/10 text-purple-400 border-purple-500/20",
        "database" => "bg-green-500/10 text-green-400 border-green-500/20",
        "devops" => "bg-orange-500/10 text-orange-400 border-orange-500/20",
        "cloud" => "bg-cyan-500/10 text-cyan-400 border-cyan-500/20",
        "architecture" => "bg-red-500/10 text-red-400 border-red-500/20",
        "methodology" => "bg-yellow-500/10 text-yellow-400 border-yellow-500/20",
        "design" => "bg-pink-500/10 text-pink-400 border-pink-500/20",
        "documentation" => "bg-gray-500/10 text-gray-400 border-gray-500/20"
      }.freeze

      DEFAULT_COLOR = "bg-white/5 text-text-muted border-white/10"

      def initialize(text:, category: nil, size: :sm)
        @text = text
        @category = category
        @size = size
      end

      def view_template
        color_class = @category ? CATEGORY_COLORS.fetch(@category, DEFAULT_COLOR) : DEFAULT_COLOR
        size_class = @size == :xs ? "px-2 py-0.5 text-[10px]" : "px-3 py-1 text-xs"

        span(class: "inline-flex items-center rounded-full border font-medium #{color_class} #{size_class}") do
          @text
        end
      end
    end
  end
end
