# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "coveralls"
  require "simplecov"

  SimpleCov.configure do
    command_name "spec"
    enable_coverage :branch
    formatters [
      SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter
    ]
    project_name "TTY::Link"
  end

  SimpleCov.start
end

require "bundler/setup"
require "tty-link"

RSpec.configure do |config|
  config.default_formatter = :documentation if config.files_to_run.one?
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
