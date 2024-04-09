class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # helper_method :current_user

  # def current_user
  #   @current_user ||= user.find_by(id: session[:user_id]) if session[:user_id]
  # end

  # def authenticate_user!
  #   redirect_to login_path unless current_user || signup_page?
  # end

  # def signup_page?
  #   controller_name == 'registrations' && action_name.in?(['new', 'create'])
  # end

  # def after_sign_in_path_for(resource)
  #   if resource.role == "admin"
  #     admin_dashboard_path
  #   else
  #     root_path
  #   end
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    @current_user = resource
    root_path
  end

end
