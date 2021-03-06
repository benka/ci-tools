# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jira-automator/version'

Gem::Specification.new do |spec|
  spec.name          = "jira-automator"
  spec.version       = JiraAutomator::VERSION
  spec.authors       = ["benka"]
  spec.email         = ["andrew.benkoczi@gmail.com"]

  spec.summary       = %q{Automate JIRA card status transitions}
  spec.description   = %q{Automator get all cards from a specific JIRA filter and changes their status}
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
