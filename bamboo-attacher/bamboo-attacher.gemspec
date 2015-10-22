# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bamboo-attacher/version'

Gem::Specification.new do |spec|
  spec.name          = "bamboo-attacher"
  spec.version       = BambooAttacher::VERSION
  spec.authors       = ["benka"]
  spec.email         = ["andrew.benkoczi@gmail.com"]

  spec.summary       = %q{Attaches a serverside script to a bamboo build job}
  spec.description   = %q{BambooAttacher runs on a bamboo server in the background without occupying the Bamboo Agent and when finished calls a summary job to let users know of it's result}
  spec.homepage      = "https://github.com/benka/ci-tools"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
