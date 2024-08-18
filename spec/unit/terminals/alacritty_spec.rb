# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Alacritty, "#link?" do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports links on any version" do
    env = {"TERM" => "alacritty"}
    alacritty = described_class.new(semantic_version, env)

    expect(alacritty.link?).to eq(true)
  end

  it "supports a terminal name with a '-direct' suffix" do
    env = {"TERM" => "Alacritty-direct"}
    alacritty = described_class.new(semantic_version, env)

    expect(alacritty.link?).to eq(true)
  end

  it "doesn't support links without a terminal name" do
    env = {"TERM" => nil}
    alacritty = described_class.new(semantic_version, env)

    expect(alacritty.link?).to eq(false)
  end

  it "doesn't support links with a non-Alacritty terminal name" do
    env = {"TERM" => "other-terminal"}
    alacritty = described_class.new(semantic_version, env)

    expect(alacritty.link?).to eq(false)
  end
end
