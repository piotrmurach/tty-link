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

    context "when Foot" do
      it "supports links on any version" do
        env = {"TERM" => "foot"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Ghostty" do
      it "supports links above the 1.0.0 version" do
        env = {"TERM_PROGRAM" => "ghostty", "TERM_PROGRAM_VERSION" => "1.0.1"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Hyper" do
      it "supports links above the 2.0.0 version" do
        env = {
          "TERM_PROGRAM" => "Hyper",
          "TERM_PROGRAM_VERSION" => "3.4.1"
        }
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

    context "when JediTerm" do
      it "supports links on any version" do
        env = {"TERMINAL_EMULATOR" => "JetBrains-JediTerm"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when kitty" do
      it "supports links on any version" do
        env = {"TERM" => "xterm-kitty"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Konsole" do
      it "supports links above the 20.12.0 version" do
        env = {"KONSOLE_VERSION" => "20.12.0"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when mintty" do
      it "supports links above the 2.9.7 version" do
        env = {
          "TERM_PROGRAM" => "mintty",
          "TERM_PROGRAM_VERSION" => "2.9.7"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Rio" do
      it "supports links above the 0.0.28 version" do
        env = {
          "TERM_PROGRAM" => "rio",
          "TERM_PROGRAM_VERSION" => "0.0.28"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Tabby" do
      it "supports links on any version" do
        env = {"TERM_PROGRAM" => "Tabby"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Terminology" do
      it "supports links above the 1.3.0 version" do
        env = {
          "TERM_PROGRAM" => "terminology",
          "TERM_PROGRAM_VERSION" => "1.3.0"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when VSCode" do
      it "supports links above the 1.72.0 version" do
        env = {
          "TERM_PROGRAM" => "vscode",
          "TERM_PROGRAM_VERSION" => "1.72.0"
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

    context "when WezTerm" do
      it "supports links above the 20180218 version" do
        env = {
          "TERM_PROGRAM" => "WezTerm",
          "TERM_PROGRAM_VERSION" => "20180218-123-abc"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Windows Terminal" do
      it "supports links on any version" do
        env = {"WT_SESSION" => "123-abc"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end
  end
end
