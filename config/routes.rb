Rails.application.routes.draw do
  root "pages#index"

  devise_for :users
  get '/users/complete_profile', to: 'users#complete_profile', as: 'user_complete_profile'

  resources :users, only: [:show, :update]
  resources :leagues do
    member do
      get '/new-user', to: 'leagues#new_user'
      post '/create-user', to: 'leagues#create_user'
    end
  end

  get '/public-leagues', to: 'leagues#public_leagues', as: 'public_leagues'

  resources :seasons do
    member do
      get 'confirm'
      post 'deactivate'
      post 'leave'
      post 'complete'
      post 'uncomplete'
      post 'count'
      post 'uncount'
      get 'settings'
      put 'settings', to: 'settings#update_settings', as: 'update_settings'
      put 'scoring_system'
    end
  end

  resources :games do
    member do
      post '/complete', to: 'games#complete'
      post '/uncomplete', to: 'games#uncomplete'
      get '/new-user', to: 'games#new_user'
      post '/create-user', to: 'games#create_user'
    end
  end

  resources :players

  get '/user-stats/:id', to: 'user_stats#show', as: 'user_stats'
  get '/user-stats/:id/games', to: 'user_stats#games', as: 'user_stats_games'
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'

  namespace :api, defaults: { format: :json } do
    post '/login', to: 'authentication#authenticate_user', as: 'auth_user'
  end

  get '*unmatched_route', :to => 'application#render_404'
end
