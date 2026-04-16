module Admin
  class BaseController < ApplicationController
    before_action :authenticate_admin!
    layout "admin"

    private

    def authenticate_admin!
      unless current_admin
        redirect_to admin_login_path, alert: "Faça login para acessar o painel."
      end
    end

    def current_admin
      @current_admin ||= User.find_by(id: session[:admin_user_id])
    end
    helper_method :current_admin
  end
end
