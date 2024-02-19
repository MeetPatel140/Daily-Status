class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]

  # GET /statuses
  def index
    @statuses = Status.all
  end

  # GET /statuses/1
  def show
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

    if @status.save
      flash[:notice] = 'Status was successfully created.'
      redirect_to @status
    else
      render :new
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
    params.require(:status).permit(
      :employee_id, :checkin_time, :checkout_time, :daily_report,
      :github_pr_link, :date, :remarks,
      tasks_attributes: [:id, :title, :description, :start_time, :end_time, :screenshot, :_destroy]
    )
  end
end
