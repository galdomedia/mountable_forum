Rails.application.routes.draw do

  root :to => "simple_forum/forums#index"

  resources :forums, :only => [:index, :show], :controller => 'simple_forum/forums' do
    resources :topics, :only => [:show], :controller => 'simple_forum/topics' do
      resources :posts, :only => [:show, :new, :create], :controller => 'simple_forum/posts' do
      end
    end
  end


end
