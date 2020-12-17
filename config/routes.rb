Rails.application.routes.draw do
  root "home#index"
  get "/login", to: "sessions#new"
  defaults format: :json do
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
  end
  resources :messages, :except => [:edit, :update]
  get "/messages/:id/reply", to: "messages#reply_new", as: "reply_to_message"
  post "/messages/:id/reply", to: "messages#reply_create"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
