Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      get '/markets', to: 'markets#index'
    end
  end
end
