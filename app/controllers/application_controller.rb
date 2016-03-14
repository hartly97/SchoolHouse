class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || (current_user.admin? ? users_path : user_path(current_user))
  end

  private
    def unauthorized(exception)
      flash[:error] = "Access Denied."
      redirect_to(request.referrer || user_path(current_user))
    end
end
