class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_employee!, unless: :signup_page?
  helper_method :current_employee

  def current_employee
    @current_employee ||= Employee.find_by(id: session[:employee_id]) if session[:employee_id]
  end

  def authenticate_employee!
    redirect_to login_path unless current_employee || signup_page?
  end

  def signup_page?
    controller_name == 'registrations' && action_name.in?(['new', 'create'])
  end
end
