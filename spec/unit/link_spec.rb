# frozen_string_literal: true

RSpec.describe TTY::Link do
  let(:output) { double(:output, tty?: true) }

  describe ".link?" do
    context "when non TTY device" do
      it "doesn't support links" do
        allow(output).to receive(:tty?).and_return(false)

        expect(described_class.link?(output: output)).to eq(false)
      end
    end

    context "when unknown terminal" do
      it "doesn't support links" do
        expect(described_class.link?(env: {}, output: output)).to eq(false)
      end
    end

    context "when iTerm" do
      it "supports a terminal program name with a version number" do
        env = {
          "TERM_PROGRAM" => "iTerm.app",
          "TERM_PROGRAM_VERSION" => "4.3.2"
        }

        expect(described_class.link?(env: env, output: output)).to eq(true)
      end
    end
  end

  describe "#link?" do
    context "when non TTY device" do
      it "doesn't support links" do
        allow(output).to receive(:tty?).and_return(false)

        expect(described_class.new(output: output).link?).to eq(false)
      end
    end

    context "when unknown terminal" do
      it "doesn't support links" do
        expect(described_class.new(env: {}, output: output).link?).to eq(false)
      end
    end

    context "when iTerm" do
      it "supports a terminal program name with a version number" do
        env = {
          "TERM_PROGRAM" => "iTerm.app",
          "TERM_PROGRAM_VERSION" => "3.1.0"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when VTE" do
      it "supports links above the 0.76.3 version" do
        env = {"VTE_VERSION" => "7603"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end

      it "supports links above the 0.51.0 version" do
        env = {"VTE_VERSION" => "5100"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end

      it "supports links above the 0.50.1 version" do
        env = {"VTE_VERSION" => "5001"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end

      it "doesn't support links on the 0.50.0 version" do
        env = {"VTE_VERSION" => "5000"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(false)
      end

      it "doesn't support links below the 0.50.0 version" do
        env = {"VTE_VERSION" => "4999"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(false)
      end

      it "doesn't support links without a version" do
        env = {"VTE_VERSION" => nil}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(false)
      end
    end
  end
end
