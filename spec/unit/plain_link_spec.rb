# frozen_string_literal: true

RSpec.describe TTY::Link::PlainLink do
  describe "#to_s" do
    it "creates a plain string with name and url tokens" do
      plain_link = described_class.new(
        "TTY Toolkit", "https://ttytoolkit.org", ":name (:url)"
      )

      expect(plain_link.to_s).to eq("TTY Toolkit (https://ttytoolkit.org)")
    end

    it "creates a plain string with only a name token" do
      plain_link = described_class.new(
        "TTY Toolkit", "https://ttytoolkit.org", ":name"
      )

      expect(plain_link.to_s).to eq("TTY Toolkit")
    end

    it "creates a plain string with only a url token" do
      plain_link = described_class.new(
        "TTY Toolkit", "https://ttytoolkit.org", ":url"
      )

      expect(plain_link.to_s).to eq("https://ttytoolkit.org")
    end

    it "creates a plain string with no tokens" do
      plain_link = described_class.new(
        "TTY Toolkit", "https://ttytoolkit.org", "alternative url"
      )

      expect(plain_link.to_s).to eq("alternative url")
    end
  end
end
