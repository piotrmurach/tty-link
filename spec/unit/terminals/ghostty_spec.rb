# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Ghostty, "#link?" do
  let(:env_with_name) { {"TERM_PROGRAM" => "ghostty"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the term program environment variable" do
    ghostty = described_class.new(semantic_version, {})

    expect(ghostty.link?).to eq(false)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    ghostty = described_class.new(semantic_version, env)

    expect(ghostty.link?).to eq(false)
  end

  it "doesn't support links with a non-Ghostty program name" do
    env = {"TERM_PROGRAM" => "other-terminal"}
    ghostty = described_class.new(semantic_version, env)

    expect(ghostty.link?).to eq(false)
  end

  it "supports links above the 2.0.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.3.4"})
    ghostty = described_class.new(semantic_version, env)

    expect(ghostty.link?).to eq(true)
  end

  it "supports links above the 1.0.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.0.1"})
    ghostty = described_class.new(semantic_version, env)

    expect(ghostty.link?).to eq(true)
  end

  it "supports links on the 1.0.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.0.0"})
    ghostty = described_class.new(semantic_version, env)

    expect(ghostty.link?).to eq(true)
  end

  it "supports links on the 1.0.0 version with a mixed-case program name" do
    env = {"TERM_PROGRAM" => "GhosTTY", "TERM_PROGRAM_VERSION" => "1.0.0"}
    ghostty = described_class.new(semantic_version, env)

    expect(ghostty.link?).to eq(true)
  end

  it "doesn't support links below the 1.0.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "0.9.2"})
    ghostty = described_class.new(semantic_version, env)

    expect(ghostty.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
    ghostty = described_class.new(semantic_version, env)

    expect(ghostty.link?).to eq(false)
  end

  it "doesn't support links without the term program version env variable" do
    ghostty = described_class.new(semantic_version, env_with_name)

    expect(ghostty.link?).to eq(false)
  end
end
