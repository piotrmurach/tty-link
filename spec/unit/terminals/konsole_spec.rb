# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Konsole, "#link?" do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports links above the 24.08.0 version" do
    env = {"KONSOLE_VERSION" => "25.04.33"}
    konsole = described_class.new(semantic_version, env)

    expect(konsole.link?).to eq(true)
  end

  it "supports links above the 20.12.0 version" do
    env = {"KONSOLE_VERSION" => "20.12.1"}
    konsole = described_class.new(semantic_version, env)

    expect(konsole.link?).to eq(true)
  end

  it "supports links on the 20.12.0 version" do
    env = {"KONSOLE_VERSION" => "20.12.0"}
    konsole = described_class.new(semantic_version, env)

    expect(konsole.link?).to eq(true)
  end

  it "doesn't support links below the 20.12.0 version" do
    env = {"KONSOLE_VERSION" => "20.11.90"}
    konsole = described_class.new(semantic_version, env)

    expect(konsole.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = {"KONSOLE_VERSION" => nil}
    konsole = described_class.new(semantic_version, env)

    expect(konsole.link?).to eq(false)
  end

  it "doesn't support links without the Konsole version environment variable" do
    domterm = described_class.new(semantic_version, {})

    expect(domterm.link?).to eq(false)
  end
end
