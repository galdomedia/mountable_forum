Rails.application.routes.draw do

  mount SimpleForum::Engine => "/forum"

  root :to => 'home#index', :via => :get

  devise_for :users
end
