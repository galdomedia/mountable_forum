module SimpleForum

  module Generators

    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies the simple_forum initializer."

      def copy_initializer
        template "simple_forum.rb", "config/initializers/simple_forum.rb"
      end

    end

  end

end