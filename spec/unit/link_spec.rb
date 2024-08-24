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

    context "when Alacritty" do
      it "supports links on any version" do
        env = {"TERM" => "alacritty"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Contour" do
      it "supports a terminal name with a version number" do
        env = {
          "TERMINAL_NAME" => "contour",
          "TERMINAL_VERSION_TRIPLE" => "0.1.0"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when DomTerm" do
      it "supports links above the 1.0.2 version" do
        env = {"DOMTERM" => "QtDomTerm;version=1.0.2;tty=/dev/pts/1"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
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
      it "supports links above the 0.50.1 version" do
        env = {"VTE_VERSION" => "5001"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end
  end
end
