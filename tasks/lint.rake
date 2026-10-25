# frozen_string_literal: true

desc "Lint all code"
task :lint do
  run_rubocop(%w[bin lib spec tasks Gemfile Rakefile *.gemspec])
end

namespace :lint do
  desc "Lint scripts"
  task :bin do
    run_rubocop(%w[bin])
  end

  desc "Lint Gemfile"
  task :gemfile do
    run_rubocop(%w[Gemfile])
  end

  desc "Lint gemspec"
  task :gemspec do
    run_rubocop(%w[*.gemspec])
  end

  desc "Lint source"
  task :lib do
    run_rubocop(%w[lib])
  end

  desc "Lint specs"
  task :spec do
    run_rubocop(%w[spec])
  end

  desc "Lint tasks"
  task :task do
    run_rubocop(%w[tasks Rakefile])
  end
end

def run_rubocop(*args)
  abort if require_rubocop.nil?

  status = RuboCop::CLI.new.run(*args)
  exit(status) if status.nonzero?
end

def require_rubocop
  require "rubocop"
rescue LoadError
  warn "In order to run the lint tasks, do `bundle install`."
end
