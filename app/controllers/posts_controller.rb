class PostsController < ApplicationController
  def index
    @posts = Post.published.recent
    @posts = @posts.by_category(params[:category]) if params[:category].present?
    @pagy, @posts = pagy(@posts, limit: 9)
  end

  def show
    @post = Post.published.find_by!(slug: params[:id])
  end
end
