# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Contour, "#link?" do
  let(:env_with_name) { {"TERMINAL_NAME" => "contour"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without a terminal name" do
    env = {"TERMMINAL_NAME" => nil}
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
end
