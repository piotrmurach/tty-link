# frozen_string_literal: true

RSpec.describe TTY::Link do
  let(:output) { instance_double(IO, tty?: true) }

  describe ".link?" do
    context "when the output is not a terminal" do
      it "doesn't support links" do
        allow(output).to receive(:tty?).and_return(false)

        expect(described_class.link?(output: output)).to eq(false)
      end
    end

    context "when no supported terminal is detected" do
      it "doesn't support links" do
        expect(described_class.link?(env: {}, output: output)).to eq(false)
      end
    end

    context "when iTerm is detected" do
      it "supports links" do
        env = {
          "TERM_PROGRAM" => "iTerm.app",
          "TERM_PROGRAM_VERSION" => "4.3.2"
        }

        expect(described_class.link?(env: env, output: output)).to eq(true)
      end
    end
  end

  describe "#link?" do
    context "when the output is not a terminal" do
      it "doesn't support links" do
        allow(output).to receive(:tty?).and_return(false)

        expect(described_class.new(output: output).link?).to eq(false)
      end
    end

    context "when no supported terminal is detected" do
      it "doesn't support links" do
        expect(described_class.new(env: {}, output: output).link?).to eq(false)
      end
    end

    context "when Alacritty is detected" do
      it "supports links on any version" do
        env = {"TERM" => "alacritty"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Contour is detected" do
      it "supports links from version 0.1.0" do
        env = {
          "TERMINAL_NAME" => "contour",
          "TERMINAL_VERSION_TRIPLE" => "0.1.0"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when DomTerm is detected" do
      it "supports links from version 1.0.2" do
        env = {"DOMTERM" => "QtDomTerm;version=1.0.2;tty=/dev/pts/1"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Foot is detected" do
      it "supports links on any version" do
        env = {"TERM" => "foot"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Hyper is detected" do
      it "supports links from version 2.0.0" do
        env = {
          "TERM_PROGRAM" => "Hyper",
          "TERM_PROGRAM_VERSION" => "3.4.1"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when iTerm is detected" do
      it "supports links from version 3.1.0" do
        env = {
          "TERM_PROGRAM" => "iTerm.app",
          "TERM_PROGRAM_VERSION" => "3.1.0"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when JediTerm is detected" do
      it "supports links on any version" do
        env = {"TERMINAL_EMULATOR" => "JetBrains-JediTerm"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when kitty is detected" do
      it "supports links on any version" do
        env = {"TERM" => "xterm-kitty"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Konsole is detected" do
      it "supports links from version 20.12.0" do
        env = {"KONSOLE_VERSION" => "20.12.0"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when mintty is detected" do
      it "supports links from version 2.9.7" do
        env = {
          "TERM_PROGRAM" => "mintty",
          "TERM_PROGRAM_VERSION" => "2.9.7"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Rio is detected" do
      it "supports links from version 0.0.28" do
        env = {
          "TERM_PROGRAM" => "rio",
          "TERM_PROGRAM_VERSION" => "0.0.28"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Tabby is detected" do
      it "supports links on any version" do
        env = {"TERM_PROGRAM" => "Tabby"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Terminology is detected" do
      it "supports links from version 1.3.0" do
        env = {
          "TERM_PROGRAM" => "terminology",
          "TERM_PROGRAM_VERSION" => "1.3.0"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when VS Code is detected" do
      it "supports links from version 1.72.0" do
        env = {
          "TERM_PROGRAM" => "vscode",
          "TERM_PROGRAM_VERSION" => "1.72.0"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when VTE is detected" do
      it "supports links from version 0.50.1" do
        env = {"VTE_VERSION" => "5001"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when WezTerm is detected" do
      it "supports links from version 20180218" do
        env = {
          "TERM_PROGRAM" => "WezTerm",
          "TERM_PROGRAM_VERSION" => "20180218-123-abc"
        }
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end

    context "when Windows Terminal is detected" do
      it "supports links on any version" do
        env = {"WT_SESSION" => "123-abc"}
        link = described_class.new(env: env, output: output)

        expect(link.link?).to eq(true)
      end
    end
  end
end
