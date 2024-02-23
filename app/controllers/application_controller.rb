class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :authenticate_employee!
  # helper_method :current_employee
  before_action :configure_permitted_parameters, if: :devise_controller?

  # def current_employee
  #   @current_employee ||= Employee.find_by(id: session[:employee_id]) if session[:employee_id]
  # end

  # def signup_page?
  #   controller_name == 'registrations' && action_name.in?(['new', 'create'])
  # end

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      root_path
    else
      root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end
end
