Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Tells devise to look at the user/registrations folder first
  devise_for :users, :controllers => { :registrations => "user/registrations" }

  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_stocks', to: 'stocks#search'
  get 'my_friends', to: 'users#my_friends'
  get 'search_friends', to: 'users#search'
  post 'add_friend', to: 'users#add_friend'

  resources :user_stocks, only: [:create, :destroy]
  resources :user, only: [:show]
  resources :friendships
end
