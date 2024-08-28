# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Wt, "#link?" do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports links on any version" do
    env = {"WT_SESSION" => "123-abc"}
    wt = described_class.new(semantic_version, env)

    expect(wt.link?).to eq(true)
  end

  it "doesn't support links without the wt session identifier value" do
    env = {"WT_SESSION" => nil}
    wt = described_class.new(semantic_version, env)

    expect(wt.link?).to eq(false)
  end

  it "doesn't support links without the wt session environment variable" do
    wt = described_class.new(semantic_version, {})

    expect(wt.link?).to eq(false)
  end
end
