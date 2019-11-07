Rails.application.routes.draw do
  devise_for :users
  root "pages#index"
  
  resources :leagues
  resources :seasons do
    get 'confirm'
    post 'deactivate'
    post 'leave'
  end
  
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
end
