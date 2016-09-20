# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clubhouse/version'

Gem::Specification.new do |spec|
  spec.name          = "clubhouse.io-ruby"
  spec.version       = Clubhouse::VERSION
  spec.authors       = ["Jon Normington"]
  spec.email         = ["jnormington@users.noreply.github.com"]

  spec.summary       = %q{Clubhouse.io ruby gem for api interaction}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/jnormington/clubhouse.io-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock"
end
