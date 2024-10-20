# frozen_string_literal: true

require "erb"
require "rspec-benchmark"

RSpec.describe TTY::Link, "#link_to" do
  include RSpec::Benchmark::Matchers

  context "when hyperlink is always" do
    it "performs 6.5x faster than ERB#result" do
      name = "TTY Toolkit"
      url = "https://ttytoolkit.org"
      erb = ERB.new("<%= url %>")
      link = described_class.new(env: {}, hyperlink: :always)

      expect {
        link.link_to(name, url)
      }.to perform_faster_than {
        erb.result(binding)
      }.at_least(6.5).times
    end

    it "performs at least 1.75M i/s" do
      name = "TTY Toolkit"
      url = "https://ttytoolkit.org"
      link = described_class.new(env: {}, hyperlink: :always)

      expect { link.link_to(name, url) }.to perform_at_least(1_750_000).ips
    end

    it "allocates 10 objects" do
      name = "TTY Toolkit"
      url = "https://ttytoolkit.org"
      link = described_class.new(env: {}, hyperlink: :always)

      expect { link.link_to(name, url) }.to perform_allocation(10).objects
    end
  end

  context "when hyperlink is auto" do
    context "when Alacritty" do
      let(:env_with_alacritty) { {"TERM" => "alacritty"} }

      it "performs 3x faster than ERB#result" do
        name = "TTY Toolkit"
        url = "https://ttytoolkit.org"
        erb = ERB.new("<%= url %>")
        link = described_class.new(env: env_with_alacritty)

        expect {
          link.link_to(name, url)
        }.to perform_faster_than {
          erb.result(binding)
        }.at_least(3).times
      end

      it "performs at least 800K i/s" do
        name = "TTY Toolkit"
        url = "https://ttytoolkit.org"
        link = described_class.new(env: env_with_alacritty)

        expect { link.link_to(name, url) }.to perform_at_least(800_000).ips
      end

      it "allocates 31 objects" do
        name = "TTY Toolkit"
        url = "https://ttytoolkit.org"
        link = described_class.new(env: env_with_alacritty)

        expect { link.link_to(name, url) }.to perform_allocation(31).objects
      end
    end

    context "when all terminals" do
      it "performs 1.25x faster than ERB#result" do
        name = "TTY Toolkit"
        url = "https://ttytoolkit.org"
        erb = ERB.new("<%= url %>")
        link = described_class.new(env: {})

        expect {
          link.link_to(name, url)
        }.to perform_faster_than {
          erb.result(binding)
        }.at_least(1.25).times
      end

      it "performs at least 320K i/s" do
        name = "TTY Toolkit"
        url = "https://ttytoolkit.org"
        link = described_class.new(env: {})

        expect { link.link_to(name, url) }.to perform_at_least(320_000).ips
      end

      it "allocates 49 objects" do
        name = "TTY Toolkit"
        url = "https://ttytoolkit.org"
        link = described_class.new(env: {})

        expect { link.link_to(name, url) }.to perform_allocation(49).objects
      end
    end
  end

  context "when hyperlink is never" do
    it "performs 3.5x faster than ERB#result" do
      name = "TTY Toolkit"
      url = "https://ttytoolkit.org"
      erb = ERB.new("<%= url %>")
      link = described_class.new(env: {}, hyperlink: :never)

      expect {
        link.link_to(name, url)
      }.to perform_faster_than {
        erb.result(binding)
      }.at_least(3.5).times
    end

    it "performs at least 970K i/s" do
      name = "TTY Toolkit"
      url = "https://ttytoolkit.org"
      link = described_class.new(env: {}, hyperlink: :never)

      expect { link.link_to(name, url) }.to perform_at_least(970_000).ips
    end

    it "allocates 10 objects" do
      name = "TTY Toolkit"
      url = "https://ttytoolkit.org"
      link = described_class.new(env: {}, hyperlink: :never)

      expect { link.link_to(name, url) }.to perform_allocation(10).objects
    end
  end
end
