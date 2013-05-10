DiorsCloud::Application.routes.draw do

  root :to => 'home#index'

  devise_for :users, controllers: { :sessions => "users/sessions", :registrations => "users/registrations", :passwords => "users/passwords" }, skip: [:registration, :sessions]

  as :user do
    get 'login' => 'users/sessions#new', :as => :new_user_session
    post 'login' => 'users/sessions#create', :as => :user_session
    get 'logout' => 'users/sessions#destroy', :as => :destroy_user_session
    get 'signup' => 'users/registrations#new', :as => :new_user_registration
    post 'signup' => 'users/registrations#create', :as => :user_registration
    get 'password/forget' => 'users/passwords#new', :as => :new_user_password
    post 'password' => 'users/passwords#create', :as => :user_password
  end

  require 'api'
  mount DiorsCloud::API => '/api'
end
