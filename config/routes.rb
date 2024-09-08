Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }
      get "status", to: "status#index"
      resources :recipes, only: %i[index create show update destroy]
      resources :ingredients, only: %i[index create show update destroy]
      # users
      get 'users/check_name', to: "users#check_name"
      get "users/:name", to: "users#show"
      get "users/:name/recipes", to: "recipes#user"
      # bookmarks
      get "users/:name/bookmarks", to: "bookmarks#index"
      post "recipes/:id/bookmark", to: "bookmarks#create"
      delete "recipes/:id/bookmark", to: "bookmarks#destroy"
      get "recipes/:id/is_user_bookmarked", to: "recipes#is_user_bookmarked"
      # relationships
      post "users/:name/relationship", to: "relationships#create"
      delete "users/:name/relationship", to: "relationships#destroy"
      get "users/:name/followings", to: "relationships#followings"
      get "users/:name/followers", to: "relationships#followers"
      get "users/:name/is_user_followed", to: "relationships#is_user_followed"
    end
  end
end
