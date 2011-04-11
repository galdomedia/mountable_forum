#TODO delete this file when Rails 3.1 will be released!
require 'active_record/migration'

namespace :simple_forum do
  namespace :install do
    desc "-"
    task :assets => :rails_env do
      require 'rails/generators/base'
      Rails.application.initialize!

      app_public_path = Rails.application.paths["public"].first


      railtie = Rails.application.railties.all.detect { |r| r.respond_to?(:railtie_name) ? r.railtie_name == 'simple_forum_engine' : r.class == SimpleForum::Engine }

      path = railtie.paths["public"].first
      Rails::Generators::Base.source_root(path)
      copier = Rails::Generators::Base.new
      Dir[File.join(path, "**/*")].each do |file|
        relative = file.gsub(/^#{path}\//, '')
        if File.file?(file)
          copier.copy_file relative, File.join(app_public_path, 'simple_forum_engine', relative)
        end
      end
    end

    desc "-"
    task :migrations => :"db:load_config" do
      to_load = ['simple_forum_engine']
      railties = {}
      railtie = Rails.application.railties.all.detect { |r| r.respond_to?(:railtie_name) ? r.railtie_name == 'simple_forum_engine' : r.class == SimpleForum::Engine }

      if railtie.respond_to?(:paths) && (path = railtie.paths["db/migrate"].first)
        railties['simple_forum_engine'] = path
      end

      on_copy = Proc.new do |name, file, old_path|
        puts "Copied migration #{file} from #{name}"
      end

      destination = 'db/migrate'

      FileUtils.mkdir_p(destination) unless File.exists?(destination)

      railties.each do |name, path|
        source_files = Dir["#{path}/[0-9]*_*.rb"]


        source_files.each do |file|
          new_path = File.join(destination, File.basename(file))
          old_path = file

          FileUtils.cp(old_path, new_path)
          on_copy.call(name, file, old_path)
        end

      end
    end
  end

  desc "-"
  task :install do
    Rake::Task["simple_forum:install:migrations"].invoke
    Rake::Task["simple_forum:install:assets"].invoke
  end
end
