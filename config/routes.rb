Rails.application.routes.draw do
  resources :employees, :tasks, :statuses
end
