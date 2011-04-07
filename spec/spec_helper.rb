# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "rspec/rails"
require "factories"

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

# Run any available migrations
FileUtils.rm(Dir[File.expand_path("../dummy/db/test.sqlite3", __FILE__)])
FileUtils.rm(Dir[File.expand_path("../dummy/db/migrate/*_simple_forum_*.rb", __FILE__)])
FileUtils.mkdir_p(File.expand_path("../dummy/db/migrate/", __FILE__))
ActiveRecord::Migration.copy File.expand_path("../dummy/db/migrate/", __FILE__), { :simple_forum => File.expand_path("../../db/migrate/", __FILE__) }
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers
  include Rails.application.routes.mounted_helpers


  # == Mock Framework
  config.mock_with :rspec
end
