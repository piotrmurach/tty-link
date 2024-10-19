# frozen_string_literal: true

RSpec.describe TTY::Link::ValueError do
  describe "#to_s" do
    it "creates a message from a parameter name, value and allowed value" do
      value_error = described_class.new(:name, :invalid, %i[valid])

      expect(value_error.to_s).to eq(
        "invalid value for the :name parameter: :invalid.\n" \
        "Must be one of: :valid."
      )
    end

    it "creates a message from a parameter name, value and allowed values" do
      value_error = described_class.new(:name, :invalid, %i[valid_a valid_b])

      expect(value_error.to_s).to eq(
        "invalid value for the :name parameter: :invalid.\n" \
        "Must be one of: :valid_a, :valid_b."
      )
    end
  end
end
