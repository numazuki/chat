# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  root to: 'users#index'
  namespace :users do
    resources :searches, only: :index
  end

  resources :rooms, except:  %i[index]
  resources :users 

  resources :relationships, only: %i[create destroy]
  get '/show_additionally', to: 'rooms#show_additionally'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
