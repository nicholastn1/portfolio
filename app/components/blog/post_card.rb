module Components
  module Blog
    class PostCard < Components::Base
      def initialize(post:)
        @post = post
      end

      def view_template
        a(
          href: helpers.post_path(@post),
          class: "group block bg-white/[0.02] border border-white/5 rounded-xl overflow-hidden hover:border-accent-green/30 hover:bg-white/5 transition-all"
        ) do
          render_cover_image if @post.cover_image.attached?

          div(class: "p-6") do
            render_meta
            render_title
            render_description if @post.description.present?
            render_footer
          end
        end
      end

      private

      def render_cover_image
        div(class: "aspect-[16/9] overflow-hidden bg-white/5") do
          raw helpers.image_tag(
            @post.cover_image,
            alt: @post.title,
            loading: "lazy",
            class: "w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
          )
        end
      end

      def render_meta
        div(class: "flex items-center gap-3 mb-4") do
          span(class: "px-2.5 py-1 rounded-full bg-accent-green/10 text-accent-green text-xs font-medium") do
            @post.category&.capitalize
          end
          if @post.reading_time
            span(class: "text-text-muted text-xs") { "#{@post.reading_time} min" }
          end
        end
      end

      def render_title
        h3(class: "text-lg font-semibold text-white mb-2 group-hover:text-accent-green transition-colors") do
          @post.title
        end
      end

      def render_description
        p(class: "text-text-muted text-sm leading-relaxed mb-4 line-clamp-3") do
          @post.description
        end
      end

      def render_footer
        div(class: "flex items-center justify-between mt-auto") do
          span(class: "text-text-muted text-xs") do
            @post.published_at&.strftime("%d/%m/%Y")
          end
          if @post.tags.present?
            div(class: "flex gap-1.5") do
              @post.tags.first(3).each do |tag|
                span(class: "text-text-muted text-[10px]") { "##{tag}" }
              end
            end
          end
        end
      end
    end
  end
end
