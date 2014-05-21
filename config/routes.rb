Rails.application.routes.draw do
  root 'static_pages#home'

  namespace :api do
    namespace :v1 do
      resources :events do
        post :search, on: :collection
      end
    end
  end

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'
end
