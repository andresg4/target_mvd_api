Rails.application.routes.draw do
  devise_for :users, path: 'api/v1/users/', controllers: {
    sessions: 'api/v1/sessions',
    registrations: 'api/v1/registrations',
    passwords: 'api/v1/passwords'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
    end
  end
end
