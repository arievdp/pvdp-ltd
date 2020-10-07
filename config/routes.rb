Rails.application.routes.draw do
  root to: 'farms#index'
  get '/dashboard', to: 'pages#index'
  get '/upload', to: 'pages#upload'
  get '/duplicates', to: 'animals#duplicates'
  post '/upload', to: 'farms#process_csv'
  resources :farms, only: [:index, :show]
  resources :animals, only: [:edit, :update, :destroy]
  resources :farms do
    resources :animals, only: [:index, :show]
  end

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
