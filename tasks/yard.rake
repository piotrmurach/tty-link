# frozen_string_literal: true

namespace :yard do
  desc "Measure documentation coverage"
  task :cov do
    abort if yardstick_missing?

    measurements = Yardstick::CLI.run("lib/**/*.rb")
    abort if measurements.failed.nonzero?
  end
end

def yardstick_missing?
  require_or_inform("yardstick", "yardstick/cli").nil?
end

def require_or_inform(*dependencies)
  dependencies.each do |dependency|
    require dependency
  end
rescue LoadError
  warn "In order to run the yard tasks, do `bundle install`."
end
