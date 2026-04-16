module Admin
  class ProjectsController < BaseController
    before_action :set_project, only: %i[edit update destroy]

    def index
      @pagy, @projects = pagy(Project.all, limit: 20)
    end

    def new
      @project = Project.new
    end

    def create
      @project = Project.new(project_params)

      if @project.save
        redirect_to admin_projects_path, notice: "Project created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @project.update(project_params)
        redirect_to admin_projects_path, notice: "Project updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @project.destroy
      redirect_to admin_projects_path, notice: "Project deleted successfully."
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(
        :name, :description_pt, :description_en, :started_at, :ended_at,
        :technologies, :url, :github_url, :image, :position
      ).tap do |p|
        p[:technologies] = p[:technologies]&.split(",")&.map(&:strip)&.reject(&:blank?) if p[:technologies].is_a?(String)
      end
    end
  end
end
