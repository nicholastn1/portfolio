module Admin
  class PersonalInfosController < BaseController
    before_action :set_personal_info

    def show; end

    def edit; end

    def update
      if @personal_info.update(personal_info_params)
        redirect_to admin_personal_info_path, notice: "Informações pessoais atualizadas com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_personal_info
      @personal_info = PersonalInfo.instance
    end

    def personal_info_params
      permitted = params.require(:personal_info).permit(
        :name, :title, :location, :email, :phone, :whatsapp_message,
        :bio_pt, :bio_en, :tagline_pt, :tagline_en,
        :footer_text_pt, :footer_text_en, :profile_image
      )

      permitted[:bio_pt] = permitted[:bio_pt].split("\n").map(&:strip).reject(&:blank?) if permitted[:bio_pt].is_a?(String)
      permitted[:bio_en] = permitted[:bio_en].split("\n").map(&:strip).reject(&:blank?) if permitted[:bio_en].is_a?(String)

      permitted
    end
  end
end
