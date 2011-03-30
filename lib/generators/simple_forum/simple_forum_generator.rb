require 'rails/generators'
require 'rails/generators/migration'

module SimpleForum
  module Generators
   
    class SimpleForumGenerator < Rails::Generators::Base    
      include Rails::Generators::Migration
     
      namespace :simple_forum
      source_root File.expand_path("../templates", __FILE__)
 
#      def create_migration_file
#        migration_template 'forums_migration.rb', 'db/migrate/create_simple_forum_forums.rb'
#      end

    end
  
  end
end

