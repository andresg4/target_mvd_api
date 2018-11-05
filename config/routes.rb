require 'devise_token_auth'
Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions',
    passwords: 'api/v1/passwords'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'users/sign_in/facebook', to: 'sessions#facebook'
      end
      resources :topics, only: [:index]
      resources :targets, only: %i[index show create destroy]
      get 'users/me/targets', to: 'users#targets', as: 'user_targets'
      put 'users/me/', to: 'users#update', as: 'user_update'
    end
  end
end
