# frozen_string_literal: true

RSpec.describe TTY::Link, "#support_link" do
  it "supports links in iTerm" do
    allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("iTerm.app")
    allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION").and_return("3.3.1")

    expect(TTY::Link.support_link?).to eq(true)
  end

  it "support links in iTerm" do
    allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("iTerm.app")
    allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION").and_return("3.1.0")

    expect(TTY::Link.support_link?).to eq(true)
  end

  it "doesn't support links in iTerm below 3.0.0"  do
    allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("iTerm.app")
    allow(ENV).to receive(:[]).with("TERM_PROGRAM_VERSION").and_return("3.0.0")

    expect(TTY::Link.support_link?).to eq(false)
  end

  it "supports links in VTE terminal above 0.50.0" do
    allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("GNU")
    allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("0.50.1")

    expect(TTY::Link.support_link?).to eq(true)
  end

  it "supports links in VTE terminal above 0.51.0" do
    allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("GNU")
    allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("0.51.0")

    expect(TTY::Link.support_link?).to eq(true)
  end

  it "supports links in VTE terminal above 1.0.0" do
    allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("GNU")
    allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("1.0.0")

    expect(TTY::Link.support_link?).to eq(true)
  end

  it "doesn't support links in VTE terminal below 0.50.0" do
    allow(ENV).to receive(:[]).with("TERM_PROGRAM").and_return("GNU")
    allow(ENV).to receive(:[]).with("VTE_VERSION").and_return("0.50.0")

    expect(TTY::Link.support_link?).to eq(false)
  end
end
