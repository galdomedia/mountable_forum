module SimpleForum
  module Generators
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path("../../../../app/views", __FILE__)
      desc "Copies simple_forum views to your application."

      def copy_views
        directory 'simple_forum', "app/views/simple_forum"
      end

      def copy_layout
        copy_file "layouts/simple_forum.html.erb", "app/views/layouts/simple_forum.html.erb"
      end

    end
  end
end
