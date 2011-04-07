require "simple_forum"
require "rails"

module SimpleForum
  class Engine < Rails::Engine
#    isolate_namespace SimpleForum
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
  end
end
