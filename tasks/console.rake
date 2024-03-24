# frozen_string_literal: true

desc "Load gem inside IRB console"
task :console do
  require "irb"
  require "irb/completion"
  require_relative "../lib/tty-link"
  ARGV.clear
  IRB.start
end

desc "Alias for the :console task"
task c: :console
