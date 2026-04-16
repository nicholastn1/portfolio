module Admin
  class SessionsController < ApplicationController
    layout "admin"

    helper_method :current_admin

    def new
      redirect_to admin_root_path if current_admin
    end

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:admin_user_id] = user.id
        redirect_to admin_root_path, notice: "Login realizado com sucesso."
      else
        flash.now[:alert] = "Email ou senha inválidos."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:admin_user_id)
      redirect_to admin_login_path, notice: "Logout realizado."
    end

    private

    def current_admin
      @current_admin ||= User.find_by(id: session[:admin_user_id])
    end
  end
end
