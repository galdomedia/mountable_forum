module SimpleForum
  class Engine < ::Rails::Engine
    isolate_namespace SimpleForum

    initializer "simple_forum.assets_precompile" do |app|
      app.config.assets.precompile += ['simple_forum/admin.css']
      app.config.assets.precompile += ['simple_forum/markitup.css', 'simple_forum/markitup.js']
      app.config.assets.precompile += ['simple_forum/moderators.js']
    end

    config.to_prepare do
      require "simple_forum/extensions/user"
      instance_eval(&SimpleForum.invoke(:user_class)).send(:include, ::SimpleForum::Extensions::User)
    end
  end
end
