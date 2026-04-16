module Admin
  class LanguagesController < BaseController
    before_action :set_language, only: %i[edit update destroy]

    def index
      @pagy, @languages = pagy(Language.order(:position))
    end

    def new
      @language = Language.new
    end

    def create
      @language = Language.new(language_params)

      if @language.save
        redirect_to admin_languages_path, notice: "Idioma criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @language.update(language_params)
        redirect_to admin_languages_path, notice: "Idioma atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @language.destroy
      redirect_to admin_languages_path, notice: "Idioma removido com sucesso."
    end

    private

    def set_language
      @language = Language.find(params[:id])
    end

    def language_params
      params.require(:language).permit(:name_pt, :name_en, :level_pt, :level_en, :proficiency, :position)
    end
  end
end
