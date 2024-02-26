class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /statuses
  def index
    @user = current_user
    @statuses = Status.all
  end

  # GET /statuses/1
  def show
    @status = Status.find(params[:id])
  end

  # GET /statuses/new
  def new
    @status = current_user.statuses.build
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
    @task = Task.new
  end

  # POST /statuses
  def create
    @user = current_user
    @status = @employee.statuses.create(status_params)

    respond_to do |format|
      if @status.persisted?
        flash[:notice] = 'Status was successfully created.'
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@status, partial: 'statuses/status', locals: { status: @status }) }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /statuses/1
  def update
    if @status.update(status_params)
      flash[:notice] = 'Status was successfully updated.'
      redirect_to @status
    else
      render :edit
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
