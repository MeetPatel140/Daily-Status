Rails.application.routes.draw do
  root to: 'sessions#new'

  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout
  get '/signup', to: 'employees#new', as: 'signup'

  resources :employees
  resources :statuses
  resources :tasks

  resources :employees, only: [:new, :create] do
    resources :statuses
  end

  resources :statuses do
    resources :tasks
  end

  namespace :admin do
    get 'remarks', to: 'admins#remarks'
    get 'remarks/:id/edit', to: 'admins#edit_remark', as: 'edit_remark'
    patch 'remarks/:id', to: 'admins#update_remark'
    delete 'remarks/:id', to: 'admins#destroy_remark'
  end
end
