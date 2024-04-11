class LogsController < ApplicationController
  def index
    if current_user.admin?
      logs = Log.order(timestamp: :desc).paginate(page: params[:page], per_page: 10)
    else
      logs = current_user.logs.order(timestamp: :desc).paginate(page: params[:page], per_page: 10)
    end

    render json: {
      logs: logs,
      pagination: pagination_info(logs)
    }
  end

  private

  def pagination_info(collection)
    current_page = collection.current_page
    total_pages = collection.total_pages
    next_page = collection.next_page
    total_entries = collection.total_entries

    prev_page = current_page > 1 ? current_page - 1 : nil

    {
      current_page: current_page,
      total_pages: total_pages,
      next_page: next_page,
      prev_page: prev_page,
      total_count: total_entries
    }
  end


end
