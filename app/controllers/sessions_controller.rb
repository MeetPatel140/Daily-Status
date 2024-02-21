class SessionsController < ApplicationController
  skip_before_action :authenticate_employee!, only: [:new, :create]

  def new
    # Render the login form
  end

  def create
    employee = Employee.find_by(email: params[:email])

    if employee && employee.authenticate(params[:password])
      session[:employee_id] = employee.id
      redirect_to current_employee, notice: 'Login successful!'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:employee_id] = nil
    redirect_to root_path, notice: 'Logged out successfully!'
  end
end
