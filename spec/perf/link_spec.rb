# frozen_string_literal: true

require "rspec-benchmark"

RSpec.describe TTY::Link, "#link?" do
  include RSpec::Benchmark::Matchers

  context "when Alacritty" do
    let(:env_with_alacritty) { {"TERM" => "alacritty"} }

    it "performs 2.5x slower than IO#tty?" do
      link = described_class.new(env: env_with_alacritty)

      expect {
        link.link?
      }.to perform_slower_than {
        $stdout.tty?
      }.at_most(2.5).times
    end

    it "performs at least 1.6M i/s" do
      link = described_class.new(env: env_with_alacritty)

      expect { link.link? }.to perform_at_least(1_600_000).ips
    end

    it "allocates 21 objects" do
      link = described_class.new(env: env_with_alacritty)

      expect { link.link? }.to perform_allocation(21).objects
    end
  end

  context "when all terminals" do
    it "performs 8x slower than IO#tty" do
      link = described_class.new(env: {})

      expect {
        link.link?
      }.to perform_slower_than {
        $stdout.tty?
      }.at_most(8).times
    end

    it "performs at least 470K i/s" do
      link = described_class.new(env: {})

      expect { link.link? }.to perform_at_least(470_000).ips
    end

    it "allocates 39 objects" do
      link = described_class.new(env: {})

      expect { link.link? }.to perform_allocation(39).objects
    end
  end
end
