class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /statuses
  def index
    @user = current_user
    if current_user.admin?
      @statuses = Status.all
    else
      @statuses = current_user.statuses
    end
  end

  # GET /statuses/1
  def show
    @status = Status.find(params[:id])
  end

  # GET /statuses/new
  def new
    @status = Status.new
  end

  # GET /statuses/1/edit
  def edit
  end

  # POST /statuses
  def create
    @status = Status.new(status_params)
    @status.user = current_user
    if @status.save
      flash[:notice] = 'Status was successfully added.'
      redirect_to status_path(@status)
    else
      render 'new', status: 422
    end
  end

  # PATCH/PUT /statuses/1
  def update
    if current_user.admin?
      if @status.update(status_params)
        flash[:notice] = 'Status was successfully updated.'
        redirect_to statuses_path
      else
        flash[:alert] = 'Failed to update status.'
        flash[:alert] = @status.errors.full_messages.join(', ')
        render :edit, status: 422
      end
    elsif !current_user.admin?
      flash[:alert] = 'You do not have permission to update this status.'
      render :edit, status: 422
    end
  end

  # DELETE /statuses/1
  def destroy
    @status.destroy
    flash[:notice] = 'Status was successfully destroyed.'
    redirect_to statuses_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_status
    @status = Status.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def status_params
    params.require(:status).permit(:daily_report, :github_pr_link, :date, :remarks, :user_id, tasks_attributes: [:id, :title, :description, :start_time, :end_time, :screenshot, :_destroy])
  end
end
