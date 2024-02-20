class AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_permissions, only: [:remarks, :edit_remark, :update_remark, :destroy_remark]

  def index
    @remarks = Remark.all
  end

  def show
    @remark = Remark.find(params[:id])
  end

  def remarks
    @remarks = Remark.all
  end

  def edit_remark
    @remark = Remark.find(params[:id])
  end

  def update_remark
    @remark = Remark.find(params[:id])
    if @remark.update(remark_params)
      redirect_to admin_remarks_path, notice: 'Remark updated successfully.'
    else
      render :edit_remark
    end
  end

  def destroy_remark
    @remark = Remark.find(params[:id])
    @remark.destroy
    redirect_to admin_remarks_path, notice: 'Remark deleted successfully.'
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_employee.admin?
  end

  def remark_params
    params.require(:remark).permit(:content)
  end
end
