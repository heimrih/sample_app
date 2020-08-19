Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/signup", to: "users#new", as: :signup
    get "/about", to: "static_pages#about", as: :about
    get "/help", to: "static_pages#help", as: :help
    get "/login", to: "sessions#new", as: :login
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy", as: :logout

    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
  end
end
