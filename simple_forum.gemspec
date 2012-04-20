$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple_forum/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_forum"
  s.version     = SimpleForum::VERSION
  s.authors     = ["Galdomedia"]
  s.email       = ["piotr@galdomedia.pl"]
  s.homepage    = "https://github.com/galdomedia/mountable_forum"
  s.summary     = "Simple forum distributed as Rails mountable engine."
  s.description = "Simple forum distributed as Rails mountable engine."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  s.add_dependency "jquery-rails"

  s.add_dependency "abstract_auth"
  s.add_dependency "will_paginate", "~> 3.0"
  s.add_dependency "bb-ruby"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "devise"
  s.add_development_dependency "rspec-rails"
end
