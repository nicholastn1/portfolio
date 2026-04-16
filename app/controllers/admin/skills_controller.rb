module Admin
  class SkillsController < BaseController
    before_action :set_skill, only: %i[edit update destroy]

    CATEGORIES = %w[backend frontend database devops cloud architecture methodology design documentation].freeze
    PROFICIENCIES = %w[proficient intermediate beginner].freeze

    def index
      @pagy, @skills = pagy(Skill.order(:position))
    end

    def new
      @skill = Skill.new
    end

    def create
      @skill = Skill.new(skill_params)

      if @skill.save
        redirect_to admin_skills_path, notice: "Skill criada com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @skill.update(skill_params)
        redirect_to admin_skills_path, notice: "Skill atualizada com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @skill.destroy
      redirect_to admin_skills_path, notice: "Skill removida com sucesso."
    end

    private

    def set_skill
      @skill = Skill.find(params[:id])
    end

    def skill_params
      params.require(:skill).permit(:name, :category, :proficiency, :featured, :position)
    end
  end
end
