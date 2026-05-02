module Components
  module Blog
    class PostCard < Components::Base
      include Phlex::Rails::Helpers::ImageTag

      def initialize(post:)
        @post = post
      end

      def view_template
        a(
          href: post_path(@post),
          class: "group block py-7 first:pt-0 border-b border-rule last:border-b-0"
        ) do
          div(class: "grid grid-cols-12 gap-x-6 items-start") do
            render_thumbnail
            render_body
          end
        end
      end

      private

      def render_thumbnail
        div(class: "col-span-12 md:col-span-3") do
          if @post.cover_image.attached?
            div(class: "border border-rule overflow-hidden aspect-[4/3] bg-paper-deep") do
              image_tag(
                @post.cover_image,
                alt: @post.title,
                loading: "lazy",
                class: "w-full h-full object-cover transition-transform duration-700 group-hover:scale-[1.02]"
              )
            end
          else
            div(class: "border border-rule aspect-[4/3] bg-paper-deep flex items-center justify-center") do
              span(class: "mono-id text-signal/60 text-[0.95rem]") { plain "NOTE" }
            end
          end
        end
      end

      def render_body
        div(class: "col-span-12 md:col-span-9 mt-3 md:mt-0") do
          render_meta
          render_title
          render_description if @post.description.present?
          render_footer
        end
      end

      def render_meta
        div(class: "flex items-center gap-3 mono-id text-ink-mute mb-2 flex-wrap") do
          if @post.category.present?
            span(class: "text-signal") { plain @post.category.to_s.upcase }
          end
          if @post.published_at.present?
            span(class: "text-rule") { plain "/" }
            span { plain @post.published_at.strftime("%Y-%m-%d") }
          end
          if @post.reading_time
            span(class: "text-rule") { plain "/" }
            span { plain "#{@post.reading_time} min" }
          end
        end
      end

      def render_title
        h3(
          class: "font-display text-ink text-[1.4rem] md:text-[1.6rem] leading-[1.15] mb-3 " \
                 "group-hover:text-signal transition-colors duration-200",
          style: "font-variation-settings: 'wdth' 100, 'opsz' 32; font-weight: 600;"
        ) do
          plain @post.title
        end
      end

      def render_description
        p(
          class: "text-ink-soft text-[0.95rem] leading-[1.55] max-w-[60ch] mb-3 line-clamp-2"
        ) do
          plain @post.description
        end
      end

      def render_footer
        div(class: "flex items-baseline justify-between gap-4 flex-wrap") do
          if @post.tags.present?
            div(class: "flex flex-wrap gap-1.5") do
              @post.tags.first(4).each do |tag|
                span(class: "chip text-[0.65rem]") { plain tag.to_s }
              end
            end
          end
          span(class: "mono-id text-signal group-hover:translate-x-0.5 transition-transform inline-flex items-center gap-1") do
            plain _("Read")
            span { plain "→" }
          end
        end
      end
    end
  end
end
