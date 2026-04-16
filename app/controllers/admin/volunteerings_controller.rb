module Admin
  class VolunteeringsController < BaseController
    before_action :set_volunteering, only: %i[edit update destroy]

    def index
      @pagy, @volunteerings = pagy(Volunteering.all, limit: 20)
    end

    def new
      @volunteering = Volunteering.new
    end

    def create
      @volunteering = Volunteering.new(volunteering_params)

      if @volunteering.save
        redirect_to admin_volunteerings_path, notice: "Volunteering created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @volunteering.update(volunteering_params)
        redirect_to admin_volunteerings_path, notice: "Volunteering updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @volunteering.destroy
      redirect_to admin_volunteerings_path, notice: "Volunteering deleted successfully."
    end

    private

    def set_volunteering
      @volunteering = Volunteering.find(params[:id])
    end

    def volunteering_params
      params.require(:volunteering).permit(
        :role_pt, :role_en, :organization, :started_at, :ended_at, :position
      )
    end
  end
end
