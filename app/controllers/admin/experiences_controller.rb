module Admin
  class ExperiencesController < BaseController
    before_action :set_experience, only: %i[edit update destroy]

    def index
      @pagy, @experiences = pagy(Experience.all, limit: 20)
    end

    def new
      @experience = Experience.new
    end

    def create
      @experience = Experience.new(experience_params)

      if @experience.save
        redirect_to admin_experiences_path, notice: "Experience created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @experience.update(experience_params)
        redirect_to admin_experiences_path, notice: "Experience updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @experience.destroy
      redirect_to admin_experiences_path, notice: "Experience deleted successfully."
    end

    private

    def set_experience
      @experience = Experience.find(params[:id])
    end

    def experience_params
      params.require(:experience).permit(
        :company, :role_pt, :role_en, :company_url, :started_at, :ended_at,
        :description_pt, :description_en, :achievements_pt, :achievements_en,
        :technologies, :position
      ).tap do |p|
        p[:achievements_pt] = p[:achievements_pt]&.split("\n")&.map(&:strip)&.reject(&:blank?) if p[:achievements_pt].is_a?(String)
        p[:achievements_en] = p[:achievements_en]&.split("\n")&.map(&:strip)&.reject(&:blank?) if p[:achievements_en].is_a?(String)
        p[:technologies] = p[:technologies]&.split(",")&.map(&:strip)&.reject(&:blank?) if p[:technologies].is_a?(String)
      end
    end
  end
end
