# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Terminology, "#link?" do
  let(:env_with_name) { {"TERM_PROGRAM" => "terminology"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the term program environment variable" do
    terminology = described_class.new(semantic_version, {})

    expect(terminology.link?).to eq(false)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    terminology = described_class.new(semantic_version, env)

    expect(terminology.link?).to eq(false)
  end

  it "doesn't support links with a non-Terminology program name" do
    env = {"TERM_PROGRAM" => "other-terminal"}
    terminology = described_class.new(semantic_version, env)

    expect(terminology.link?).to eq(false)
  end

  it "supports links above the 1.13.0 version" do
    env = {
      "TERM_PROGRAM" => "Terminology",
      "TERM_PROGRAM_VERSION" => "2.3.4"
    }
    terminology = described_class.new(semantic_version, env)

    expect(terminology.link?).to eq(true)
  end

  it "supports links above the 1.3.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.3.1"})
    terminology = described_class.new(semantic_version, env)

    expect(terminology.link?).to eq(true)
  end

  it "supports links on the 1.3.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.3.0"})
    terminology = described_class.new(semantic_version, env)

    expect(terminology.link?).to eq(true)
  end

  it "doesn't support links below the 1.3.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.2.1"})
    terminology = described_class.new(semantic_version, env)

    expect(terminology.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
    terminology = described_class.new(semantic_version, env)

    expect(terminology.link?).to eq(false)
  end

  it "doesn't support links without the term program version env variable" do
    terminology = described_class.new(semantic_version, env_with_name)

    expect(terminology.link?).to eq(false)
  end
end
