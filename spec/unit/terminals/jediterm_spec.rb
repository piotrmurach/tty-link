# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Jediterm, "#link?" do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports links on any version" do
    env = {"TERMINAL_EMULATOR" => "JetBrains-JediTerm"}
    jediterm = described_class.new(semantic_version, env)

    expect(jediterm.link?).to eq(true)
  end

  it "supports a terminal name without the 'JetBrains-' prefix" do
    env = {"TERMINAL_EMULATOR" => "jediterm"}
    jediterm = described_class.new(semantic_version, env)

    expect(jediterm.link?).to eq(true)
  end

  it "doesn't support links without a terminal name" do
    env = {"TERMINAL_EMULATOR" => nil}
    jediterm = described_class.new(semantic_version, env)

    expect(jediterm.link?).to eq(false)
  end

  it "doesn't support links with a non-JediTerm terminal name" do
    env = {"TERMINAL_EMULATOR" => "other-terminal"}
    jediterm = described_class.new(semantic_version, env)

    expect(jediterm.link?).to eq(false)
  end
end
