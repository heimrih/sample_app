Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/about", to: "static_pages#about", as: :about
    get "/help", to: "static_pages#help", as: :help
    root "static_pages#home"
  end
end

