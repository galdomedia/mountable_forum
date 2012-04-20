module SimpleForum
  class Engine < ::Rails::Engine
    isolate_namespace SimpleForum

    initializer "simple_forum.assets_precompile" do |app|
      app.config.assets.precompile += ['simple_forum/markitup.css', 'simple_forum/markitup.js']
    end
  end
end