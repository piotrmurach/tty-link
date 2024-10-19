# frozen_string_literal: true

RSpec.describe TTY::Link::HyperlinkParameter do
  describe ".new" do
    it "validates a parameter value against allowed values" do
      expect {
        described_class.new(:invalid)
      }.to raise_error(
        TTY::Link::ValueError,
        "invalid value for the :hyperlink parameter: :invalid.\n" \
        "Must be one of: :always, :auto, :never."
      )
    end
  end

  describe "#always?" do
    it "creates a parameter with the :always value" do
      hyperlink_parameter = described_class.new(:always)

      expect(hyperlink_parameter)
        .to have_attributes(always?: true, auto?: false, never?: false)
    end

    it "creates a parameter with the \"always\" value" do
      hyperlink_parameter = described_class.new("always")

      expect(hyperlink_parameter)
        .to have_attributes(always?: true, auto?: false, never?: false)
    end
  end

  describe "#auto?" do
    it "creates a parameter with the :auto value" do
      hyperlink_parameter = described_class.new(:auto)

      expect(hyperlink_parameter)
        .to have_attributes(always?: false, auto?: true, never?: false)
    end

    it "creates a parameter with \"auto\" value" do
      hyperlink_parameter = described_class.new("auto")

      expect(hyperlink_parameter)
        .to have_attributes(always?: false, auto?: true, never?: false)
    end
  end

  describe "#never?" do
    it "creates a parameter with the :never value" do
      hyperlink_parameter = described_class.new(:never)

      expect(hyperlink_parameter)
        .to have_attributes(always?: false, auto?: false, never?: true)
    end

    it "creates a parameter with the \"never\" value" do
      hyperlink_parameter = described_class.new("never")

      expect(hyperlink_parameter)
        .to have_attributes(always?: false, auto?: false, never?: true)
    end
  end
end
