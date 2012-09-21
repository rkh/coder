# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coder/version'

Gem::Specification.new do |gem|
  gem.name          = "coder"
  gem.version       = Coder::VERSION
  gem.authors       = ["Konstantin Haase"]
  gem.email         = ["konstantin.mailinglists@googlemail.com"]
  gem.description   = %q{handle encodings, no matter what}
  gem.summary       = %q{library to handle encodings}
  gem.homepage      = "http://github.com/rkh/coder"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("rspec", "~> 2.11")
end
