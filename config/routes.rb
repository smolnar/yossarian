Rails.application.routes.draw do
  root 'static_pages#home'

  namespace :api do
    resources :events, only: :index
  end

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'
end
