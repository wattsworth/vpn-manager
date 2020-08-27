Rails.application.routes.draw do

  root to: "devices#index"

  resources :groups do
    member do
      post 'add'
      delete 'remove'
    end
    collection do
      post 'rebuild'
    end
  end
  resources :devices do
    collection do
      post 'rebuild'
    end
  end
  devise_for :users

end
