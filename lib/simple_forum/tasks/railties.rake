#delete this file when Rails 3.1 will be released!

namespace :simple_forum do
  namespace :install do
    desc "-"
    task :assets => :rails_env do
      require 'rails/generators/base'
      Rails.application.initialize!

      app_public_path = Rails.application.paths["public"].first


      railtie = Rails.application.railties.all.detect { |r| r.respond_to?(railtie_name) ? r.railtie_name == 'simple_forum_engine' : r.class == SimpleForum::Engine }

      if railtie.respond_to?(:paths) && (path = railtie.paths["public"].first) &&
          (assets_dir = railtie.config.compiled_asset_path) && File.exist?(path)

        Rails::Generators::Base.source_root(path)
        copier = Rails::Generators::Base.new
        Dir[File.join(path, "**/*")].each do |file|
          relative = file.gsub(/^#{path}\//, '')
          if File.file?(file)
            copier.copy_file relative, File.join(app_public_path, assets_dir, relative)
          end
        end
      end
    end

    desc "-"
    task :migrations => :"db:load_config" do
      to_load = ['simple_forum_engine']
      railties = {}
      railtie = Rails.application.railties.all.detect { |r| r.respond_to?(railtie_name) ? r.railtie_name == 'simple_forum_engine' : r.class == SimpleForum::Engine }

      if railtie.respond_to?(:paths) && (path = railtie.paths["db/migrate"].first)
        railties[railtie.railtie_name] = path
      end

      on_skip = Proc.new do |name, migration|
        puts "NOTE: Migration #{migration.basename} from #{name} has been skipped. Migration with the same name already exists."
      end

      on_copy = Proc.new do |name, migration, old_path|
        puts "Copied migration #{migration.basename} from #{name}"
      end

      ActiveRecord::Migration.copy(ActiveRecord::Migrator.migrations_paths.first, railties,
                                   :on_skip => on_skip, :on_copy => on_copy)
    end
  end

  desc "-"
  task :install do
    Rake::Task["simple_forum:install:migrations"].invoke
    Rake::Task["simple_forum:install:assets"].invoke
  end
end
