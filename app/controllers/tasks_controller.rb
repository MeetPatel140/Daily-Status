class TasksController < ApplicationController
  before_action :set_status, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @status = Status.find(params[:status_id])
    @task = @status.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @status = Status.find(params[:status_id])
    @task = @status.tasks.build(task_params)
    if @task.save
      flash[:notice] = 'Task was successfully created.'
      redirect_to @task
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      flash[:notice] = 'Task was successfully updated.'
      redirect_to @task
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    flash[:notice] = 'Task was successfully destroyed.'
    redirect_to tasks_url
  end

  private

  def set_status
    @status = Status.find(params[:status_id])
    if @status.nil?
      redirect_to statuses_path, alert: 'Status not found'
    end
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end
  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description, :start_time, :end_time, :screenshot, :status_id)
  end
end
