# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Wezterm, "#link?" do
  let(:env_with_name) { {"TERM_PROGRAM" => "WezTerm"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the term program environment variable" do
    wezterm = described_class.new(semantic_version, {})

    expect(wezterm.link?).to eq(false)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    wezterm = described_class.new(semantic_version, env)

    expect(wezterm.link?).to eq(false)
  end

  it "doesn't support links with a non-WezTerm program name" do
    env = {"TERM_PROGRAM" => "other-terminal"}
    wezterm = described_class.new(semantic_version, env)

    expect(wezterm.link?).to eq(false)
  end

  it "doesn't support links with a different name and a compatible version" do
    env = {
      "TERM_PROGRAM" => "other-terminal",
      "TERM_PROGRAM_VERSION" => "20190101-000000-a1b2c3d4"
    }
    wezterm = described_class.new(semantic_version, env)

    expect(wezterm.link?).to eq(false)
  end

  it "supports links above the 20240203 version" do
    env = {
      "TERM_PROGRAM" => "wezterm",
      "TERM_PROGRAM_VERSION" => "20250403-000000-a1b2c3d4"
    }
    wezterm = described_class.new(semantic_version, env)

    expect(wezterm.link?).to eq(true)
  end

  it "supports links above the 20180218 version" do
    env = env_with_name.merge({
      "TERM_PROGRAM_VERSION" => "20180219-000000-a1b2c3d4"
    })
    wezterm = described_class.new(semantic_version, env)

    expect(wezterm.link?).to eq(true)
  end

  it "supports links on the 20180218 version" do
    env = env_with_name.merge({
      "TERM_PROGRAM_VERSION" => "20180218-000000-a1b2c3d4"
    })
    wezterm = described_class.new(semantic_version, env)

    expect(wezterm.link?).to eq(true)
  end

  it "doesn't support links below the 20180218 version" do
    env = env_with_name.merge({
      "TERM_PROGRAM_VERSION" => "20180217-000000-a1b2c3d4"
    })
    wezterm = described_class.new(semantic_version, env)

    expect(wezterm.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
    wezterm = described_class.new(semantic_version, env)

    expect(wezterm.link?).to eq(false)
  end

  it "doesn't support links without the term program version env variable" do
    wezterm = described_class.new(semantic_version, env_with_name)

    expect(wezterm.link?).to eq(false)
  end

  it "doesn't compare versions without the term program version" do
    semantic_version_spy = class_spy(semantic_version)
    wezterm = described_class.new(semantic_version_spy, env_with_name)

    wezterm.link?

    expect(semantic_version_spy).not_to have_received(:from)
  end
end
