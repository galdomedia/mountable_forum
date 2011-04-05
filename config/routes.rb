SimpleForum::Engine.routes.draw do

  root :to => "simple_forum/forums#index"
  match '/asd2' => "simple_forum/forums#index", :as => :aaaa

  #   - Make sure our route names are namespaced under regulate_
  scope 'forum', :module => :simple_forum, :as => :simple_forum do
    match '/asd2' => "simple_forum/forums#index", :as => :bbbb

    resources :forums, :only => [:index, :show] do
      resources :topics, :only => [:show], :controller => 'simple_forum/topics' do
        resources :posts, :only => [:show, :new, :create], :controller => 'simple_forum/posts' do
        end
      end
    end
  end


end
