# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Kitty, "#link?" do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports links on any version" do
    env = {"TERM" => "xterm-kitty"}
    kitty = described_class.new(semantic_version, env)

    expect(kitty.link?).to eq(true)
  end

  it "supports a terminal name without the 'xterm-' prefix" do
    env = {"TERM" => "Kitty"}
    kitty = described_class.new(semantic_version, env)

    expect(kitty.link?).to eq(true)
  end

  it "doesn't support links without a terminal name" do
    env = {"TERM" => nil}
    kitty = described_class.new(semantic_version, env)

    expect(kitty.link?).to eq(false)
  end

  it "doesn't support links with a non-kitty terminal name" do
    env = {"TERM" => "other-terminal"}
    kitty = described_class.new(semantic_version, env)

    expect(kitty.link?).to eq(false)
  end
end
