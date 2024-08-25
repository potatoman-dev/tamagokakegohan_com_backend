Rails.application.routes.draw do
  get "status", to: "status#index"
  resources :s3tests, only: [:create]
end
