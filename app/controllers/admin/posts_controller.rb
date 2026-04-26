module Admin
  class PostsController < BaseController
    before_action :set_post, only: %i[edit update destroy]

    def index
      @pagy, @posts = pagy(Post.order(created_at: :desc))
    end

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)
      @post.user = current_admin

      if @post.save
        redirect_to admin_posts_path, notice: "Post criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @post.update(post_params)
        redirect_to admin_posts_path, notice: "Post atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: "Post removido com sucesso."
    end

    private

    def set_post
      # Post#to_param returns the slug, so admin URLs like /admin/posts/hello-world/edit
      # need to look up by slug, not by numeric id.
      @post = Post.find_by!(slug: params[:id])
    end

    def post_params
      permitted = params.require(:post).permit(
        :title_pt, :title_en, :description_pt, :description_en,
        :slug, :category, :published, :published_at, :locale,
        :body, :cover_image, :tags
      )

      permitted[:tags] = permitted[:tags].split(",").map(&:strip) if permitted[:tags].is_a?(String)

      permitted
    end
  end
end
