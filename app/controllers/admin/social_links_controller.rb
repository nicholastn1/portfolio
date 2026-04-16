module Admin
  class SocialLinksController < BaseController
    before_action :set_social_link, only: %i[edit update destroy]

    def index
      @pagy, @social_links = pagy(SocialLink.order(:position))
    end

    def new
      @social_link = SocialLink.new
    end

    def create
      @social_link = SocialLink.new(social_link_params)
      @social_link.personal_info = PersonalInfo.instance

      if @social_link.save
        redirect_to admin_social_links_path, notice: "Link social criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @social_link.update(social_link_params)
        redirect_to admin_social_links_path, notice: "Link social atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @social_link.destroy
      redirect_to admin_social_links_path, notice: "Link social removido com sucesso."
    end

    private

    def set_social_link
      @social_link = SocialLink.find(params[:id])
    end

    def social_link_params
      params.require(:social_link).permit(:platform, :url, :label, :icon, :position)
    end
  end
end
