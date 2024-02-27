module ApplicationHelper
  def current_user_admin?
    current_user.admin?
  end
end
