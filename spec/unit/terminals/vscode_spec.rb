# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Vscode, "#link?" do
  let(:env_with_name) { {"TERM_PROGRAM" => "vscode"} }
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the term program environment variable" do
    vscode = described_class.new(semantic_version, {})

    expect(vscode.link?).to eq(false)
  end

  it "doesn't support links without a terminal program name" do
    env = {"TERM_PROGRAM" => nil}
    vscode = described_class.new(semantic_version, env)

    expect(vscode.link?).to eq(false)
  end

  it "doesn't support links with a non-VSCode program name" do
    env = {"TERM_PROGRAM" => "other-terminal"}
    vscode = described_class.new(semantic_version, env)

    expect(vscode.link?).to eq(false)
  end

  it "supports links above the 1.92.2 version" do
    env = {
      "TERM_PROGRAM" => "VSCode",
      "TERM_PROGRAM_VERSION" => "2.3.4"
    }
    vscode = described_class.new(semantic_version, env)

    expect(vscode.link?).to eq(true)
  end

  it "supports links above the 1.72.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.72.1"})
    vscode = described_class.new(semantic_version, env)

    expect(vscode.link?).to eq(true)
  end

  it "supports links on the 1.72.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.72.0"})
    vscode = described_class.new(semantic_version, env)

    expect(vscode.link?).to eq(true)
  end

  it "doesn't support links below the 1.72.0 version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => "1.71.2"})
    vscode = described_class.new(semantic_version, env)

    expect(vscode.link?).to eq(false)
  end

  it "doesn't support links without a version" do
    env = env_with_name.merge({"TERM_PROGRAM_VERSION" => nil})
    vscode = described_class.new(semantic_version, env)

    expect(vscode.link?).to eq(false)
  end

  it "doesn't support links without the term program version env variable" do
    vscode = described_class.new(semantic_version, env_with_name)

    expect(vscode.link?).to eq(false)
  end
end
