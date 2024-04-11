class StatusesController < ApplicationController
  include ApplicationHelper
  before_action :set_status, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :current_user_admin?

  # GET /statuses
  def index
    @user = current_user
    if current_user_admin?
      @statuses = Status.all
    else
      @statuses = current_user.statuses
    end
    @status = Status.new(status: "pending", remarks: nil)
  end

  # GET /statuses/1
  def show
    @status = Status.find(params[:id])
  end

  # GET /statuses/new
# app/controllers/statuses_controller.rb
def new
  @status = Status.new(status: "pending", remarks: nil)
end


  # GET /statuses/1/edit
  def edit
  end

  # POST /statuses
  def create
    @status = Status.new(status_params)
    set_status_attribute
    @status.user = current_user
    if @status.save
      AdminMailer.new_status_email_admin(current_user, @status).deliver_now
      Log.create(user_id: @current_user.id, timestamp: Time.now, action: 'New Status Added')
      flash[:notice] = 'Status was successfully added.'
      redirect_to status_path(@status)
    else
      render 'new', status: 422
    end
  end

  # PATCH/PUT /statuses/1
  def update
    set_status_attribute
    if current_user_admin?
      if @status.update(status_params)
        if !@current_user.admin?
          Log.create(user_id: @current_user.id, timestamp: Time.now, action: 'Status Updated')
          flash[:notice] = 'Status was successfully updated.'
          redirect_to statuses_path
        end
        flash[:notice] = 'Remarks Added successfully.'
        redirect_to statuses_path
      else
        flash[:alert] = 'Failed to update status.'
        flash[:alert] = @status.errors.full_messages.join(', ')
        render :edit, status: 422
      end
    elsif current_user == @status.user
      if @status.update(status_params)
        Log.create(user_id: @current_user.id, timestamp: Time.now, action: 'Status Updated')
        flash[:notice] = 'Status was successfully updated.'
        redirect_to statuses_path
      else
        flash[:alert] = 'Failed to update status.'
        flash[:alert] = @status.errors.full_messages.join(', ')
        render :edit, status: 422
      end
    else
      flash[:alert] = 'You do not have permission to update this status.'
      render :edit, status: 422
    end
  end

  # DELETE /statuses/1
  def destroy
    @status.destroy
    Log.create(user_id: @current_user.id, timestamp: Time.now, action: 'Status Deleted')
    flash[:notice] = 'Status was successfully destroyed.'
    redirect_to statuses_url
  end

  def mark_resolved
    @status = Status.find(params[:id])

    if @status.update(status: 'resolved')
      AdminMailer.mark_as_resolved_email_admin(current_user, @status).deliver_now
      flash[:notice] = 'Status marked as resolved.'
    else
      flash[:alert] = 'Failed to mark status as resolved.'
    end
    redirect_to statuses_path
  end

  def mark_completed
    @status = Status.find(params[:id])

    if @status.update(status: 'completed')
      AdminMailer.mark_as_completed_email_user(current_user, @status).deliver_now
      flash[:notice] = 'Status marked as resolved.'
    else
      flash[:alert] = 'Failed to mark status as resolved.'
    end
    redirect_to statuses_path
  end
  def set_status_attribute
    if current_user.admin?
      @status.status = 'issue'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_status
    @status = Status.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def status_params
    params.require(:status).permit(:status, :daily_report, :github_pr_link, :date, :remarks, :user_id, tasks_attributes: [:id, :title, :description, :start_time, :end_time, :screenshot, :_destroy])
  end
end
