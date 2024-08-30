# frozen_string_literal: true

RSpec.describe TTY::Link do
  let(:env) {
    {
      "TERM_PROGRAM" => "iTerm.app",
      "TERM_PROGRAM_VERSION" => "4.3.2"
    }
  }
  let(:output) { double(:output, tty?: true) }

  describe ".link_to" do
    context "when unsupported terminal" do
      it "createa a terminal link replacement" do
        linked = described_class.link_to(
          "TTY Toolkit", "https://ttytoolkit.org", env: {}, output: output
        )

        expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
      end

      it "creates a terminal link replacement from a single argument" do
        linked = described_class.link_to(
          "https://ttytoolkit.org", env: {}, output: output
        )

        expect(linked).to eql(
          "https://ttytoolkit.org -> https://ttytoolkit.org"
        )
      end
    end

    context "when supported terminal" do
      it "creates a terminal link" do
        linked = described_class.link_to(
          "TTY Toolkit", "https://ttytoolkit.org", env: env, output: output
        )

        expect(linked)
          .to eql("\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a")
      end

      it "creates a terminal link from a single argument" do
        linked = described_class.link_to(
          "https://ttytoolkit.org", env: env, output: output
        )

        expect(linked).to eql(
          "\e]8;;https://ttytoolkit.org\ahttps://ttytoolkit.org\e]8;;\a"
        )
      end
    end
  end

  describe "#link_to" do
    context "when unsupported terminal" do
      it "creates a terminal link replacement" do
        link = described_class.new(env: {}, output: output)
        linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

        expect(linked).to eql("TTY Toolkit -> https://ttytoolkit.org")
      end

      it "creates a terminal link replacement from a single argument" do
        link = described_class.new(env: {}, output: output)
        linked = link.link_to("https://ttytoolkit.org")

        expect(linked).to eql(
          "https://ttytoolkit.org -> https://ttytoolkit.org"
        )
      end
    end

    context "when supported terminal" do
      it "creates a terminal link" do
        link = described_class.new(env: env, output: output)
        linked = link.link_to("TTY Toolkit", "https://ttytoolkit.org")

        expect(linked)
          .to eql("\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a")
      end

      it "creates a terminal link from a single argument" do
        link = described_class.new(env: env, output: output)
        linked = link.link_to("https://ttytoolkit.org")

        expect(linked).to eql(
          "\e]8;;https://ttytoolkit.org\ahttps://ttytoolkit.org\e]8;;\a"
        )
      end
    end
  end
end
