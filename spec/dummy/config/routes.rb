Dummy::Application.routes.draw do

  root :to => 'simple_forum/forums#index', :via => :get

  devise_for :users

#  mount SimpleForum::Engine, :at => "/forum", :as => "forum"


end
