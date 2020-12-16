Rails.application.routes.draw do
  resources :messages
  root "home#index"
  get "/login", to: "sessions#new"
  defaults format: :json do
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
  defaults format: :json do
    resources :users
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
