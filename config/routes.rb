Rails.application.routes.draw do
  devise_for :users
  root "pages#index"
  
  resources :leagues
  resources :seasons do
    collection do
      get 'confirm'
    end
  end
  
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
end
