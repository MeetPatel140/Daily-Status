module ApplicationHelper
  def current_user_admin?
    current_user.admin?
  end

  def current_user_employee?
    current_user.employee?
  end

end
