# frozen_string_literal: true

RSpec.describe TTY::Link::AbstractMethodError do
  describe "#to_s" do
    it "creates a message from the class and method names" do
      abstract_method_error = described_class.new("Custom", :custom)

      expect(abstract_method_error.to_s).to eq(
        "the Custom class must implement the custom method."
      )
    end
  end
end
