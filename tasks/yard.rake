# frozen_string_literal: true

namespace :yard do
  desc "Measure documentation coverage"
  task :cov do
    abort if require_yardstick.nil?

    measurements = Yardstick::CLI.run("lib/**/*.rb")
    abort if measurements.failed.nonzero?
  end
end

def require_yardstick
  require "yardstick"
  require "yardstick/cli"
rescue LoadError
  warn "In order to run the yard task, do `bundle install`."
end
