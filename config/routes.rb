Rails.application.routes.draw do
  devise_for :users
  get '/users/complete_profile', to: 'users#complete_profile', as: 'user_complete_profile'
  root "pages#index"

  resources :users, only: [:show, :update]
  resources :leagues
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
