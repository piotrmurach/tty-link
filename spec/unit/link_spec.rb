# frozen_string_literal: true

RSpec.describe TTY::Link, ".link?" do
  let(:output) { double(:output, tty?: true) }

  describe "non TTY device" do
    it "doesn't support links" do
      allow(output).to receive(:tty?).and_return(false)

      expect(described_class.link?(output: output)).to eq(false)
    end
  end

  describe "unknown terminal" do
    it "doesn't support links" do
      expect(described_class.link?(env: {}, output: output)).to eq(false)
    end
  end

  describe "iTerm" do
    let(:env_with_name) { {"TERM_PROGRAM" => "iTerm.app"} }

    it "supports a terminal program name with a version number" do
      env = {
        "TERM_PROGRAM" => "iTerm 2.app",
        "TERM_PROGRAM_VERSION" => "4.3.2"
      }

      expect(described_class.link?(env: env, output: output)).to eq(true)
    end

    it "supports links above the 4.3.2 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "4.3.2"})

      expect(described_class.link?(env: env, output: output)).to eq(true)
    end

    it "supports links above the 3.1.0 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.2.1"})

      expect(described_class.link?(env: env, output: output)).to eq(true)
    end

    it "supports links on the 3.1.0 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.1.0"})

      expect(described_class.link?(env: env, output: output)).to eq(true)
    end

    it "doesn't support links on the 3.0.1 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.0.1"})

      expect(described_class.link?(env: env, output: output)).to eq(false)
    end

    it "doesn't support links below the 3.1.0 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.3.4"})

      expect(described_class.link?(env: env, output: output)).to eq(false)
    end

    it "doesn't support links without a version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})

      expect(described_class.link?(env: env, output: output)).to eq(false)
    end
  end

  describe "VTE" do
    it "supports links above the 0.76.3 version" do
      env = {"VTE_VERSION" => "7603"}

      expect(described_class.link?(env: env, output: output)).to eq(true)
    end

    it "supports links above the 0.51.0 version" do
      env = {"VTE_VERSION" => "5100"}

      expect(described_class.link?(env: env, output: output)).to eq(true)
    end

    it "supports links above the 0.50.1 version" do
      env = {"VTE_VERSION" => "5001"}

      expect(described_class.link?(env: env, output: output)).to eq(true)
    end

    it "doesn't support links on the 0.50.0 version" do
      env = {"VTE_VERSION" => "5000"}

      expect(described_class.link?(env: env, output: output)).to eq(false)
    end

    it "doesn't support links below the 0.50.0 version" do
      env = {"VTE_VERSION" => "4999"}

      expect(described_class.link?(env: env, output: output)).to eq(false)
    end

    it "doesn't support links without a version" do
      env = {"VTE_VERSION" => nil}

      expect(described_class.link?(env: env, output: output)).to eq(false)
    end
  end
end
