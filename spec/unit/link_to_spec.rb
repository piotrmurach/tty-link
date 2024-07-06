# frozen_string_literal: true

RSpec.describe TTY::Link, "#link_to" do
  let(:output) { double(:output, tty?: true) }

  it "creates a terminal link" do
    allow(described_class).to receive(:support_link?)
      .with(output: output).and_return(true)

    link = described_class.link_to("TTY Toolkit", "https://ttytoolkit.org",
                                   output: output)

    expect(link).to eql("\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a")
  end

  it "fails to create a terminal link" do
    allow(described_class).to receive(:support_link?)
      .with(output: output).and_return(false)

    link = described_class.link_to("TTY Toolkit", "https://ttytoolkit.org",
                                   output: output)

    expect(link).to eql("TTY Toolkit -> https://ttytoolkit.org")
  end
end
