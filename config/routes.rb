Rails.application.routes.draw do
  devise_for :users

  root to: "users#dashboard"

  resources :users
  resources :statuses
  resources :tasks

  resources :statuses do
    resources :tasks
  end

  post '/checkouts', to: 'checkouts#process_checkouts'
  post '/new_status', to: 'new_status#send_email'
  put 'update_status', to: 'tasks#update_status'

end
