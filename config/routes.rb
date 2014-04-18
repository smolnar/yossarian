Rails.application.routes.draw do
  root 'events#index'

  resources :events, only: :index

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'
end
