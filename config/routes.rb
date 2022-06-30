Rails.application.routes.draw do
  resources :transactions

  resources :accounts do
    post "sync", on: :member
  end

  resources :sessions do
    post "link", on: :member
    get "callback", on: :collection
  end

  root "pages#home"
end
