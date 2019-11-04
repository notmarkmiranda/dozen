Rails.application.routes.draw do
  devise_for :users
  root "pages#index"
  
  resources :leagues
  
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
end
