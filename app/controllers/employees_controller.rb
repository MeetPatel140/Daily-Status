class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show]
  # before_action :require_admin, only: [:index, :destroy]
  before_action :authenticate_employee!

  # GET  /employees
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  def show
    @employee = Employee.find(params[:id])
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  def update
    if @employee.update(employee_params)
      flash[:notice] = "Employee Account Updated !"
      redirect_to @employee
    else
      render 'edit'
    end
  end

  # POST /employees
  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      flash[:notice] = "Employee Account Created !"
      redirect_to @employee
    else
      render 'new'
    end
  end

  # DELETE /employees/1
  def destroy
    @employee.destroy
    flash[:notice] = "Employee Account Deleted !"
    redirect_to employees_path
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :email, :password, :admin)
  end

  # Only allow a trusted parameter "white list" through.
  def set_employee
    @employee = current_employee
  end

  # Check if the current employee is an admin
  def require_admin
    redirect_to root_path unless current_employee && current_employee.admin?
  end
end
