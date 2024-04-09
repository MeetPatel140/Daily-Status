class UsersController < ApplicationController
  def dashboard

    # Data for only Admin
    # View Employees Data
    @employees_present_count = User.where(role: 'employee').count
    @total_employees_count = User.count
    # View Reviews Data
    @pending_reviews_count = Status.where(status: 'pending').count
    @completed_reviews_count = Status.where(status: 'completed').count
    @total_reviews_count = Status.count

    # Data for only Employee
    # Assuming current_user.id represents the employee's ID
    employee_id = current_user.id
    # Pending Reviews Count for the current employee
    @current_employees_pending_reviews_count = Status.where(user_id: employee_id, status: 'pending').count
    # Completed Reviews Count for the current employee
    @current_employees_completed_reviews_count = Status.where(user_id: employee_id, status: 'completed').count
    # Total Reviews Count for the current employee
    @current_employees_total_reviews_count = Status.where(user_id: employee_id).count
    # View Logs
    @logs = Log.all

  end

end
