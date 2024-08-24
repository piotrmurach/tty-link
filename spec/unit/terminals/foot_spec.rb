# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Foot, "#link?" do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports links on any version" do
    env = {"TERM" => "foot"}
    foot = described_class.new(semantic_version, env)

    expect(foot.link?).to eq(true)
  end

  it "supports a terminal name with a '-direct' suffix" do
    env = {"TERM" => "Foot-direct"}
    foot = described_class.new(semantic_version, env)

    expect(foot.link?).to eq(true)
  end

  it "doesn't support links without a terminal name" do
    env = {"TERM" => nil}
    foot = described_class.new(semantic_version, env)

    expect(foot.link?).to eq(false)
  end

  it "doesn't support links with a non-Foot terminal name" do
    env = {"TERM" => "other-terminal"}
    foot = described_class.new(semantic_version, env)

    expect(foot.link?).to eq(false)
  end
end
