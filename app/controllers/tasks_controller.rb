class TasksController < ApplicationController
  before_action :set_status, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    redirect_to statuses_path
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
      Log.create(user_id: current_user.id, timestamp: Time.now, action: 'New Task Added')
      flash[:notice] = 'Task was successfully created.'
      redirect_to status_path(@status)
    else
      render 'new', status: 422
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      Log.create(user_id: current_user.id, timestamp: Time.now, action: 'Task Updated')
      flash[:notice] = 'Task was successfully updated.'
      redirect_to @task
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    Log.create(user_id: current_user.id, timestamp: Time.now, action: 'Task Deleted')
    flash[:notice] = 'Task was successfully destroyed.'
    redirect_to tasks_url
  end

  def update_status
    task = Task.find(params[:task_id])
    task.update(status: params[:status])
    head :ok
  end

  private

  def set_status
    @status = Status.find_by(params[:status_id] || params[:id])
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
