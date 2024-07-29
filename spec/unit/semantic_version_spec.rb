# frozen_string_literal: true

RSpec.describe TTY::Link::SemanticVersion do
  describe ".from" do
    [
      {from: "1234", to: {major: 0, minor: 12, patch: 34}},
      {from: "123", to: {major: 0, minor: 1, patch: 23}},
      {from: "0204", to: {major: 0, minor: 2, patch: 4}},
      {from: "1030", to: {major: 0, minor: 10, patch: 30}},
      {from: "12.34.56", to: {major: 12, minor: 34, patch: 56}},
      {from: "0.1.2", to: {major: 0, minor: 1, patch: 2}},
      {from: "1.0.", to: {major: 1, minor: 0, patch: 0}},
      {from: "1.0", to: {major: 1, minor: 0, patch: 0}},
      {from: "1.", to: {major: 1, minor: 0, patch: 0}},
      {from: "12", to: {major: 12, minor: 0, patch: 0}},
      {from: "1", to: {major: 1, minor: 0, patch: 0}},
      {from: "", to: {major: 0, minor: 0, patch: 0}}
    ].each do |data|
      it "creates #{data[:to]} semantic version from #{data[:from].inspect}" do
        expect(described_class.from(data[:from])).to have_attributes(data[:to])
      end
    end

    it "creates a semantic version from 1-2-3 with a custom separator" do
      sem_ver = described_class.from("1-2-3", separator: "-")

      expect(sem_ver).to have_attributes({major: 1, minor: 2, patch: 3})
    end

    it "creates a semantic version from three integers" do
      sem_ver = described_class.from(1, 2, 3)

      expect(sem_ver).to have_attributes({major: 1, minor: 2, patch: 3})
    end

    it "creates a semantic version from two integers" do
      sem_ver = described_class.from(1, 2)

      expect(sem_ver).to have_attributes({major: 1, minor: 2, patch: 0})
    end

    it "creates a semantic version from single integer" do
      sem_ver = described_class.from(1)

      expect(sem_ver).to have_attributes({major: 1, minor: 0, patch: 0})
    end
  end

  describe ".[]" do
    it "creates a semantic version from three integers" do
      sem_ver = described_class[1, 2, 3]

      expect(sem_ver).to have_attributes({major: 1, minor: 2, patch: 3})
    end

    it "creates a semantic version from two integers" do
      sem_ver = described_class[1, 2]

      expect(sem_ver).to have_attributes({major: 1, minor: 2, patch: 0})
    end

    it "creates a semantic version from single integer" do
      sem_ver = described_class[1]

      expect(sem_ver).to have_attributes({major: 1, minor: 0, patch: 0})
    end
  end

  describe "#<=>" do
    it "is equal with the same type and version" do
      sem_ver = described_class.from(1, 2, 3)
      same_sem_ver = described_class.from(1, 2, 3)

      expect(sem_ver).to eq(same_sem_ver)
    end

    it "isn't equal with the same type and different version" do
      sem_ver = described_class.from(1, 2, 3)
      other_sem_ver = described_class.from(1, 2, 4)

      expect(sem_ver).not_to eq(other_sem_ver)
    end

    it "isn't equal with another object" do
      sem_ver = described_class.from(1, 2, 3)
      other = [1, 2, 3]

      expect(sem_ver).not_to eq(other)
    end

    {
      "1.2.3" => "1.2.3",
      "0.1.2" => "0.1.2",
      "0.0.1" => "0.0.1",
      "1.2.0" => "1.2",
      "0.22.0" => "0.22",
      "1.0.0" => "1",
      "1001" => "1001"
    }.each do |sem_ver, other_sem_ver|
      it "equals #{sem_ver} to #{other_sem_ver}" do
        expect(described_class.from(sem_ver))
          .to eq(described_class.from(other_sem_ver))
      end
    end

    {
      "1.2.4" => "1.2.3",
      "1.3.0" => "1.2.3",
      "2.0.0" => "1.2.3",
      "1.0.0" => "0.1.0",
      "0.1.0" => "0.0.1",
      "0.2.0" => "0.1.2",
      "0.22.0" => "0.1.0",
      "0.0.2" => "0.0.1",
      "0.3.0" => "0.2",
      "0.10" => "0.1",
      "11.0" => "10",
      "1001" => "1000"
    }.each do |sem_ver, other_sem_ver|
      it "compares #{sem_ver} as greater than #{other_sem_ver}" do
        expect(described_class.from(sem_ver))
          .to be > described_class.from(other_sem_ver)
      end
    end
  end

  describe "#hash" do
    it "calculates semantic version hash" do
      sem_ver = described_class.from(1, 2, 3)

      expect(sem_ver.hash).to be_an(Integer)
    end

    it "calculates the same hash for equal semantic versions" do
      sem_ver = described_class.from(1, 2, 3)
      same_sem_ver = described_class.from(1, 2, 3)

      expect(sem_ver.hash).to eq(same_sem_ver.hash)
    end
  end

  describe "#inspect" do
    it "converts a semantic version to a string" do
      sem_ver = described_class.from(1, 2, 3)

      expect(sem_ver.inspect).to eq("1.2.3")
    end
  end
end
