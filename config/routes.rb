require 'devise_token_auth'
Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions'
  }
  devise_scope :user do
    post 'api/v1/users/sign_in/facebook', to: 'api/v1/sessions#facebook'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
    end
  end
end
