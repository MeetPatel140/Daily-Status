Rails.application.routes.draw do
  devise_for :users

  root to: "users#dashboard"

  resources :users
  resources :statuses
  resources :tasks
  resources :time_records
  resources :logs

  resources :statuses do
    resources :tasks
    member do
      get 'mark_resolved'
      get 'mark_completed'
    end
  end

  post '/check_in', to: 'time_records#check_in'
  post '/check_out', to: 'time_records#check_out'
  post '/new_status', to: 'new_status#send_email'
  put 'update_status', to: 'tasks#update_status'
  get '/get_checkin_time', to: 'time_records#get_checkin_time'
  get '/get_recorded_duration', to: 'time_records#get_recorded_duration'
  get '/weekly_durations', to: 'time_records#weekly_durations'
  get '/time_records/:year/:month', to: 'time_records#index', as: 'time_records_by_month_year'
  get '/logs/:page', to: 'logs#index', as: 'logs_page'
  get '/weekly_employee_count', to: 'time_records#weekly_employee_count'
end
