# frozen_string_literal: true

RSpec.describe TTY::Link::ANSILink do
  describe "#to_s" do
    it "creates an ANSI-controlled string without attributes" do
      ansi_link = described_class.new(
        "TTY Toolkit", "https://ttytoolkit.org", {}
      )

      expect(ansi_link.to_s).to eq(
        "\e]8;;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
      )
    end

    it "creates an ANSI-controlled string with an id attribute" do
      ansi_link = described_class.new(
        "TTY Toolkit", "https://ttytoolkit.org", {id: "tty-toolkit"}
      )

      expect(ansi_link.to_s).to eq(
        "\e]8;id=tty-toolkit;https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
      )
    end

    it "creates an ANSI-controlled string with id, lang and title attributes" do
      ansi_link = described_class.new(
        "TTY Toolkit", "https://ttytoolkit.org", {
          id: "tty-toolkit", lang: "en", title: "Terminal Apps The Easy Way"
        }
      )

      expect(ansi_link.to_s).to eq(
        "\e]8;id=tty-toolkit:lang=en:title=Terminal Apps The Easy Way;" \
        "https://ttytoolkit.org\aTTY Toolkit\e]8;;\a"
      )
    end
  end
end
