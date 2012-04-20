$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple_forum/version"

# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "simple_forum"
  s.authors     = ["Galdomedia"]
  s.summary = "Insert SimpleForum summary."
  s.description = "Insert SimpleForum description."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = SimpleForum::VERSION

  s.add_dependency "abstract_auth"
  s.add_dependency "will_paginate", "~> 3.0.pre2"
  s.add_dependency "bb-ruby"
end
