Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :points, only: [:index, :create]
      patch 'points', to: 'points#update'
    end
  end
end
