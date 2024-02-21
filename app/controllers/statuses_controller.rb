class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_employee!

  # GET /statuses
  def index
    @statuses = Status.all
  end

  # GET /statuses/1
  def show
    @status = Status.find(params[:id])
  end

  # GET /statuses/new
  def new
    @status = Status.new
    @employee = current_employee
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
    @task = Task.new
  end

  # POST /statuses
  def create
    @employee = current_employee
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

  def current_employee
    @current_employee ||= Employee.find_by(id: session[:employee_id])
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_status
    @status = Status.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  # app/controllers/statuses_controller.rb
  def status_params
    params.require(:status).permit(:check_in, :check_out, :daily_report, :github_pr_link, :date, :remarks, :employee_id, tasks_attributes: [:id, :title, :description, :start_time, :end_time, :screenshot, :_destroy])
  end
end
