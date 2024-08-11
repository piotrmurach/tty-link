# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Iterm, "#link?" do
  let(:env_with_name) { {"TERM_PROGRAM" => "iTerm.app"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "supports a terminal program name with a version number" do
    env = {
      "TERM_PROGRAM" => "iTerm 2.app",
      "TERM_PROGRAM_VERSION" => "4.3.2"
    }
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(true)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(false)
  end

  it "doesn't support links with a non-iTerm program name" do
    env = {"TERM_PROGRAM" => "non-iTerm"}
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(false)
  end

  it "supports links above the 4.3.2 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "4.3.2"})
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(true)
  end

  it "supports links above the 3.1.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.2.1"})
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(true)
  end

  it "supports links on the 3.1.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.1.0"})
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(true)
  end

  it "doesn't support links on the 3.0.1 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "3.0.1"})
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(false)
  end

  it "doesn't support links below the 3.1.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "2.3.4"})
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
    iterm = described_class.new(semantic_version, env)

    expect(iterm.link?).to eq(false)
  end
end
