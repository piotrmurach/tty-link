# frozen_string_literal: true

RSpec.describe TTY::Link, "#support_link" do
  let(:output) { double(:output) }

  before {
    allow(ENV).to receive(:[]).and_return(nil)
    allow(output).to receive(:tty?).and_return(true)
  }

  describe "non TTY device" do
    it "doesn't support links" do
      allow(output).to receive(:tty?).and_return(false)

      expect(described_class.support_link?(output: output)).to eq(false)
    end
  end

  describe "unknown terminal" do
    it "doesn't support links" do
      expect(described_class.support_link?(output: output)).to eq(false)
    end
  end

  describe "iTerm" do
    before {
      allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("iTerm.app")
    }

    it "supports a terminal program name with a version number" do
      allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("iTerm 2.app")
      allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION")
                                .and_return("4.3.2")

      expect(described_class.support_link?(output: output)).to eq(true)
    end

    it "supports links above the 4.3.2 version" do
      allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION")
                                .and_return("4.3.2")

      expect(described_class.support_link?(output: output)).to eq(true)
    end

    it "supports links above the 3.1.0 version" do
      allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION")
                                .and_return("3.2.1")

      expect(described_class.support_link?(output: output)).to eq(true)
    end

    it "supports links on the 3.1.0 version" do
      allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION")
                                .and_return("3.1.0")

      expect(described_class.support_link?(output: output)).to eq(true)
    end

    it "doesn't support links on the 3.0.1 version" do
      allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION")
                                .and_return("3.0.1")

      expect(described_class.support_link?(output: output)).to eq(false)
    end

    it "doesn't support links below the 3.1.0 version" do
      allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION")
                                .and_return("2.3.4")

      expect(described_class.support_link?(output: output)).to eq(false)
    end

    it "doesn't support links without a version" do
      allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION").and_return(nil)

      expect(described_class.support_link?(output: output)).to eq(false)
    end
  end

  describe "VTE" do
    it "supports links above the 1.0.0 version" do
      allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("1.0.0")

      expect(described_class.support_link?(output: output)).to eq(true)
    end

    it "supports links above the 0.51.0 version" do
      allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("0.51.0")

      expect(described_class.support_link?(output: output)).to eq(true)
    end

    it "supports links above the 0.50.1 version" do
      allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("0.50.1")

      expect(described_class.support_link?(output: output)).to eq(true)
    end

    it "doesn't support links on the 0.50.0 version" do
      allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("0.50.0")

      expect(described_class.support_link?(output: output)).to eq(false)
    end

    it "doesn't support links below the 0.50.0 version" do
      allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("0.49.0")

      expect(described_class.support_link?(output: output)).to eq(false)
    end
  end
end
