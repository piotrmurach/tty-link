# frozen_string_literal: true

RSpec.describe TTY::Link, "#support_link" do
  let(:output) { double(:output, tty?: true) }

  describe "non TTY device" do
    it "doesn't support links" do
      allow(output).to receive(:tty?).and_return(false)

      expect(described_class.support_link?(output: output)).to eq(false)
    end
  end

  describe "unknown terminal" do
    it "doesn't support links" do
      link_supported = described_class.support_link?(env: {}, output: output)

      expect(link_supported).to eq(false)
    end
  end

  describe "iTerm" do
    let(:env_with_name) { {"TERM_PROGRAM" => "iTerm.app"} }

    it "supports a terminal program name with a version number" do
      env = {
        "TERM_PROGRAM" => "iTerm 2.app",
        "TERM_PROGRAM_VERSION" => "4.3.2"
      }
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(true)
    end

    it "supports links above the 4.3.2 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "4.3.2"})
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(true)
    end

    it "supports links above the 3.1.0 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.2.1"})
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(true)
    end

    it "supports links on the 3.1.0 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.1.0"})
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(true)
    end

    it "doesn't support links on the 3.0.1 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.0.1"})
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(false)
    end

    it "doesn't support links below the 3.1.0 version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.3.4"})
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(false)
    end

    it "doesn't support links without a version" do
      env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(false)
    end
  end

  describe "VTE" do
    it "supports links above the 0.76.3 version" do
      env = {"VTE_VERSION" => "7603"}
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(true)
    end

    it "supports links above the 0.51.0 version" do
      env = {"VTE_VERSION" => "5100"}
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(true)
    end

    it "supports links above the 0.50.1 version" do
      env = {"VTE_VERSION" => "5001"}
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(true)
    end

    it "doesn't support links on the 0.50.0 version" do
      env = {"VTE_VERSION" => "5000"}
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(false)
    end

    it "doesn't support links below the 0.50.0 version" do
      env = {"VTE_VERSION" => "4999"}
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(false)
    end

    it "doesn't support links without a version" do
      env = {"VTE_VERSION" => nil}
      link_supported = described_class.support_link?(env: env, output: output)

      expect(link_supported).to eq(false)
    end
  end
end
