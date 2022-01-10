Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, format: 'json' do
    resources :bookmarks, only: [:index]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
