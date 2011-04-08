require "simple_forum"
require "rails"

module SimpleForum
  class Engine < Rails::Engine
#    isolate_namespace SimpleForum
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

    rake_tasks do
      load "simple_forum/tasks/railties.rake"
    end
  end
end
