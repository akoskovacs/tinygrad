# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe TinyGrad::Value do
  subject { described_class.new(1) }

  it { is_expected.to respond_to(:+) }
  it { is_expected.to respond_to(:*) }
  it { is_expected.to respond_to(:to_s) }
  it { is_expected.to respond_to(:data) }
  it { expect(subject.data).to eq(1) }
  it { expect(subject.to_s).to eq("Value(data: 1.0)") }

  describe "#new" do
    xit "raises error for non-float arguments" do
      expect do
        described_class.new("wooo")
      end.to raise_error(ArgumentError, "data parameter is not a float")
    end

    it "can be labelled" do
      x = described_class.new(10, label: "x")
      expect(x.label).to be("x")
    end

    it "can allows label modification" do
      x = described_class.new(10, label: "x")
      expect(x.label).to be("x")
      x.label = "X"
      expect(x.label).to be("X")
    end
  end

  describe "#+" do
    let(:a) { described_class.new(2) }
    let(:b) { described_class.new(3) }
    let(:c) { a + b }

    it "raises error if the other argument is not a float" do
      expect do
        a + 22
      end.to raise_error(ArgumentError, "right value of '+' is not a Value")
    end

    it "the type is Value" do
      expect(c).to be_a(described_class)
    end

    it "can add two numbers" do
      expect(c.data).to eq(5.0)
    end

    it "has the right children" do
      expect(c.children[0]).to eq(a)
      expect(c.children[1]).to eq(b)
    end

    it "has the right operation" do
      expect(c.op.name).to eq("+")
    end
  end

  describe "#*" do
    let(:a) { described_class.new(2) }
    let(:b) { described_class.new(3) }
    let(:c) { a * b }

    it "raises error if the other argument is not a float" do
      expect do
        a * 22
      end.to raise_error(ArgumentError, "right value of '*' is not a Value")
    end

    it "the type is Value" do
      expect(c).to be_a(described_class)
    end

    it "can multiply two numbers" do
      expect(c.data).to eq(6.0)
    end

    it "has the right children" do
      expect(c.children[0]).to eq(a)
      expect(c.children[1]).to eq(b)
    end

    it "has the right operation" do
      expect(c.op.name).to eq("*")
    end
  end

  context "in expressions" do
    let(:a) { described_class.new(2, label: "a") }
    let(:b) { described_class.new(-3, label: "b") }
    let(:c) { described_class.new(10, label: "c") }
    let(:d) { a * b + c }

    it "the type is Value" do
      expect(d).to be_a(described_class)
    end

    it "can do the right operations" do
      expect(d.data).to eq(4.0)
    end

    it "has the right children" do
      expect(d.children).to include(c)
      expect(d.children.size).to eq(2)
    end

    it "has the right operation" do
      expect(d.op.name).to eq("+")
    end
  end
end
