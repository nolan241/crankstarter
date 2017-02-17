Rails.application.routes.draw do
  root 'projects#index'
  devise_for :users
  
  resources :projects do
    #nested route so rewards path is inside the projects path as /projects/:project_id/rewards/:id
    resources :rewards, only: [:new, :create, :edit, :update, :destroy]
    resources :pledges
    resources :payments, only: [:new, :create]
  end
  
  #delayed jobs route /delayed_job/overview - access the interface and retry failed jobs
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  
end