# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Rio, "#link?" do
  let(:env_with_name) { {"TERM_PROGRAM" => "rio"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the term program environment variable" do
    rio = described_class.new(semantic_version, {})

    expect(rio.link?).to eq(false)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    rio = described_class.new(semantic_version, env)

    expect(rio.link?).to eq(false)
  end

  it "doesn't support links with a non-Rio program name" do
    env = {"TERM_PROGRAM" => "other-terminal"}
    rio = described_class.new(semantic_version, env)

    expect(rio.link?).to eq(false)
  end

  it "supports links above the 0.1.8 version" do
    env = {
      "TERM_PROGRAM" => "Rio",
      "TERM_PROGRAM_VERSION" => "0.2.3"
    }
    rio = described_class.new(semantic_version, env)

    expect(rio.link?).to eq(true)
  end

  it "supports links above the 0.0.28 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "0.0.29"})
    rio = described_class.new(semantic_version, env)

    expect(rio.link?).to eq(true)
  end

  it "supports links on the 0.0.28 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "0.0.28"})
    rio = described_class.new(semantic_version, env)

    expect(rio.link?).to eq(true)
  end

  it "doesn't support links below the 0.0.28 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "0.0.27"})
    rio = described_class.new(semantic_version, env)

    expect(rio.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
    rio = described_class.new(semantic_version, env)

    expect(rio.link?).to eq(false)
  end

  it "doesn't support links without the term program version env variable" do
    rio = described_class.new(semantic_version, env_with_name)

    expect(rio.link?).to eq(false)
  end
end
