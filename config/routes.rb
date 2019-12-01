Rails.application.routes.draw do
  root "pages#index"

  devise_for :users
  get '/users/complete_profile', to: 'users#complete_profile', as: 'user_complete_profile'

  resources :users, only: [:show, :update]
  resources :leagues

  get '/public_leagues', to: 'leagues#public_leagues', as: 'public_leagues'

  resources :seasons do
    get 'confirm'
    post 'deactivate'
    post 'leave'
    post 'complete'
    post 'uncomplete'
    post 'count'
    post 'uncount'
  end
  resources :games
  resources :players

  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
end
