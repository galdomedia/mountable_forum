Rails.application.routes.draw do
  mount SimpleForum::Engine => "/simple_forum"

  root :to => 'simple_forum/forums#index', :via => :get

  devise_for :users
end
