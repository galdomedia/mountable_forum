# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "simple_forum"
  s.summary = "Insert SimpleForum summary."
  s.description = "Insert SimpleForum description."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"


  s.add_dependency "abstract_auth"
  s.add_dependency "will_paginate", "~> 3.0.pre2"
  s.add_dependency "bb-ruby"
end
