Rails.application.routes.draw do
  devise_for :users

  root to: "users#dashboard"

  resources :users
  resources :statuses
  resources :tasks

  resources :statuses do
    resources :tasks
  end

  post '/checkouts', to: 'checkouts#process_check_outs'
end
