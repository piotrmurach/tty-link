# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Vte do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports links above the 0.76.3 version" do
    env = {"VTE_VERSION" => "7603"}
    vte = described_class.new(semantic_version, env)

    expect(vte.link?).to eq(true)
  end

  it "supports links above the 0.51.0 version" do
    env = {"VTE_VERSION" => "5100"}
    vte = described_class.new(semantic_version, env)

    expect(vte.link?).to eq(true)
  end

  it "supports links above the 0.50.1 version" do
    env = {"VTE_VERSION" => "5001"}
    vte = described_class.new(semantic_version, env)

    expect(vte.link?).to eq(true)
  end

  it "doesn't support links on the 0.50.0 version" do
    env = {"VTE_VERSION" => "5000"}
    vte = described_class.new(semantic_version, env)

    expect(vte.link?).to eq(false)
  end

  it "doesn't support links below the 0.50.0 version" do
    env = {"VTE_VERSION" => "4999"}
    vte = described_class.new(semantic_version, env)

    expect(vte.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = {"VTE_VERSION" => nil}
    vte = described_class.new(semantic_version, env)

    expect(vte.link?).to eq(false)
  end
end
