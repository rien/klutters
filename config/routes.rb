Rails.application.routes.draw do
  resources :transactions

  resources :accounts do
    post "reload_balance", on: :member
    post "reload_transactions", on: :member
  end

  resources :sessions do
    post "link", on: :member
    get "callback", on: :collection
  end

  root "pages#home"
end
