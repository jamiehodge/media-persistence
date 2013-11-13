$:.unshift File.expand_path("../lib", __FILE__)
require "media/persistence/version"

Gem::Specification.new do |gem|
  gem.name        = "media-persistence"
  gem.version     = Media::Persistence::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["Jamie Hodge"]
  gem.email       = ["jamieh@hum.ku.dk"]
  gem.homepage    = ""
  gem.summary     = %q{}
  gem.description = gem.summary

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.modelname(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency "sequel"
  gem.add_dependency "sequel_pg"
end
