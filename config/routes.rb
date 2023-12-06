Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: :index
      end

      resources :vendors, except: :index
      resources :market_vendors, only: :create
      delete '/market_vendors', to: 'market_vendors#destroy'
    end
  end
end
