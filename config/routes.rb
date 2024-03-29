Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  namespace :api, format: 'json' do
    resources :bookmarks, only: [:index, :show, :create, :update, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
