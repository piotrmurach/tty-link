# frozen_string_literal: true

require_relative "lib/tty/link/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-link"
  spec.version       = TTY::Link::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = "Terminal hyperlinks support detection and generation."
  spec.description   = spec.summary
  spec.homepage      = "https://ttytoolkit.org"
  spec.license       = "MIT"
  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri"   => "https://github.com/piotrmurach/tty-link/issues",
    "changelog_uri"     => "https://github.com/piotrmurach/tty-link/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/tty-link",
    "funding_uri"       => "https://github.com/sponsors/piotrmurach",
    "homepage_uri"      => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri"   => "https://github.com/piotrmurach/tty-link"
  }
  spec.files         = Dir["lib/**/*"]
  spec.extra_rdoc_files = ["CHANGELOG.md", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0"
end
