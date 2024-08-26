# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Tabby, "#link?" do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports links on any version" do
    env = {"TERM_PROGRAM" => "Tabby"}
    tabby = described_class.new(semantic_version, env)

    expect(tabby.link?).to eq(true)
  end

  it "supports links with a terminal name in lowercase" do
    env = {"TERM_PROGRAM" => "tabby"}
    tabby = described_class.new(semantic_version, env)

    expect(tabby.link?).to eq(true)
  end

  it "doesn't support links with a non-Tabby program name" do
    env = {"TERM_PROGRAM" => "other-terminal"}
    tabby = described_class.new(semantic_version, env)

    expect(tabby.link?).to eq(false)
  end

  it "doesn't support links without the term program environment variable" do
    tabby = described_class.new(semantic_version, {})

    expect(tabby.link?).to eq(false)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    tabby = described_class.new(semantic_version, env)

    expect(tabby.link?).to eq(false)
  end
end
