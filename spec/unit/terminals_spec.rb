# frozen_string_literal: true

RSpec.describe TTY::Link::Terminals do
  describe ".list" do
    let(:terminal_classes) {
      [
        described_class::Alacritty,
        described_class::Contour,
        described_class::Domterm,
        described_class::Foot,
        described_class::Hyper,
        described_class::Iterm,
        described_class::Jediterm,
        described_class::Kitty,
        described_class::Konsole,
        described_class::Mintty,
        described_class::Rio,
        described_class::Tabby,
        described_class::Terminology,
        described_class::Vscode,
        described_class::Vte,
        described_class::Wezterm,
        described_class::Wt
      ]
    }

    it "enumerates the terminal classes" do
      expect { |block|
        described_class.list(&block)
      }.to yield_successive_args(*terminal_classes)
    end

    it "creates an array with the values from the enumeration" do
      expect(described_class.list(&:to_s)).to eq(terminal_classes.map(&:to_s))
    end
  end
end
