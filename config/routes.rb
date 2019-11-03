Rails.application.routes.draw do
  devise_for :users
  root "pages#index"
  
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
end
