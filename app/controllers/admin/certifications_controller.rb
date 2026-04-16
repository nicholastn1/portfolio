module Admin
  class CertificationsController < BaseController
    before_action :set_certification, only: %i[edit update destroy]

    def index
      @pagy, @certifications = pagy(Certification.all, limit: 20)
    end

    def new
      @certification = Certification.new
    end

    def create
      @certification = Certification.new(certification_params)

      if @certification.save
        redirect_to admin_certifications_path, notice: "Certification created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @certification.update(certification_params)
        redirect_to admin_certifications_path, notice: "Certification updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @certification.destroy
      redirect_to admin_certifications_path, notice: "Certification deleted successfully."
    end

    private

    def set_certification
      @certification = Certification.find(params[:id])
    end

    def certification_params
      params.require(:certification).permit(
        :name_pt, :name_en, :provider, :certified_at, :url, :position
      )
    end
  end
end
