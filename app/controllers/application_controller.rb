class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :update_sanitized_params, if: :devise_controller?
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from "Exception", with: :forbidden
  
  private
  
  def current_user_is_admin
    unauthorized unless current_user.admin
  end

  def unauthorized
    logger.warn "[ApplicationController] Unauthorized for #{current_user}"
    render text: "401 Unauthorized", status: 401
    return 
  end
  
  def forbidden(exception)
    logger.error "[ApplicationController] Exception: #{exception.inspect}"
    render text: "Pristup nije dozvoljen", status: 403
    return
  end
  
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :phone, :email, :password, :password_confirmation, :requested_group_id, :neighborhood)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, :phone, :email, :password, :password_confirmation, :current_password, :neighborhood)}
  end
  
end
