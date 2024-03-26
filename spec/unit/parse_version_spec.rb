# frozen_string_literal: true

RSpec.describe TTY::Link, "#parse_version" do
  [
    {from: "1234", to: {major: 0, minor: 12, patch: 34}},
    {from: "123", to: {major: 0, minor: 1, patch: 23}},
    {from: "0204", to: {major: 0, minor: 2, patch: 4}},
    {from: "1030", to: {major: 0, minor: 10, patch: 30}},
    {from: "12.34.56", to: {major: 12, minor: 34, patch: 56}},
    {from: "0.1.2", to: {major: 0, minor: 1, patch: 2}},
    {from: "1.0.", to: {major: 1, minor: 0, patch: nil}},
    {from: "1.0", to: {major: 1, minor: 0, patch: nil}},
    {from: "1.", to: {major: 1, minor: nil, patch: nil}},
    {from: "12", to: {major: 12, minor: nil, patch: nil}},
    {from: "1", to: {major: 1, minor: nil, patch: nil}},
    {from: "", to: {major: nil, minor: nil, patch: nil}}
  ].each do |data|
    it "parses #{data[:from].inspect} to #{data[:to]}" do
      expect(described_class.parse_version(data[:from])).to eq(data[:to])
    end
  end
end
