# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Hyper, "#link?" do
  let(:env_with_name) { {"TERM_PROGRAM" => "Hyper"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the term program environment variable" do
    hyper = described_class.new(semantic_version, {})

    expect(hyper.link?).to eq(false)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    hyper = described_class.new(semantic_version, env)

    expect(hyper.link?).to eq(false)
  end

  it "doesn't support links with a non-Hyper program name" do
    env = {"TERM_PROGRAM" => "other-terminal"}
    hyper = described_class.new(semantic_version, env)

    expect(hyper.link?).to eq(false)
  end

  it "supports links above the 3.0.0 version" do
    env = {
      "TERM_PROGRAM" => "hyper",
      "TERM_PROGRAM_VERSION" => "3.4.1"
    }
    hyper = described_class.new(semantic_version, env)

    expect(hyper.link?).to eq(true)
  end

  it "supports links above the 2.0.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.0.1"})
    hyper = described_class.new(semantic_version, env)

    expect(hyper.link?).to eq(true)
  end

  it "supports links on the 2.0.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.0.0"})
    hyper = described_class.new(semantic_version, env)

    expect(hyper.link?).to eq(true)
  end

  it "doesn't support links below the 2.0.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.4.8"})
    hyper = described_class.new(semantic_version, env)

    expect(hyper.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
    hyper = described_class.new(semantic_version, env)

    expect(hyper.link?).to eq(false)
  end

  it "doesn't support links without the term program version env variable" do
    hyper = described_class.new(semantic_version, env_with_name)

    expect(hyper.link?).to eq(false)
  end
end
