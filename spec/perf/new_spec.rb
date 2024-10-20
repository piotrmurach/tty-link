# frozen_string_literal: true

require "rspec-benchmark"

RSpec.describe TTY::Link, ".new" do
  include RSpec::Benchmark::Matchers

  context "with defaults" do
    it "performs at least 2.5M i/s" do
      expect { TTY::Link.new }.to perform_at_least(2_500_000).ips
    end

    it "allocates 6 objects" do
      expect { TTY::Link.new }.to perform_allocation(6).objects
    end
  end

  context "with hyperlink environment variable" do
    it "performs at least 2.4M i/s" do
      env_with_hyperlink = {"TTY_LINK_HYPERLINK" => "always"}

      expect {
        TTY::Link.new(env: env_with_hyperlink)
      }.to perform_at_least(2_400_000).ips
    end

    it "allocates 6 objects" do
      env_with_hyperlink = {"TTY_LINK_HYPERLINK" => "always"}

      expect {
        TTY::Link.new(env: env_with_hyperlink)
      }.to perform_allocation(6).objects
    end
  end
end
