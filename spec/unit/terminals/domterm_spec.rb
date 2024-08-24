# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals::Domterm, "#link?" do
  let(:semantic_version) { TTY::Link::SemanticVersion }

  it "doesn't support links without the domterm environment variable" do
    domterm = described_class.new(semantic_version, {})

    expect(domterm.link?).to eq(false)
  end

  it "supports links above the 3.2.0 version" do
    env = {"DOMTERM" => "QtDomTerm;version=3.4.0;tty=/dev/pts/1"}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(true)
  end

  it "supports links above the 1.0.2 version" do
    env = {"DOMTERM" => "QtDomTerm;Version=1.1.0;tty=/dev/pts/1"}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(true)
  end

  it "supports links on the 1.0.2 version" do
    env = {"DOMTERM" => "QtDomTerm;version=1.0.2;tty=/dev/pts/1"}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(true)
  end

  it "doesn't support links below the 1.0.2 version" do
    env = {"DOMTERM" => "QtDomTerm;version=1.0.1;tty=/dev/pts/1"}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(false)
  end

  it "doesn't support links without a version separator" do
    env = {"DOMTERM" => "QtDomTerm;version1.0.2;tty=/dev/pts/1"}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(false)
  end

  it "doesn't support links without a version value" do
    env = {"DOMTERM" => "QtDomTerm;version=;tty=/dev/pts/1"}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(false)
  end

  it "doesn't support links without a version separator and value" do
    env = {"DOMTERM" => "QtDomTerm;version;tty=/dev/pts/1"}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(false)
  end

  it "doesn't support links without a version parameter, separator and value" do
    env = {"DOMTERM" => "QtDomTerm;tty=/dev/pts/1"}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(false)
  end

  it "doesn't support links without the domterm environment variable value" do
    env = {"DOMTERM" => nil}
    domterm = described_class.new(semantic_version, env)

    expect(domterm.link?).to eq(false)
  end
end
