Rails.application.routes.draw do
  devise_for :users

  root to: "users#dashboard"

  resources :users
  resources :statuses
  resources :tasks
  resources :time_records

  resources :statuses do
    resources :tasks
  end

  resources :statuses do
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

end
