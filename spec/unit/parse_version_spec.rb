# frozen_string_literal: true

RSpec.describe TTY::Link, "#parse_version" do

  [
    {from: "4602", to: {major: 0, minor: 46, patch: 2}},
    {from: "5104", to: {major: 0, minor: 51, patch: 4}},
    {from: "0.51.0", to: {major: 0, minor: 51, patch: 0}},
  ].each do |data|
    it "parses #{data[:from]} to #{data[:to]}" do
      expect(TTY::Link.parse_version(data[:from])).to eq(data[:to])
    end
  end
end
