Rails.application.routes.draw do
  resources :accounts do
    post "link", on: :member
    get "callback", on: :collection
  end

  root "pages#home"


end
