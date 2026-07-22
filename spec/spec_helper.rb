# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "coveralls"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ])

  SimpleCov.start do
    command_name "spec"
    add_filter "spec"
    enable_coverage :branch
  end
end

require "bundler/setup"
require "tty-link"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.expect_with :rspec do |expectations|
    expectations.max_formatted_output_length = nil
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
  config.disable_monkey_patching!
end
