module Admin
  class EducationsController < BaseController
    before_action :set_education, only: %i[edit update destroy]

    def index
      @pagy, @educations = pagy(Education.all, limit: 20)
    end

    def new
      @education = Education.new
    end

    def create
      @education = Education.new(education_params)

      if @education.save
        redirect_to admin_educations_path, notice: "Education created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @education.update(education_params)
        redirect_to admin_educations_path, notice: "Education updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @education.destroy
      redirect_to admin_educations_path, notice: "Education deleted successfully."
    end

    private

    def set_education
      @education = Education.find(params[:id])
    end

    def education_params
      params.require(:education).permit(
        :institution, :degree_pt, :degree_en, :course_pt, :course_en,
        :started_at, :ended_at, :activities_pt, :activities_en, :position
      ).tap do |p|
        p[:activities_pt] = p[:activities_pt]&.split("\n")&.map(&:strip)&.reject(&:blank?) if p[:activities_pt].is_a?(String)
        p[:activities_en] = p[:activities_en]&.split("\n")&.map(&:strip)&.reject(&:blank?) if p[:activities_en].is_a?(String)
      end
    end
  end
end
