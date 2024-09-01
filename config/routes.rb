Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }
      get "status", to: "status#index"
      resources :recipes, only: %i[index create show update destroy]
      resources :categories, only: %i[index create show update destroy]
      get 'users/check_name', to: "users#check_name"
      get "users/:name", to: "users#show"
    end
  end
end
