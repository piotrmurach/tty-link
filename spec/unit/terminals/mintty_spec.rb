# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Mintty, "#link?" do
  let(:env_with_name) { {"TERM_PROGRAM" => "mintty"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the term program environment variable" do
    mintty = described_class.new(semantic_version, {})

    expect(mintty.link?).to eq(false)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    mintty = described_class.new(semantic_version, env)

    expect(mintty.link?).to eq(false)
  end

  it "doesn't support links with a non-mintty program name" do
    env = {"TERM_PROGRAM" => "other-terminal"}
    mintty = described_class.new(semantic_version, env)

    expect(mintty.link?).to eq(false)
  end

  it "supports links above the 3.7.4 version" do
    env = {
      "TERM_PROGRAM" => "MinTTY",
      "TERM_PROGRAM_VERSION" => "3.8.5"
    }
    mintty = described_class.new(semantic_version, env)

    expect(mintty.link?).to eq(true)
  end

  it "supports links above the 2.9.7 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.9.8"})
    mintty = described_class.new(semantic_version, env)

    expect(mintty.link?).to eq(true)
  end

  it "supports links on the 2.9.7 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.9.7"})
    mintty = described_class.new(semantic_version, env)

    expect(mintty.link?).to eq(true)
  end

  it "doesn't support links below the 2.9.7 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.9.6"})
    mintty = described_class.new(semantic_version, env)

    expect(mintty.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
    mintty = described_class.new(semantic_version, env)

    expect(mintty.link?).to eq(false)
  end

  it "doesn't support links without the term program version env variable" do
    mintty = described_class.new(semantic_version, env_with_name)

    expect(mintty.link?).to eq(false)
  end
end
