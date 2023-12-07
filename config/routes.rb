Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: :index
      end

      resources :vendors, except: [:index, :edit, :new]
      resources :market_vendors, only: :create
      delete '/market_vendors', to: 'market_vendors#destroy'
      get '/api/v0/markets/search', to: 'markets#search'
    end
  end
end
