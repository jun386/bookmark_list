Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, format: 'json' do
    resources :bookmarks, only: [:index, :create, :update, :destroy]
    mount_devise_token_auth_for 'User', at: 'auth'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
