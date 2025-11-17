class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      solicitante_dashboard_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def authorize_admin!
    unless current_user.admin?
      redirect_to root_path, alert: 'Acesso negado. Área restrita a administradores.'
    end
  end

  def authorize_solicitante!
    unless current_user.solicitante?
      redirect_to root_path, alert: 'Acesso negado. Área restrita a solicitantes.'
    end
  end
end