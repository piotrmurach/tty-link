# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Contour, "#link?" do
  let(:env_with_name) { {"TERMINAL_NAME" => "contour"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the terminal name environment variable" do
    contour = described_class.new(semantic_version, {})

    expect(contour.link?).to eq(false)
  end

  it "doesn't support links without a terminal name" do
    env = {"TERMINAL_NAME" => nil}
    contour = described_class.new(semantic_version, env)

    expect(contour.link?).to eq(false)
  end

  it "doesn't support links with a different terminal name" do
    env = {"TERMINAL_NAME" => "other-terminal"}
    contour = described_class.new(semantic_version, env)

    expect(contour.link?).to eq(false)
  end

  it "doesn't support links with a different name and a compatible version" do
    env = {
      "TERMINAL_NAME" => "other-terminal",
      "TERMINAL_VERSION_TRIPLE" => "1.0.0"
    }
    contour = described_class.new(semantic_version, env)

    expect(contour.link?).to eq(false)
  end

  it "supports links above the 1.0.0 version" do
    env = {
      "TERMINAL_NAME" => "Contour",
      "TERMINAL_VERSION_TRIPLE" => "1.0.0"
    }
    contour = described_class.new(semantic_version, env)

    expect(contour.link?).to eq(true)
  end

  it "supports links above the 0.1.0 version" do
    env = env_with_name.merge({"TERMINAL_VERSION_TRIPLE" => "0.4.1"})
    contour = described_class.new(semantic_version, env)

    expect(contour.link?).to eq(true)
  end

  it "supports links on the 0.1.0 version" do
    env = env_with_name.merge({"TERMINAL_VERSION_TRIPLE" => "0.1.0"})
    contour = described_class.new(semantic_version, env)

    expect(contour.link?).to eq(true)
  end

  it "doesn't support links below the 0.1.0 version" do
    env = env_with_name.merge({"TERMINAL_VERSION_TRIPLE" => "0.0.1"})
    contour = described_class.new(semantic_version, env)

    expect(contour.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERMINAL_VERSION_TRIPLE" => nil})
    contour = described_class.new(semantic_version, env)

    expect(contour.link?).to eq(false)
  end

  it "doesn't support links without the terminal version triple env variable" do
    contour = described_class.new(semantic_version, env_with_name)

    expect(contour.link?).to eq(false)
  end

  it "doesn't compare versions without the terminal version triple" do
    semantic_version_spy = class_spy(semantic_version)
    contour = described_class.new(semantic_version_spy, env_with_name)

    contour.link?

    expect(semantic_version_spy).not_to have_received(:from)
  end
end
