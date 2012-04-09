# encoding: utf-8
require File.join(File.dirname(__FILE__), 'lib/pimple')

Gem::Specification.new do |s|
  s.name = "pimple"
  s.version = Pimple::VERSION
  s.authors = ["Florian Mhun"]
  s.email = ["florian.mhun@gmail.com"]
  s.homepage = "https://github.com/floommon/ruby-pimple"
  s.description = s.summary = "A lightweight dependency injection container for Ruby"

  s.platform = Gem::Platform::RUBY
	s.license = 'MIT'

  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
