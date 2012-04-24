module SimpleForum
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies the simple_forum initializer and mount engine in routes."

      def copy_initializer
        template "simple_forum.rb", "config/initializers/simple_forum.rb"
      end

      def mount_engine
        route 'mount SimpleForum::Engine => "/forum"'
      end
    end
  end
end